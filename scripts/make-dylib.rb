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
            "-scheme \"#{target_arg}\"",
            '-configuration Debug',
            '-derivedDataPath build',
            'SYMROOT=build',
            "SDKROOT=#{sdk}",
            "ARCHS=\"armv7 armv7s arm64\"",
            "VALID_ARCHS=\"armv7 armv7s arm64\"",
            "ONLY_ACTIVE_ARCH=NO",
            xcpretty_available ? '| xcpretty -c && exit ${PIPESTATUS[0]}' : ''
      ].join(' ')

exec "xcrun xcodebuild #{args}"
