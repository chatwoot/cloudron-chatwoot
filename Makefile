CLOUDRON_APP ?= chatwoot
CLOUDRON_ID := $(shell jq -r .id CloudronManifest.json)
DOCKER_REPO ?= vishnun

.PHONY: default
default: build update

.PHONY: init
init:
	cloudron init

.PHONY: build
build:
	cloudron build --set-repository $(DOCKER_REPO)/$(CLOUDRON_ID)

.PHONY: update
update: build
	cloudron update --app ${CLOUDRON_APP}

.PHONY: install
install:
	cloudron install --location ${CLOUDRON_APP}

.PHONY: uninstall
uninstall:
	cloudron uninstall --app ${CLOUDRON_APP}

.PHONY: install-debug
install-debug:
	cloudron install --location ${CLOUDRON_APP} --debug

.PHONY: exec
exec:
	cloudron exec --app ${CLOUDRON_APP}

.PHONY: logs
logs:
	cloudron logs -f --app ${CLOUDRON_APP}
