# ==============================================================================
# Pixielity Framework - Makefile
# ==============================================================================
#
# This Makefile provides convenient shortcuts for common development tasks.
# All commands are designed to work with the monorepo structure and integrate
# with Composer scripts for consistency.
#
# Usage:
#   make help          Show all available commands
#   make install       Install all dependencies
#   make test          Run the test suite
#   make ci            Run continuous integration checks
#
# Requirements:
#   - GNU Make 3.81+
#   - PHP 8.3+
#   - Composer 2.0+
#
# ==============================================================================

.PHONY: help install update test test-unit test-integration test-coverage \
        analyse format format-check rector rector-fix mutate audit validate \
        ci ci-full clean clean-all dump

# Default target - show help when running 'make' without arguments
.DEFAULT_GOAL := help

# ==============================================================================
# COLORS FOR TERMINAL OUTPUT
# ==============================================================================
# These color codes make the output more readable and visually appealing
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
NC := \033[0m # No Color (reset)

# ==============================================================================
# HELP TARGET
# ==============================================================================
# Automatically generates help documentation from inline comments
# Format: target: ## Description
help: ## Show this help message with all available commands
	@echo '$(BLUE)╔════════════════════════════════════════════════════════════════╗$(NC)'
	@echo '$(BLUE)║         Pixielity Framework - Available Commands              ║$(NC)'
	@echo '$(BLUE)╚════════════════════════════════════════════════════════════════╝$(NC)'
	@echo ''
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-20s$(NC) %s\n", $$1, $$2}'
	@echo ''
	@echo '$(YELLOW)Examples:$(NC)'
	@echo '  make install        # Install all dependencies'
	@echo '  make test           # Run all tests'
	@echo '  make ci             # Run CI checks before committing'
	@echo ''

# ==============================================================================
# DEPENDENCY MANAGEMENT
# ==============================================================================

install: ## Install all Composer dependencies
	@echo '$(BLUE)📦 Installing dependencies...$(NC)'
	@composer install
	@echo '$(GREEN)✓ Dependencies installed successfully$(NC)'

update: ## Update all Composer dependencies to latest versions
	@echo '$(BLUE)📦 Updating dependencies...$(NC)'
	@composer update
	@echo '$(GREEN)✓ Dependencies updated successfully$(NC)'

# ==============================================================================
# TESTING COMMANDS
# ==============================================================================

test: ## Run all tests (unit, integration, feature)
	@echo '$(BLUE)🧪 Running all tests...$(NC)'
	@composer test
	@echo '$(GREEN)✓ All tests passed$(NC)'

test-unit: ## Run unit tests only (fast, isolated tests)
	@echo '$(BLUE)🧪 Running unit tests...$(NC)'
	@composer test:unit
	@echo '$(GREEN)✓ Unit tests passed$(NC)'

test-integration: ## Run integration tests only (component interaction tests)
	@echo '$(BLUE)🧪 Running integration tests...$(NC)'
	@composer test:integration
	@echo '$(GREEN)✓ Integration tests passed$(NC)'

test-coverage: ## Run tests with HTML coverage report (opens in browser)
	@echo '$(BLUE)🧪 Running tests with coverage analysis...$(NC)'
	@composer test:coverage
	@echo '$(GREEN)✓ Coverage report generated in coverage/html/$(NC)'
	@echo '$(YELLOW)💡 Open coverage/html/index.html in your browser$(NC)'

# ==============================================================================
# CODE QUALITY COMMANDS
# ==============================================================================

analyse: ## Run PHPStan static analysis (Level 8)
	@echo '$(BLUE)🔍 Running PHPStan static analysis...$(NC)'
	@composer analyse
	@echo '$(GREEN)✓ Static analysis passed$(NC)'

format: ## Format code with Laravel Pint (auto-fix)
	@echo '$(BLUE)✨ Formatting code with Laravel Pint...$(NC)'
	@composer format
	@echo '$(GREEN)✓ Code formatted successfully$(NC)'

format-check: ## Check code formatting without making changes
	@echo '$(BLUE)✨ Checking code formatting...$(NC)'
	@composer format:check
	@echo '$(GREEN)✓ Code formatting is correct$(NC)'

# ==============================================================================
# REFACTORING COMMANDS
# ==============================================================================

rector: ## Preview Rector refactoring changes (dry-run, no changes made)
	@echo '$(BLUE)🔧 Running Rector analysis (dry-run)...$(NC)'
	@composer rector
	@echo '$(YELLOW)💡 Run "make rector-fix" to apply these changes$(NC)'

rector-fix: ## Apply Rector refactoring changes (modifies files)
	@echo '$(BLUE)🔧 Applying Rector refactoring changes...$(NC)'
	@composer rector:fix
	@echo '$(GREEN)✓ Rector changes applied successfully$(NC)'

# ==============================================================================
# MUTATION TESTING
# ==============================================================================

mutate: ## Run mutation testing with Infection (tests your tests)
	@echo '$(BLUE)🧬 Running mutation testing...$(NC)'
	@echo '$(YELLOW)⚠️  This may take several minutes...$(NC)'
	@composer mutate
	@echo '$(GREEN)✓ Mutation testing completed$(NC)'

# ==============================================================================
# SECURITY & VALIDATION
# ==============================================================================

audit: ## Check for security vulnerabilities in dependencies
	@echo '$(BLUE)🔒 Running security audit...$(NC)'
	@composer audit
	@echo '$(GREEN)✓ No security vulnerabilities found$(NC)'

validate: ## Validate composer.json structure and dependencies
	@echo '$(BLUE)✅ Validating composer.json...$(NC)'
	@composer validate --strict
	@echo '$(GREEN)✓ Composer configuration is valid$(NC)'

# ==============================================================================
# CONTINUOUS INTEGRATION
# ==============================================================================

ci: ## Run quick CI checks (format, analyse, test) - use before committing
	@echo '$(BLUE)╔════════════════════════════════════════════════════════════════╗$(NC)'
	@echo '$(BLUE)║              Running CI Pipeline (Quick)                      ║$(NC)'
	@echo '$(BLUE)╚════════════════════════════════════════════════════════════════╝$(NC)'
	@echo ''
	@echo '$(BLUE)Step 1/3: Validating composer.json...$(NC)'
	@$(MAKE) validate
	@echo ''
	@echo '$(BLUE)Step 2/3: Checking code formatting...$(NC)'
	@$(MAKE) format-check
	@echo ''
	@echo '$(BLUE)Step 3/3: Running static analysis...$(NC)'
	@$(MAKE) analyse
	@echo ''
	@echo '$(BLUE)Step 4/4: Running tests...$(NC)'
	@$(MAKE) test
	@echo ''
	@echo '$(GREEN)╔════════════════════════════════════════════════════════════════╗$(NC)'
	@echo '$(GREEN)║              ✓ CI Pipeline Completed Successfully             ║$(NC)'
	@echo '$(GREEN)╚════════════════════════════════════════════════════════════════╝$(NC)'

ci-full: ## Run full CI suite including mutation testing - use before releases
	@echo '$(BLUE)╔════════════════════════════════════════════════════════════════╗$(NC)'
	@echo '$(BLUE)║              Running CI Pipeline (Full)                       ║$(NC)'
	@echo '$(BLUE)╚════════════════════════════════════════════════════════════════╝$(NC)'
	@echo ''
	@echo '$(YELLOW)⚠️  This will take several minutes...$(NC)'
	@echo ''
	@$(MAKE) ci
	@echo ''
	@echo '$(BLUE)Step 5/5: Running mutation testing...$(NC)'
	@$(MAKE) mutate
	@echo ''
	@echo '$(GREEN)╔════════════════════════════════════════════════════════════════╗$(NC)'
	@echo '$(GREEN)║         ✓ Full CI Pipeline Completed Successfully             ║$(NC)'
	@echo '$(GREEN)╚════════════════════════════════════════════════════════════════╝$(NC)'

# ==============================================================================
# CLEANUP COMMANDS
# ==============================================================================

clean: ## Clean cache, logs, and build artifacts (keeps vendor/)
	@echo '$(BLUE)🧹 Cleaning cache and build artifacts...$(NC)'
	@rm -rf var/cache/*
	@rm -rf var/log/*
	@rm -rf coverage/*
	@rm -rf .phpunit.cache
	@echo '$(GREEN)✓ Cleaned successfully$(NC)'

clean-all: clean ## Clean everything including vendor directory (requires reinstall)
	@echo '$(BLUE)🧹 Cleaning vendor directory...$(NC)'
	@rm -rf vendor
	@rm -f composer.lock
	@echo '$(YELLOW)⚠️  Run "make install" to reinstall dependencies$(NC)'
	@echo '$(GREEN)✓ Everything cleaned$(NC)'

# ==============================================================================
# AUTOLOADER OPTIMIZATION
# ==============================================================================

dump: ## Dump optimized Composer autoloader (improves performance)
	@echo '$(BLUE)📝 Dumping optimized autoloader...$(NC)'
	@composer dump-autoload -o
	@echo '$(GREEN)✓ Autoloader optimized$(NC)'

# ==============================================================================
# DEVELOPMENT WORKFLOW SHORTCUTS
# ==============================================================================

# Quick development cycle: format, test, analyse
dev: format test analyse ## Quick development cycle (format → test → analyse)
	@echo '$(GREEN)✓ Development cycle completed$(NC)'

# Pre-commit hook: format and quick checks
pre-commit: format test-unit analyse ## Pre-commit checks (format → unit tests → analyse)
	@echo '$(GREEN)✓ Pre-commit checks passed - ready to commit$(NC)'

# Pre-push hook: full CI
pre-push: ci ## Pre-push checks (full CI suite)
	@echo '$(GREEN)✓ Pre-push checks passed - ready to push$(NC)'

# ==============================================================================
# PACKAGE-SPECIFIC COMMANDS
# ==============================================================================

test-package-a: ## Run tests for PackageA only
	@echo '$(BLUE)🧪 Running PackageA tests...$(NC)'
	@vendor/bin/phpunit --testsuite=PackageA
	@echo '$(GREEN)✓ PackageA tests passed$(NC)'

test-package-b: ## Run tests for PackageB only
	@echo '$(BLUE)🧪 Running PackageB tests...$(NC)'
	@vendor/bin/phpunit --testsuite=PackageB
	@echo '$(GREEN)✓ PackageB tests passed$(NC)'

# ==============================================================================
# INFORMATION COMMANDS
# ==============================================================================

info: ## Show project information and statistics
	@echo '$(BLUE)╔════════════════════════════════════════════════════════════════╗$(NC)'
	@echo '$(BLUE)║              Pixielity Framework Information                  ║$(NC)'
	@echo '$(BLUE)╚════════════════════════════════════════════════════════════════╝$(NC)'
	@echo ''
	@echo '$(GREEN)PHP Version:$(NC)'
	@php -v | head -n 1
	@echo ''
	@echo '$(GREEN)Composer Version:$(NC)'
	@composer --version
	@echo ''
	@echo '$(GREEN)Installed Packages:$(NC)'
	@composer show --installed | wc -l | xargs echo "  Total packages:"
	@echo ''
	@echo '$(GREEN)Project Structure:$(NC)'
	@echo "  Source files:     $$(find src -name '*.php' | wc -l)"
	@echo "  Test files:       $$(find tests src/*/tests -name '*Test.php' 2>/dev/null | wc -l)"
	@echo "  Total PHP files:  $$(find . -name '*.php' ! -path './vendor/*' | wc -l)"
	@echo ''

# ==============================================================================
# NOTES
# ==============================================================================
#
# Color Codes:
#   BLUE   - Informational messages (actions being performed)
#   GREEN  - Success messages (completed actions)
#   YELLOW - Warning messages (important notes)
#   RED    - Error messages (failures)
#
# Command Naming Convention:
#   - Use hyphens for multi-word commands (test-unit, format-check)
#   - Keep names short and descriptive
#   - Group related commands together
#
# Best Practices:
#   - Always run 'make ci' before committing
#   - Run 'make ci-full' before creating pull requests
#   - Use 'make clean' if you encounter cache issues
#   - Run 'make help' to see all available commands
#
# ==============================================================================
