LOGFILE=/tmp/dotfiles.log

# Setup helper variables
export SOURCE_DIR := $(CURDIR)
export SCRIPTS_DIR := $(CURDIR)/scripts

# Logging helpers
export LOGGER := $(SCRIPTS_DIR)/log_status.fish
LOG_STATUS = "${LOGGER}" status
LOG_INFO = "${LOGGER}" info
LOG_DEBUG = "${LOGGER}" debug

# Default goal is to "apply"
default: apply

# Setup directories based on target being run.
# This eliminates the need to constantly input vault credentials
ifeq (secrets,$(findstring secrets, $(MAKECMDGOALS)))
export SECRETS?=1
export CFG_FILE?=$(HOME)/.config/chezmoi/clbancro-secrets/chezmoi.yaml
else
export CFG_FILE?=$(HOME)/.config/chezmoi/clbancro-default/chezmoi.yaml
endif

export DRYRUN?=FALSE

.PHONY: install-tools
install-tools:
	@$(LOG_STATUS) "Installing required tools.."
	@fish ./scripts/install_tools.fish | tee -a $(LOGFILE) || exit 1

.PHONY: start-deps
start-deps:
	@$(LOG_STATUS) "Ensuring dependencies.."

.PHONY: ensure-deps
ensure-deps: | start-deps install-tools

.PHONY: init
init: | ensure-deps
	@$(LOG_STATUS) "initializing Chezmoi state"
	@$(SCRIPTS_DIR)/chez.fish init

.PHONY: reinit
reinit: export REINIT=true
reinit: | ensure-deps
	@$(LOG_STATUS) "reinitializing Chezmoi state: REINIT=${REINIT}"
	@$(SCRIPTS_DIR)/chez.fish init

BOLTDB_FILE := $(dir $(CFG_FILE))chezmoistate.boltdb
$(BOLTDB_FILE):
	@$(LOG_STATUS) "initializing chezmoi.."
	@$(SCRIPTS_DIR)/chez.fish init

.PHONY: apply
apply: | ensure-deps $(BOLTDB_FILE)
	@$(LOG_STATUS) "Applying chezmoi"
	@$(SCRIPTS_DIR)/chez.fish apply

.PHONY: status
status: | ensure-deps $(BOLTDB_FILE)
	@$(LOG_STATUS) "fetching Chezmoi status"
	@$(SCRIPTS_DIR)/chez.fish status

.PHONY: verify
verify: | ensure-deps $(BOLTDB_FILE)
	@$(LOG_STATUS) "verifying Chezmoi state"
	@$(SCRIPTS_DIR)/chez.fish verify

.PHONY: secrets
secrets:
	@$(LOG_STATUS) "Using secrets config"

.PHONY: post-chezmoi
post-chezmoi:
	@$(LOG_STATUS) "Starting post-apply actions"
	@$(LOG_STATUS) "Post-apply setup complete"
