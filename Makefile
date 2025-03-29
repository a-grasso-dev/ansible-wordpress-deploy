.SILENT:

include .manala/Makefile

#########
# Setup #
#########

# ## Project - Setup
# setup: setup.ansible

# ## Project - Setup ansible
# setup.ansible: SHELL := $(MANALA_DOCKER_SHELL)
# setup.ansible:
# 	ansible-galaxy install \
# 		--verbose \
# 		-r requirements.yaml

# ## Ansible - Installation des collections nécessaires
setup.ansible:
	ansible-galaxy collection install -r collections/requirements.yml --collections-path ./collections

# ## Projet - Initialisation complète
setup: setup.ansible
