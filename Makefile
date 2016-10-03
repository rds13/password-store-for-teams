.DEFAULT_GOAL := help

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: import-and-sign
import-and-sign: ## Import in GPG all keys from the list of allowed keys
	$(foreach var,$(shell find . -name .gpg-id | xargs cat | sort | uniq), \
		( \
			gpg --list-public-key $(var) \
		) && \
		gpg --sign-key $(var); \
	)

.PHONY: list-keys
list-keys: ## List all the keys in the store with ID and names
	@for key in $$(cat .gpg-id); do \
		printf "$${key}: "; \
		gpg --list-keys --with-colons $$key 2> /dev/null | awk -F: '/^pub/ {found = 1; print $$10} END {if (found != 1) {print "*** not found in local keychain ***"}}'; \
	done

.PHONY: check-pass-store
check-pass-store: ## Check if you can read all the keys
	@for i in $$(find . -name '*.gpg' | sed 's/\.gpg$$//;s/^.\///'); do \
		echo "Checking $$i"; \
		PASSWORD_STORE_DIR=$$(pwd) pass $$i > /dev/null || exit 1; \
	done
	@echo "OK: All password entries are readable"
