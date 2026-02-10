# Packagist Setup Guide

This guide explains how to publish the Pixielity Framework and its packages to Packagist.

## 📦 Overview

The framework uses a monorepo structure with 5 packages:

1. **pixielity/framework** (main package)
2. **pixielity/contracts** (split from src/Contracts)
3. **pixielity/exceptions** (split from src/Exceptions)
4. **pixielity/foundation** (split from src/Foundation)
5. **pixielity/package-a** (split from src/PackageA)
6. **pixielity/package-b** (split from src/PackageB)

## 🚀 Initial Setup

### Step 1: Create Packagist Account

1. Go to [packagist.org](https://packagist.org)
2. Sign up or log in with GitHub
3. Go to Profile → Settings → API Token
4. Generate a new API token
5. Save the token securely

### Step 2: Submit Main Package

1. Go to [packagist.org/packages/submit](https://packagist.org/packages/submit)
2. Enter repository URL: `https://github.com/pixielity/framework`
3. Click "Check"
4. Click "Submit"

### Step 3: Create Split Repositories

For each package, create a separate GitHub repository:

```bash
# Using GitHub CLI
gh repo create pixielity/contracts --public --description="Pixielity Contracts"
gh repo create pixielity/exceptions --public --description="Pixielity Exceptions"
gh repo create pixielity/foundation --public --description="Pixielity Foundation"
gh repo create pixielity/package-a --public --description="Pixielity Package A"
gh repo create pixielity/package-b --public --description="Pixielity Package B"
```

### Step 4: Submit Split Packages

Submit each package to Packagist:

1. `https://github.com/pixielity/contracts`
2. `https://github.com/pixielity/exceptions`
3. `https://github.com/pixielity/foundation`
4. `https://github.com/pixielity/package-a`
5. `https://github.com/pixielity/package-b`

### Step 5: Configure GitHub Secrets

Add these secrets to your GitHub repository:

```bash
# Packagist credentials
gh secret set PACKAGIST_USERNAME --body "your-packagist-username"
gh secret set PACKAGIST_TOKEN --body "your-packagist-api-token"

# SSH key for package splitting
ssh-keygen -t ed25519 -C "bot@pixielity.com" -f ~/.ssh/pixielity_split
gh secret set SPLIT_SSH_KEY < ~/.ssh/pixielity_split
```

Add the public key to each split repository:
```bash
# Add as deploy key with write access
cat ~/.ssh/pixielity_split.pub
```

## 🔗 Webhook Configuration

### Automatic Webhooks (Recommended)

Packagist automatically creates webhooks when you submit a package. Verify:

1. Go to GitHub repository → Settings → Webhooks
2. You should see a webhook for `https://packagist.org/api/github`
3. Payload URL: `https://packagist.org/api/github?username=USERNAME`
4. Content type: `application/json`
5. Events: `Just the push event`

### Manual Webhook Setup

If automatic webhook creation fails:

```bash
# Using GitHub CLI
gh api repos/pixielity/framework/hooks \
  --method POST \
  --field name=web \
  --field active=true \
  --field events[]=push \
  --field config[url]="https://packagist.org/api/github?username=YOUR_USERNAME" \
  --field config[content_type]=json
```

### Test Webhook

```bash
# Trigger webhook test workflow
gh workflow run webhook-test.yml

# Or manually test
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"repository":{"url":"https://github.com/pixielity/framework"}}' \
  https://packagist.org/api/github
```

## 🔄 Automated Workflows

### 1. Packagist Update Workflow

**File**: `.github/workflows/packagist.yml`

**Triggers**:
- New version tag (v*.*.*)
- Release published
- Manual dispatch

**Jobs**:
1. Update Packagist
2. Verify package installation
3. Notify success

**Usage**:
```bash
# Automatic on release
git tag v1.0.0
git push origin v1.0.0

# Manual trigger
gh workflow run packagist.yml
```

### 2. Package Splitting Workflow

**File**: `.github/workflows/split-packages.yml`

**Triggers**:
- Push to main branch
- New version tag
- Manual dispatch

**Jobs**:
1. Split each package to separate repository
2. Tag split packages
3. Update Packagist for each package

**Usage**:
```bash
# Automatic on push to main
git push origin main

# Manual trigger
gh workflow run split-packages.yml
```

### 3. Webhook Test Workflow

**File**: `.github/workflows/webhook-test.yml`

**Triggers**:
- Manual dispatch
- Changes to composer.json

**Jobs**:
1. Test webhook connectivity
2. Verify composer.json files
3. Check package names

**Usage**:
```bash
# Manual trigger
gh workflow run webhook-test.yml

# With custom webhook URL
gh workflow run webhook-test.yml \
  --field webhook_url=https://custom-webhook.com
```

## 📋 Release Process

### Step 1: Prepare Release

```bash
# Update CHANGELOG.md
vim CHANGELOG.md

# Update version in composer.json (optional)
# Packagist uses git tags for versions

# Commit changes
git add CHANGELOG.md
git commit -m "📝 Prepare release v1.0.0"
git push origin main
```

### Step 2: Create Release

```bash
# Create and push tag
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0

# Or create release via GitHub CLI
gh release create v1.0.0 \
  --title "v1.0.0" \
  --notes "See CHANGELOG.md for details"
```

### Step 3: Automated Actions

The following happens automatically:

1. ✅ **Release workflow** creates GitHub release
2. ✅ **Packagist workflow** updates main package
3. ✅ **Split workflow** splits packages to separate repos
4. ✅ **Split workflow** tags split packages
5. ✅ **Split workflow** updates split packages on Packagist
6. ✅ **Verify workflow** tests package installation

### Step 4: Verify Release

```bash
# Check Packagist
open https://packagist.org/packages/pixielity/framework

# Test installation
composer create-project pixielity/framework test-install
cd test-install
composer show pixielity/framework

# Test individual packages
composer require pixielity/contracts
composer require pixielity/foundation
```

## 🔍 Verification Checklist

### Before First Release

- [ ] All composer.json files validated
- [ ] Package names correct
- [ ] GitHub repositories created
- [ ] Packagist accounts submitted
- [ ] Webhooks configured
- [ ] GitHub secrets added
- [ ] SSH keys configured
- [ ] Workflows tested

### Before Each Release

- [ ] CHANGELOG.md updated
- [ ] All tests passing
- [ ] Code quality checks passing
- [ ] Version number decided
- [ ] Release notes prepared

### After Each Release

- [ ] GitHub release created
- [ ] Packagist updated (main package)
- [ ] Split packages updated
- [ ] Installation tested
- [ ] Documentation updated
- [ ] Announcement made

## 🛠️ Troubleshooting

### Packagist Not Updating

**Problem**: Packagist doesn't show new version

**Solutions**:
```bash
# 1. Manually trigger update
curl -XPOST -H'content-type:application/json' \
  "https://packagist.org/api/update-package?username=USERNAME&apiToken=TOKEN" \
  -d'{"repository":{"url":"https://github.com/pixielity/framework"}}'

# 2. Check webhook
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

# 2. Verify split repositories exist
gh repo view pixielity/contracts

# 3. Check workflow logs
gh run list --workflow=split-packages.yml
gh run view <run-id>

# 4. Manual split (if needed)
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

# 2. Check webhook deliveries
# Go to GitHub → Settings → Webhooks → Recent Deliveries

# 3. Recreate webhook
gh api repos/pixielity/framework/hooks/<hook-id> --method DELETE
# Then create new webhook via Packagist
```

### Composer Install Fails

**Problem**: `composer require pixielity/framework` fails

**Solutions**:
```bash
# 1. Clear Composer cache
composer clear-cache

# 2. Check package exists
curl https://packagist.org/packages/pixielity/framework.json

# 3. Try with specific version
composer require pixielity/framework:^1.0

# 4. Check minimum stability
composer config minimum-stability stable
```

## 📊 Monitoring

### Check Package Stats

```bash
# View on Packagist
open https://packagist.org/packages/pixielity/framework/stats

# Check downloads
curl https://packagist.org/packages/pixielity/framework.json | jq '.package.downloads'

# Check dependents
curl https://packagist.org/packages/pixielity/framework.json | jq '.package.dependents'
```

### Monitor Workflows

```bash
# List recent runs
gh run list --workflow=packagist.yml --limit 10

# Watch workflow
gh run watch

# View logs
gh run view --log
```

## 🎯 Best Practices

### Versioning

- Use [Semantic Versioning](https://semver.org/)
- Tag format: `v1.0.0` (with 'v' prefix)
- Update CHANGELOG.md for each release
- Use pre-release tags for testing: `v1.0.0-beta.1`

### Release Frequency

- **Patch releases**: Bug fixes (v1.0.1)
- **Minor releases**: New features (v1.1.0)
- **Major releases**: Breaking changes (v2.0.0)

### Package Maintenance

- Keep dependencies updated
- Respond to issues promptly
- Maintain documentation
- Monitor security advisories

## 📚 Resources

- [Packagist Documentation](https://packagist.org/about)
- [Composer Documentation](https://getcomposer.org/doc/)
- [Semantic Versioning](https://semver.org/)
- [GitHub Actions](https://docs.github.com/en/actions)
- [Monorepo Splitting](https://github.com/symplify/monorepo-split-github-action)

## ✅ Summary

Your Packagist setup includes:

- ✅ Automated package updates
- ✅ Webhook configuration
- ✅ Package splitting
- ✅ Version tagging
- ✅ Installation verification
- ✅ Comprehensive testing

**Next**: Create your first release with `git tag v1.0.0 && git push origin v1.0.0`
