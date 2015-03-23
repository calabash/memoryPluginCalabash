#!/usr/bin/env ruby

require 'fileutils'

def log_unix_cmd(msg)
  puts "\033[36mEXEC: #{msg}\033[0m" if msg
end

def log_pass(msg)
  puts "\033[32mPASS: #{msg}\033[0m" if msg
end

def log_fail(msg)
  puts "\033[31mFAIL: #{msg}\033[0m" if msg
end

def log_info(msg)
  puts "\033[34mINFO: #{msg}\033[0m" if msg
end

xcpretty_available = `gem list xcpretty -i`.chomp == 'true'

arches = {
  'iphoneos' =>
  {
    :arches =>  "\"armv7 armv7s arm64\"",
    :scheme => 'Device',
    :target => 'memoryPluginCalabashDevice'
  },

  'iphonesimulator' =>
  {
    :arches =>  "\"i386 x86_64\"",
    :scheme => 'Simulator',
    :target => 'memoryPluginCalabashSim'
  },
}

code_signing_identity = lambda do
  env = ENV['CODE_SIGN_IDENTITY']
  if env
    "CODE_SIGN_IDENTITY=\"#{env}\""
  else
    ''
  end
end.call

puts code_signing_identity

sdks = ['iphoneos', 'iphonesimulator']

sdks.each do |sdk|

  build_dir = "./build/Build/Products/Debug-#{sdk}"

  FileUtils.mkdir_p build_dir

  log_info "Building #{sdk} target to '#{build_dir}'"

  args =
    [
      code_signing_identity,
      "-target \"#{arches[sdk][:target]}\"",
      "-scheme \"#{arches[sdk][:scheme]}\"",
      '-configuration Debug',
      '-derivedDataPath build',
      '-SYMROOT=build',
      "-sdk #{sdk}",
      "ARCHS=#{arches[sdk][:arches]}",
      "VALID_ARCHS=#{arches[sdk][:arches]}",
      'ONLY_ACTIVE_ARCH=NO',
      xcpretty_available ? '| xcpretty -c && exit ${PIPESTATUS[0]}' : ''
  ].join(' ')

    cmd = "xcrun xcodebuild #{args}"
    log_unix_cmd cmd
    success = system cmd
    exit_code = $?.exitstatus
    if success
      log_pass "Built dylib for '#{sdk}'"
    else
      log_fail "Could not build dylib for '#{sdk}'; exiting '#{exit_code}'"
      exit exit_code
    end
end

log_info 'Making a FAT dylib for arm and i386/x86_64'

sim = "./build/Build/Products/Debug-iphonesimulator/#{arches['iphonesimulator'][:target]}.dylib"
device = "./build/Build/Products/Debug-iphoneos/#{arches['iphoneos'][:target]}.dylib"
combined = 'memoryPluginCalabash.dylib'
cmd = "xcrun lipo -create #{sim} #{device} -output #{combined}"

log_unix_cmd cmd
success = system cmd
exit_code = $?

  if success
    log_pass "Built dylib to './#{combined}'"
    info = `xcrun lipo -info #{combined}`.strip
    log_pass info
else
  log_fail "Could not create a FAT dylib; exiting '#{exit_code}'"
  exit exit_code
end
