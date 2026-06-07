.PHONY: help run install

help:
	@printf 'Fmux commands:\n'
	@printf '  make run      Build a local app bundle and open it\n'
	@printf '  make install  Build, install to /Applications, and open it\n'

run:
	@./script/build_and_run.sh

install:
	@bash ./script/install.sh
