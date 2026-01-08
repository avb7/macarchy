# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                            MACARCHY MAKEFILE                              ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

.PHONY: install uninstall start stop restart status apply theme doctor update help

SHELL := /bin/bash
MACARCHY_DIR := $(shell pwd)

# ─────────────────────────────────────────────────────────────────────────────
# INSTALLATION
# ─────────────────────────────────────────────────────────────────────────────

install:
	@./install.sh

uninstall:
	@./uninstall.sh

# ─────────────────────────────────────────────────────────────────────────────
# SERVICE MANAGEMENT
# ─────────────────────────────────────────────────────────────────────────────

start:
	@./bin/macarchy start

stop:
	@./bin/macarchy stop

restart:
	@./bin/macarchy restart

status:
	@./bin/macarchy status

# ─────────────────────────────────────────────────────────────────────────────
# CONFIGURATION
# ─────────────────────────────────────────────────────────────────────────────

apply:
	@./bin/macarchy apply

reload: apply

theme:
	@./bin/macarchy theme

theme-%:
	@./bin/macarchy theme $*

config:
	@./bin/macarchy config

# ─────────────────────────────────────────────────────────────────────────────
# MAINTENANCE
# ─────────────────────────────────────────────────────────────────────────────

doctor:
	@./bin/macarchy doctor

update:
	@./bin/macarchy update

# ─────────────────────────────────────────────────────────────────────────────
# HELP
# ─────────────────────────────────────────────────────────────────────────────

help:
	@./bin/macarchy help

.DEFAULT_GOAL := help
