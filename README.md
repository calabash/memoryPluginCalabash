## memoryPluginCalabash

An example plug-in for Calabash.

### Building

```
$ make dylib

# If you see output like this:
#
# iPhone Developer: ambiguous (matches "iPhone Developer: Person A (2<snip>Q)"
#                                  and "iPhone Developer: Person B (8<snip>F)"
# in /Users/<snip>/Library/Keychains/login.keychain)
#
# run 'make' with a CODE_SIGN_IDENTITY.

$ CODE_SIGN_IDENTITY="iPhone Developer: Your Name (8Q<snip>9F)" make dylib
```

### Installing

Copy and add the resulting `memoryPluginCalabash.dylib` to your Xcode project.
