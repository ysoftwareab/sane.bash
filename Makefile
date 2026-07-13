SHELLCHECK ?= $(shell command -v shellcheck)
SHFMT ?= $(shell command -v shfmt)
EDITORCONFIG_CHECKER ?= $(shell command -v editorconfig-checker)
MARKDOWNLINT ?= $(shell command -v markdownlint)

BASH_FILES = \
	$(wildcard *.bash) \
	$(wildcard */*.bash) \
	$(wildcard */*/*.bash) \
	$(filter-out %.md,$(shell grep -l '^#!.*bash' $(shell git ls-files)))

MD_FILES = \
	$(wildcard *.md) \
	$(wildcard */*.md) \
	$(wildcard */*/*.md)

.PHONY: check
check:
	$(EDITORCONFIG_CHECKER)
	$(MARKDOWNLINT) -c .markdownlint.jsonc $(MD_FILES) || { \
		$(MARKDOWNLINT) -c .markdownlint.jsonc $(MD_FILES) --fix; \
		exit 1; \
	}
	$(SHELLCHECK) $(BASH_FILES)
	$(SHFMT) --indent 4 --binary-next-line --case-indent --diff $(BASH_FILES) || { \
		$(SHFMT) --indent 4 --binary-next-line --case-indent --write $(BASH_FILES); \
		exit 1; \
	}
