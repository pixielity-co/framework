# GitHub Setup Guide

This guide will help you set up the Pixielity Framework repository on GitHub with proper organization and commit history.

## 📋 Prerequisites

- Git installed
- GitHub CLI (`gh`) installed (optional but recommended)
- GitHub account

## 🚀 Quick Setup (Automated)

### Option 1: Using the Setup Script

```bash
# Make script executable
chmod +x setup-repository.sh

# Run the script
./setup-repository.sh
```

The script will:
1. ✅ Clean up existing .git directory
2. ✅ Initialize fresh repository
3. ✅ Create 12 organized commits
4. ✅ Optionally create GitHub repository
5. ✅ Push to GitHub

## 📝 Manual Setup

### Step 1: Clean Up Existing Repository

```bash
# Remove existing .git directory
rm -rf .git

# Remove existing GitHub repository (if needed)
gh repo delete pixielity/framework --yes
```

### Step 2: Initialize Repository

```bash
# Initialize new repository
git init
git branch -M main
```

### Step 3: Create Organized Commits

#### Commit 1: Initial project structure
```bash
git add LICENSE README.md CONTRIBUTING.md SECURITY.md
git commit -m "🎉 Initial commit: Project foundation

- Add MIT License
- Add comprehensive README with installation and usage
- Add contributing guidelines
- Add security policy

This establishes the basic project structure and documentation."
```

#### Commit 2: Core configuration files
```bash
git add composer.json package.json .gitignore .prettierrc.json .prettierignore
git commit -m "🔧 Add core configuration files

- Add composer.json with full production attributes
- Add package.json for Node.js tooling
- Add .gitignore with comprehensive exclusions
- Add Prettier configuration for code formatting

All packages use self.version replacement (Laravel-style)."
```

#### Commit 3: Testing infrastructure
```bash
git add phpunit.xml infection.json tests/
git commit -m "✅ Add testing infrastructure

- Add PHPUnit 11.5 configuration with 6 test suites
- Add Infection mutation testing configuration
- Create test directories (Unit, Integration, Feature)
- Configure coverage reporting (HTML, Clover, Cobertura)

Target: 80% code coverage, 80% MSI, 90% covered MSI."
```

#### Commit 4: Static analysis
```bash
git add phpstan.neon
git commit -m "🔍 Add PHPStan static analysis

- Configure PHPStan Level 8 (strict)
- Integrate Larastan for enhanced analysis
- Use simplified paths (src, playground)
- Enable comprehensive type checking
- Configure parallel processing

Ensures type safety and catches bugs early."
```

#### Commit 5: Code formatting
```bash
git add pint.json phpcs.xml
git commit -m "✨ Add code formatting tools

- Configure Laravel Pint with 50+ rules
- Add PHP_CodeSniffer with PSR-12 standard
- Enable automatic code formatting
- Configure import optimization

Maintains consistent code style across the project."
```

#### Commit 6: Automated refactoring
```bash
git add rector.php
git commit -m "♻️ Add Rector automated refactoring

- Target PHP 8.4 features
- Enable comprehensive rule sets
- Configure dead code removal
- Add type declaration improvements
- Enable parallel processing

Keeps codebase modern and maintainable."
```

#### Commit 7: Build tools
```bash
git add Makefile
git commit -m "🛠️ Add Makefile with 30+ commands

- Add comprehensive build commands
- Include CI/CD shortcuts
- Add development workflow helpers
- Configure color-coded output
- Add detailed documentation

Run 'make help' to see all available commands."
```

#### Commit 8: Core packages
```bash
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
```

#### Commit 9: Feature packages
```bash
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
```

#### Commit 10: GitHub workflows
```bash
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
```

#### Commit 11: GitHub configuration
```bash
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
```

#### Commit 12: Documentation
```bash
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
```

### Step 4: Create GitHub Repository

