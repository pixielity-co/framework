#!/bin/bash

# ==============================================================================
# Pixielity Framework - Repository Setup Script
# ==============================================================================
#
# This script helps you:
# 1. Clean up existing GitHub repository
# 2. Initialize a fresh repository
# 3. Commit files in organized groups with proper commit messages
#
# Usage:
#   chmod +x setup-repository.sh
#   ./setup-repository.sh
#
# ==============================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
print_header() {
    echo -e "\n${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║  $1${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# ==============================================================================
# Step 1: Cleanup
# ==============================================================================

print_header "Step 1: Cleanup"

print_info "This will remove the existing .git directory and start fresh."
read -p "Do you want to continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_error "Aborted by user"
    exit 1
fi

if [ -d ".git" ]; then
    print_info "Removing existing .git directory..."
    rm -rf .git
    print_success "Removed .git directory"
else
    print_warning ".git directory not found, skipping..."
fi

# ==============================================================================
# Step 2: Initialize Repository
# ==============================================================================

print_header "Step 2: Initialize Repository"

print_info "Initializing new Git repository..."
git init
git branch -M main
print_success "Repository initialized with 'main' branch"

# ==============================================================================
# Step 3: Organized Commits
# ==============================================================================

print_header "Step 3: Creating Organized Commits"

# Commit 1: Initial project structure
print_info "Commit 1/12: Initial project structure..."
git add LICENSE README.md CONTRIBUTING.md SECURITY.md
git commit -m "🎉 Initial commit: Project foundation

- Add MIT License
- Add comprehensive README with installation and usage
- Add contributing guidelines
- Add security policy

This establishes the basic project structure and documentation."

print_success "Commit 1/12 completed"

# Commit 2: Core configuration files
print_info "Commit 2/12: Core configuration files..."
git add composer.json package.json .gitignore .prettierrc.json .prettierignore
git commit -m "🔧 Add core configuration files

- Add composer.json with full production attributes
- Add package.json for Node.js tooling
- Add .gitignore with comprehensive exclusions
- Add Prettier configuration for code formatting

All packages use self.version replacement (Laravel-style)."

print_success "Commit 2/12 completed"

# Commit 3: Testing infrastructure
print_info "Commit 3/12: Testing infrastructure..."
git add phpunit.xml infection.json tests/
git commit -m "✅ Add testing infrastructure

- Add PHPUnit 11.5 configuration with 6 test suites
- Add Infection mutation testing configuration
- Create test directories (Unit, Integration, Feature)
- Configure coverage reporting (HTML, Clover, Cobertura)

Target: 80% code coverage, 80% MSI, 90% covered MSI."

print_success "Commit 3/12 completed"

# Commit 4: Static analysis
print_info "Commit 4/12: Static analysis configuration..."
git add phpstan.neon
git commit -m "🔍 Add PHPStan static analysis

- Configure PHPStan Level 8 (strict)
- Integrate Larastan for enhanced analysis
- Use simplified paths (src, playground)
- Enable comprehensive type checking
- Configure parallel processing

Ensures type safety and catches bugs early."

print_success "Commit 4/12 completed"

# Commit 5: Code formatting
print_info "Commit 5/12: Code formatting configuration..."
git add pint.json phpcs.xml
git commit -m "✨ Add code formatting tools

- Configure Laravel Pint with 50+ rules
- Add PHP_CodeSniffer with PSR-12 standard
- Enable automatic code formatting
- Configure import optimization

Maintains consistent code style across the project."

print_success "Commit 5/12 completed"

# Commit 6: Automated refactoring
print_info "Commit 6/12: Automated refactoring..."
git add rector.php
git commit -m "♻️ Add Rector automated refactoring

- Target PHP 8.4 features
- Enable comprehensive rule sets
- Configure dead code removal
- Add type declaration improvements
- Enable parallel processing

Keeps codebase modern and maintainable."

print_success "Commit 6/12 completed"

# Commit 7: Build tools
print_info "Commit 7/12: Build tools..."
git add Makefile
git commit -m "🛠️ Add Makefile with 30+ commands

- Add comprehensive build commands
- Include CI/CD shortcuts
- Add development workflow helpers
- Configure color-coded output
- Add detailed documentation

Run 'make help' to see all available commands."

print_success "Commit 7/12 completed"

# Commit 8: Core packages
print_info "Commit 8/12: Core packages..."
git add src/Contracts/ src/Exceptions/ src/Foundation/
git commit -m "📦 Add core framework packages

Contracts:
- Application and Container interfaces
- PSR-11 compliance

Exceptions:
- Base exception classes
- Runtime exceptions

Foundation:
- Application implementation
- Container implementation
- Depends on Contracts

All packages include composer.json, README, and tests."

print_success "Commit 8/12 completed"

# Commit 9: Feature packages
print_info "Commit 9/12: Feature packages..."
git add src/PackageA/ src/PackageB/
git commit -m "📦 Add feature packages

PackageA:
- Core service functionality
- Example implementation
- Unit and integration tests

PackageB:
- Extended functionality module
- Ready for implementation

Both packages include full production configuration."

print_success "Commit 9/12 completed"

# Commit 10: GitHub workflows
print_info "Commit 10/12: GitHub workflows..."
git add .github/workflows/
git commit -m "🚀 Add CI/CD workflows

Tests:
- Multi-PHP version testing (8.3, 8.4)
- Coverage reporting to Codecov

Code Quality:
- PHPStan static analysis
- Laravel Pint formatting
- Rector refactoring checks

Security:
- Composer audit
- Dependency review

Mutation:
- Infection mutation testing

Release:
- Automated release creation
- Changelog generation

All workflows optimized with caching."

print_success "Commit 10/12 completed"

# Commit 11: GitHub configuration
print_info "Commit 11/12: GitHub configuration..."
git add .github/dependabot.yml .github/CODEOWNERS .github/CODE_OF_CONDUCT.md \
        .github/PULL_REQUEST_TEMPLATE.md .github/labeler.yml .github/FUNDING.yml \
        .github/ISSUE_TEMPLATE/
git commit -m "⚙️ Add GitHub configuration

- Dependabot for automated updates
- Code owners for review assignments
- Code of Conduct (Contributor Covenant)
- PR template with checklist
- Issue templates (bug, feature)
- Auto-labeling configuration
- Funding information

Improves collaboration and automation."

print_success "Commit 11/12 completed"

# Commit 12: Documentation
print_info "Commit 12/12: Documentation..."
git add docs/ CHANGELOG.md PRODUCTION_CHECKLIST.md QUICK_REFERENCE.md \
        FINAL_SETUP_SUMMARY.md PACKAGE_STRUCTURE.md splitsh.json \
        config/ playground/ var/
git commit -m "📚 Add comprehensive documentation

Documentation:
- Development guide with best practices
- Setup summary with all configurations
- Quick reference for common commands
- Production checklist
- Package structure overview

Configuration:
- Splitsh for monorepo splitting
- Framework configuration
- Playground for development

All documentation is production-ready."

print_success "Commit 12/12 completed"

# ==============================================================================
# Step 4: Summary
# ==============================================================================

print_header "Step 4: Summary"

print_success "All commits created successfully!"
echo ""
print_info "Repository Statistics:"
echo "  Total commits: 12"
echo "  Total files: $(git ls-files | wc -l)"
echo "  Total packages: 5"
echo ""

print_info "Next Steps:"
echo ""
echo "1. Create GitHub repository:"
echo "   ${YELLOW}gh repo create pixielity/framework --public --source=. --remote=origin${NC}"
echo ""
echo "2. Push to GitHub:"
echo "   ${YELLOW}git push -u origin main${NC}"
echo ""
echo "3. Set up branch protection:"
echo "   - Go to Settings > Branches"
echo "   - Add rule for 'main' branch"
echo "   - Require PR reviews"
echo "   - Require status checks"
echo ""
echo "4. Configure secrets:"
echo "   - CODECOV_TOKEN (for coverage)"
echo "   - Other secrets as needed"
echo ""

print_header "Setup Complete! 🎉"

# ==============================================================================
# Optional: GitHub CLI Commands
# ==============================================================================

print_info "Would you like to create the GitHub repository now? (requires gh CLI)"
read -p "Create repository? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if command -v gh &> /dev/null; then
        print_info "Creating GitHub repository..."
        gh repo create pixielity/framework --public --source=. --remote=origin --description="Enterprise-ready PHP framework with monorepo architecture"
        print_success "Repository created!"
        
        print_info "Pushing to GitHub..."
        git push -u origin main
        print_success "Pushed to GitHub!"
        
        print_info "Opening repository in browser..."
        gh repo view --web
    else
        print_error "GitHub CLI (gh) not found. Please install it first:"
        echo "  https://cli.github.com/"
    fi
fi

echo ""
print_success "All done! Happy coding! 🚀"
