all:
	$(MAKE) dylib

clean:
	rm -rf build
	rm -f memoryPluginCalabash.dylib

dylib:
	$(MAKE) clean
	scripts/make-dylib.rb
