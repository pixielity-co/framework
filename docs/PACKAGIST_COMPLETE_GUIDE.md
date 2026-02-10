# Complete Packagist & Publishing Guide

## 🎯 Overview

This guide covers everything you need to publish the Pixielity Framework to Packagist and set up automated package distribution.

## 📦 What Gets Published

### Main Package
- **pixielity/framework** - The complete monorepo

### Split Packages (Automatically)
- **pixielity/contracts** - Framework interfaces
- **pixielity/exceptions** - Exception classes
- **pixielity/foundation** - Core application
- **pixielity/package-a** - Service functionality
- **pixielity/package-b** - Extended functionality

## 🚀 Quick Setup (Automated)

### Option 1: Use Setup Script

```bash
# Make executable
chmod +x scripts/setup-packagist.sh

# Run setup
./scripts/setup-packagist.sh
```

The script will:
1. ✅ Check prerequisites (gh CLI, git)
2. ✅ Collect Packagist credentials
3. ✅ Create split repositories
4. ✅ Generate SSH keys
5. ✅ Add deploy keys
6. ✅ Configure GitHub secrets
7. ✅ Set up webhooks
8. ✅ Test configuration

## 📋 Manual Setup

### Step 1: Prerequisites

```bash
# Install GitHub CLI
brew install gh

# Login to GitHub
gh auth login

# Verify
gh auth status
```

### Step 2: Create Packagist Account

