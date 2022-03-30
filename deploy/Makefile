RESOURCE_GROUP		?= myazure-rg
LOCATION		?= eastus2

BICEP			:= bicep
AZ			:= az
DEPLOY_NAME		= $(shell date +'deploy-%d%H%M%S')
LOG_DATE		:= $(shell date +'%d%H%M%S')
LOG_FILE		?= "logs/logs-"$(LOG_DATE).log
SSH_KEY_FILE		:= .secure/vm-keys
MY_IP_ADDRESS		:= $(shell curl -s 'https://api.ipify.org')
OPTIONS			= "-p adminSshKey=@$(SSH_KEY_FILE).pub"
VM_USER_NAME		?= azureuser
VM_SSH_AUTHORIZED_KEYS	?= $(shell cat ~/.ssh/id_rsa.pub | cut -d ' ' -f 1,2)

BASTION_HOST		?= $(shell az resource list -g $(RESOURCE_GROUP) --resource-type Microsoft.Network/bastionHosts --query '[0].name' -o tsv)
VM_ID			?= $(shell az resource list -g $(RESOURCE_GROUP) --resource-type Microsoft.Compute/virtualMachines --query '[0].id' -o tsv)
VM_FQDN			?= $(shell az resource list -g $(RESOURCE_GROUP) --resource-type Microsoft.Compute/virtualMachines)

CT			= docker run --rm -i quay.io/coreos/ct:latest-dev --platform=azure
#AZ			= docker run --rm -i -v $${HOME}/.azure:/root/.azure:ro mcr.microsoft.com/azure-cli az

AZURE_CORE_OUTPUT ?= table
export AZURE_CORE_OUTPUT
export AZURE_CORE_NO_COLOR = True

.DEFAULT_GOAL := help

help:           ## Show this help.
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

%.json: %.bicep
	@$(BICEP) build $<

az-deploy: setup
	($(AZ) deployment group $(CMD) -g $(RESOURCE_GROUP) -n $(DEPLOY_NAME) \
		-f $(SOURCE) $(AZ_OPTIONS) --query properties.outputs -o json | tee ./.secure/deploy-results.json) 2>&1

$(SSH_KEY_FILE):
	@mkdir -p .secure
	@chmod 0700 .secure
	@echo -e 'y' | ssh-keygen -f $(SSH_KEY_FILE) -N "" > /dev/null

az-account:
	$(AZ) account list -o table

%.deploy: %.bicep setup
	$(MAKE) az-deploy CMD="create" SOURCE=$< LOG_FILE=$(LOG_FILE) AZ_OPTIONS=$(OPTIONS) | tee -a $(LOG_FILE)

%.whatif: %.bicep setup
	# CMD="what-if --no-pretty-print"
	-@$(MAKE) az-deploy CMD="what-if" SOURCE=$< LOG_FILE=$(LOG_FILE) AZ_OPTIONS=$(OPTIONS) | tee -a $(LOG_FILE)
	#@grep -q Nochange $(LOG_FILE)

.PHONY: setup
setup: $(SSH_KEY_FILE) config.ign securityRules.json

create-rg:	## create resource group
	$(AZ) group create -l $(LOCATION) -g $(RESOURCE_GROUP)

clean:
	az group delete -g $(RESOURCE_GROUP)

config.ign: config.yml
	cat $< | $(CT) > $@

securityRules.json: securityRules.tmpl.json
	export MY_IP_ADDRESS=$(MY_IP_ADDRESS); \
	cat $< | envsubst > $@

config.yml: config.tmpl.yml
	export VM_USER_NAME="$(VM_USER_NAME)"; \
	export VM_SSH_AUTHORIZED_KEYS="$(VM_SSH_AUTHORIZED_KEYS)"; \
	cat $< | envsubst > $@

deploy:		## Deploy all
deploy: main.deploy

what-if:	## What if all
what-if: main.whatif

ssh:
	az network bastion ssh --name $(BASTION_HOST) --resource-group $(RESOURCE_GROUP) \
	--target-resource-id $(VM_ID) \
	--auth-type ssh-key --username core --ssh-key ./.secure/vm-keys

