SHELLCHECK ?= $(shell command -v shellcheck)
SHFMT ?= $(shell command -v shfmt)
EDITORCONFIG_CHECKER ?= $(shell command -v editorconfig-checker)
MARKDOWNLINT ?= $(shell command -v markdownlint)

.PHONY: check
check:
	$(EDITORCONFIG_CHECKER)
	$(MARKDOWNLINT) -c .markdownlint.jsonc *.md
	$(SHELLCHECK) *.bash
	$(SHFMT) --indent 4 --binary-next-line --case-indent --write *.bash