1. Go to [packagist.org](https://packagist.org)
2. Sign up with GitHub
3. Go to Profile → Settings → API Token
4. Generate new token
5. Save token securely

### Step 3: Create Split Repositories

```bash
# Create repositories for each package
gh repo create pixielity/contracts --public
gh repo create pixielity/exceptions --public
gh repo create pixielity/foundation --public
gh repo create pixielity/package-a --public
gh repo create pixielity/package-b --public
```

### Step 4: Generate SSH Key

```bash
# Generate key for package splitting
ssh-keygen -t ed25519 -C "bot@pixielity.com" -f ~/.ssh/pixielity_split

# View public key
cat ~/.ssh/pixielity_split.pub
```

### Step 5: Add Deploy Keys

For each repository (contracts, exceptions, foundation, package-a, package-b):

```bash
# Add deploy key with write access
gh api repos/pixielity/PACKAGE_NAME/keys \
  --method POST \
  --field title="Monorepo Split Key" \
  --field key="$(cat ~/.ssh/pixielity_split.pub)" \
  --field read_only=false
```

### Step 6: Configure GitHub Secrets

```bash
# Add Packagist credentials
gh secret set PACKAGIST_USERNAME --body "your-username"
gh secret set PACKAGIST_TOKEN --body "your-api-token"

# Add SSH key for splitting
cat ~/.ssh/pixielity_split | gh secret set SPLIT_SSH_KEY
```

### Step 7: Submit to Packagist

1. Go to [packagist.org/packages/submit](https://packagist.org/packages/submit)
2. Submit main package: `https://github.com/pixielity/framework`
3. Submit each split package:
   - `https://github.com/pixielity/contracts`
   - `https://github.com/pixielity/exceptions`
   - `https://github.com/pixielity/foundation`
   - `https://github.com/pixielity/package-a`
   - `https://github.com/pixielity/package-b`

### Step 8: Configure Webhooks

Packagist automatically creates webhooks. Verify:

```bash
# Check webhooks
gh api repos/pixielity/framework/hooks

# Should see webhook for packagist.org
```

If not created automatically:

```bash
gh api repos/pixielity/framework/hooks \
  --method POST \
  --field name=web \
  --field active=true \
  --field events[]=push \
  --field config[url]="https://packagist.org/api/github?username=YOUR_USERNAME" \
  --field config[content_type]=json
```

## 🔄 Workflow Stages

### Stage 1: Development → Main

```
Push to main
├── Tests (PHP 8.3, 8.4)
├── Code Quality (PHPStan, Pint, Rector)
├── Security (Audit, Dependency Review)
└── Split Packages
    ├── Split to separate repos
    └── Update split repos
```

**Workflows**:
- `tests.yml`
- `code-quality.yml`
- `security.yml`
- `split-packages.yml`

### Stage 2: Create Release

```
git tag v1.0.0
git push origin v1.0.0
├── Release Workflow
│   └── Create GitHub Release
├── Packagist Workflow
│   ├── Update main package
│   └── Verify installation
└── Split Packages Workflow
    ├── Tag split packages (v1.0.0)
    └── Update split packages on Packagist
```

**Workflows**:
- `release.yml`
- `packagist.yml`
- `split-packages.yml`

### Stage 3: Post-Release

```
Release Published
├── Docs Workflow
│   └── Deploy to GitHub Pages
└── Webhook Test
    ├── Test main package webhook
    └── Test split package webhooks
```

**Workflows**:
- `docs.yml`
- `webhook-test.yml`

## 📝 Release Process

### 1. Prepare Release

```bash
# Update CHANGELOG.md
vim CHANGELOG.md

# Commit changes
git add CHANGELOG.md
git commit -m "📝 Prepare release v1.0.0"
git push origin main
```

### 2. Create Tag

```bash
# Create annotated tag
git tag -a v1.0.0 -m "Release v1.0.0

- Initial release
- Core framework packages
- Complete testing infrastructure
- Production-ready configuration"

# Push tag
git push origin v1.0.0
```

### 3. Automated Actions

The following happens automatically:

1. **Release Workflow** (`release.yml`)
   - ✅ Creates GitHub release
   - ✅ Generates changelog
   - ✅ Attaches release notes

2. **Packagist Workflow** (`packagist.yml`)
   - ✅ Updates main package on Packagist
   - ✅ Verifies installation
   - ✅ Notifies success

3. **Split Packages Workflow** (`split-packages.yml`)
   - ✅ Splits packages to separate repos
   - ✅ Tags split packages with v1.0.0
   - ✅ Updates each package on Packagist

### 4. Verify Release

```bash
# Check GitHub release
gh release view v1.0.0

# Check Packagist
open https://packagist.org/packages/pixielity/framework

# Test installation
composer create-project pixielity/framework test-install
cd test-install
composer show pixielity/framework

# Test individual packages
composer require pixielity/contracts:^1.0
composer require pixielity/foundation:^1.0
```

## 🔍 Testing & Verification

### Test Webhooks

```bash
# Trigger webhook test workflow
gh workflow run webhook-test.yml

# Or manually test
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"repository":{"url":"https://github.com/pixielity/framework"}}' \
  https://packagist.org/api/github
```

### Verify Composer Files

```bash
# Validate all composer.json
composer validate --strict --no-check-lock

# Validate packages
for dir in src/*/; do
  composer validate --strict --no-check-lock --working-dir="$dir"
done
```

### Test Package Installation

```bash
# Test main package
composer create-project pixielity/framework test-main

# Test individual packages
mkdir test-packages && cd test-packages
composer init --no-interaction
composer require pixielity/contracts
composer require pixielity/exceptions
composer require pixielity/foundation
composer require pixielity/package-a
composer require pixielity/package-b
```

## 🛠️ Troubleshooting

### Packagist Not Updating

**Problem**: New version not showing on Packagist

**Solutions**:

```bash
# 1. Manually trigger update
curl -XPOST -H'content-type:application/json' \
  "https://packagist.org/api/update-package?username=USERNAME&apiToken=TOKEN" \
  -d'{"repository":{"url":"https://github.com/pixielity/framework"}}'

# 2. Check webhook deliveries
gh api repos/pixielity/framework/hooks

# 3. Re-trigger workflow
gh workflow run packagist.yml
```

### Package Splitting Fails

**Problem**: Split packages not updating

**Solutions**:

```bash
# 1. Check SSH key
ssh -T git@github.com

# 2. Verify repositories exist
gh repo view pixielity/contracts

# 3. Check workflow logs
gh run list --workflow=split-packages.yml
gh run view <run-id> --log

# 4. Manual split (emergency)
git subtree split --prefix=src/Contracts -b contracts-split
git push git@github.com:pixielity/contracts.git contracts-split:main
```

### Webhook Not Working

**Problem**: Webhook returns error

**Solutions**:

```bash
# 1. Test webhook manually
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"repository":{"url":"https://github.com/pixielity/framework"}}' \
  https://packagist.org/api/github

# 2. Check webhook deliveries in GitHub
# Settings → Webhooks → Recent Deliveries

# 3. Recreate webhook
gh api repos/pixielity/framework/hooks/<hook-id> --method DELETE
# Then recreate via Packagist
```

### Composer Install Fails

**Problem**: `composer require` fails

**Solutions**:

```bash
# 1. Clear cache
composer clear-cache

# 2. Check package exists
curl https://packagist.org/packages/pixielity/framework.json

# 3. Try specific version
composer require pixielity/framework:^1.0

# 4. Check minimum stability
composer config minimum-stability stable
```

## 📊 Monitoring

### Check Package Stats

```bash
# View on Packagist
open https://packagist.org/packages/pixielity/framework/stats

# Check downloads via API
curl https://packagist.org/packages/pixielity/framework.json | \
  jq '.package.downloads'

# Check all packages
for pkg in framework contracts exceptions foundation package-a package-b; do
  echo "=== pixielity/$pkg ==="
  curl -s "https://packagist.org/packages/pixielity/$pkg.json" | \
    jq '.package.downloads'
done
```

### Monitor Workflows

```bash
# List recent runs
gh run list --limit 20

# Watch specific workflow
gh run list --workflow=packagist.yml --limit 5

# View logs
gh run view --log

# Watch in real-time
gh run watch
```

## 📚 Documentation

### Available Guides

1. **PACKAGIST_SETUP.md** - Detailed setup instructions
2. **WORKFLOWS_OVERVIEW.md** - All workflows explained
3. **GITHUB_SETUP.md** - GitHub repository setup
4. **DEVELOPMENT.md** - Development workflow

### Quick Links

- [Packagist Documentation](https://packagist.org/about)
- [Composer Documentation](https://getcomposer.org/doc/)
- [GitHub Actions](https://docs.github.com/en/actions)
- [Monorepo Splitting](https://github.com/symplify/monorepo-split-github-action)

## ✅ Checklist

### Before First Release

- [ ] Packagist account created
- [ ] API token generated
- [ ] Split repositories created
- [ ] SSH key generated
- [ ] Deploy keys added
- [ ] GitHub secrets configured
- [ ] Main package submitted to Packagist
- [ ] Split packages submitted to Packagist
- [ ] Webhooks configured
- [ ] Workflows tested

### Before Each Release

- [ ] CHANGELOG.md updated
- [ ] All tests passing
- [ ] Code quality checks passing
- [ ] Version number decided
- [ ] Release notes prepared
- [ ] Documentation updated

### After Each Release

- [ ] GitHub release created
- [ ] Packagist updated (main)
- [ ] Split packages updated
- [ ] Installation tested
- [ ] Documentation deployed
- [ ] Announcement made

## 🎯 Summary

Your complete publishing setup includes:

✅ **3 workflows** for publishing:
- `packagist.yml` - Update main package
- `split-packages.yml` - Split and update packages
- `webhook-test.yml` - Test webhooks

✅ **Automated process**:
- Tag → Release → Packagist → Split → Verify

✅ **6 packages** published:
- Main framework + 5 split packages

✅ **Complete automation**:
- No manual steps after initial setup
- Automatic updates on every release
- Webhook-based synchronization

## 🚀 Next Steps

1. **Run Setup**:
   ```bash
   ./scripts/setup-packagist.sh
   ```

2. **Create First Release**:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

3. **Monitor**:
   ```bash
   gh run watch
   ```

4. **Verify**:
   ```bash
   composer create-project pixielity/framework test
   ```

---

**Status**: 🎯 READY FOR PUBLISHING

All workflows, scripts, and documentation are complete!
