.PHONY: help run install test release clean

help:
	@printf 'Fmux commands:\n'
	@printf '  make run      Build a local app bundle and open it\n'
	@printf '  make install  Build, install to /Applications, and open it\n'
	@printf '  make test     Run the Swift test suite\n'
	@printf '  make release  Build release zip, dmg, and checksum artifacts\n'
	@printf '  make clean    Remove build artifacts\n'

run:
	@./script/build_and_run.sh

install:
	@bash ./script/install.sh

test:
	@swift test

release:
	@./script/build_release.sh

clean:
	@rm -rf .build dist
