
.PHONY: submodule_update
submodule_update:
	@git submodule -q foreach git pull -q origin master
