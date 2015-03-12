#!/usr/bin/env ruby
require 'fileutils'

target = 'device'
target_arg = 'memoryPluginCalabash'
sdk = 'iphoneos'

xcpretty_available = `gem list xcpretty -i`.chomp == 'true'

# dylib target does _not_ create necessary directories
FileUtils.mkdir_p "./build/Debug-#{sdk}"

args =
      [
            "-target \"#{target_arg}\"",
            '-configuration Debug',
            'SYMROOT=build',
            "SDKROOT=#{sdk}",
            'IPHONEOS_DEPLOYMENT_TARGET=5.1.1',
            xcpretty_available ? '| xcpretty -c' : ''
      ].join(' ')

system "xcrun xcodebuild #{args}"
exit $?.exitstatus