```bash
# Using GitHub CLI
gh repo create pixielity/framework --public --source=. --remote=origin \
  --description="Enterprise-ready PHP framework with monorepo architecture"

# Or manually:
# 1. Go to https://github.com/new
# 2. Create repository named "framework"
# 3. Add remote: git remote add origin git@github.com:pixielity/framework.git
```

### Step 5: Push to GitHub

```bash
git push -u origin main
```

### Step 6: Configure Repository Settings

#### Branch Protection

```bash
# Using GitHub CLI
gh api repos/pixielity/framework/branches/main/protection \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":["tests","phpstan","pint"]}' \
  --field enforce_admins=true \
  --field required_pull_request_reviews='{"required_approving_review_count":1}' \
  --field restrictions=null

# Or manually:
# 1. Go to Settings > Branches
# 2. Add rule for 'main' branch
# 3. Enable:
#    - Require pull request reviews (1 approval)
#    - Require status checks to pass
#    - Require branches to be up to date
#    - Include administrators
```

#### Repository Secrets

```bash
# Add Codecov token
gh secret set CODECOV_TOKEN

# Add other secrets as needed
```

#### Repository Topics

```bash
gh repo edit pixielity/framework \
  --add-topic php \
  --add-topic framework \
  --add-topic monorepo \
  --add-topic enterprise \
  --add-topic psr-11 \
  --add-topic phpunit \
  --add-topic phpstan
```

## 📊 Commit Structure

The repository is organized into 12 logical commits:

1. 🎉 **Initial commit** - Project foundation
2. 🔧 **Core configuration** - Composer, package.json, .gitignore
3. ✅ **Testing infrastructure** - PHPUnit, Infection
4. 🔍 **Static analysis** - PHPStan
5. ✨ **Code formatting** - Pint, PHPCS
6. ♻️ **Automated refactoring** - Rector
7. 🛠️ **Build tools** - Makefile
8. 📦 **Core packages** - Contracts, Exceptions, Foundation
9. 📦 **Feature packages** - PackageA, PackageB
10. 🚀 **CI/CD workflows** - GitHub Actions
11. ⚙️ **GitHub configuration** - Templates, Dependabot
12. 📚 **Documentation** - Guides, references

## 🎯 Emoji Guide

- 🎉 Initial commit
- 🔧 Configuration
- ✅ Tests
- 🔍 Analysis
- ✨ Formatting
- ♻️ Refactoring
- 🛠️ Build tools
- 📦 Packages
- 🚀 CI/CD
- ⚙️ Settings
- 📚 Documentation
- 🐛 Bug fix
- ✨ New feature
- 💥 Breaking change
- 🔒 Security
- ⚡ Performance
- 🎨 Style

## ✅ Verification

After setup, verify everything is working:

```bash
# Check repository status
git status

# View commit history
git log --oneline --graph

# Check remote
git remote -v

# View on GitHub
gh repo view --web
```

## 🔄 Cleanup Commands

If you need to start over:

```bash
# Delete local .git
rm -rf .git

# Delete GitHub repository
gh repo delete pixielity/framework --yes

# Delete all GitHub Actions runs
gh run list --limit 100 | awk '{print $7}' | xargs -I {} gh run delete {}

# Delete all GitHub workflows (if needed)
# This is done by deleting .github/workflows/ and pushing
```

## 📝 Post-Setup Tasks

1. ✅ Enable GitHub Pages (for documentation)
2. ✅ Configure Codecov integration
3. ✅ Set up branch protection rules
4. ✅ Add repository secrets
5. ✅ Invite collaborators
6. ✅ Create initial release (v1.0.0)
7. ✅ Update README badges
8. ✅ Submit to Packagist

## 🎉 Success!

Your repository is now set up with:

- ✅ Clean commit history
- ✅ Organized file structure
- ✅ Complete CI/CD pipeline
- ✅ Comprehensive documentation
- ✅ Production-ready configuration

---

**Next**: Start developing! See [DEVELOPMENT.md](docs/DEVELOPMENT.md) for the development workflow.
