all:
	$(MAKE) dylibs
clean:
	rm -rf build
	rm -rf dylibs

dylibs:
	rm -rf build
	rm -rf dylibs
	scripts/make-dylib.rb
