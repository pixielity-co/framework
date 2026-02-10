#!/bin/bash

# ==============================================================================
# Packagist Setup Script
# ==============================================================================
#
# This script helps you set up Packagist publishing for the Pixielity Framework
#
# Usage:
#   chmod +x scripts/setup-packagist.sh
#   ./scripts/setup-packagist.sh
#
# ==============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo -e "\n${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║  $1${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}\n"
}

print_success() { echo -e "${GREEN}✓ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠ $1${NC}"; }
print_error() { echo -e "${RED}✗ $1${NC}"; }
print_info() { echo -e "${BLUE}ℹ $1${NC}"; }

# ==============================================================================
# Step 1: Prerequisites Check
# ==============================================================================

print_header "Step 1: Prerequisites Check"

# Check GitHub CLI
if ! command -v gh &> /dev/null; then
    print_error "GitHub CLI (gh) not found. Please install it first:"
    echo "  https://cli.github.com/"
    exit 1
fi
print_success "GitHub CLI found"

# Check if logged in to GitHub
if ! gh auth status &> /dev/null; then
    print_error "Not logged in to GitHub. Please run: gh auth login"
    exit 1
fi
print_success "Logged in to GitHub"

# Check if in git repository
if ! git rev-parse --git-dir &> /dev/null; then
    print_error "Not in a git repository"
    exit 1
fi
print_success "In git repository"

# ==============================================================================
# Step 2: Collect Information
# ==============================================================================

print_header "Step 2: Collect Information"

read -p "Enter your Packagist username: " PACKAGIST_USERNAME
read -sp "Enter your Packagist API token: " PACKAGIST_TOKEN
echo

if [ -z "$PACKAGIST_USERNAME" ] || [ -z "$PACKAGIST_TOKEN" ]; then
    print_error "Username and token are required"
    exit 1
fi

print_success "Credentials collected"

# ==============================================================================
# Step 3: Create Split Repositories
# ==============================================================================

print_header "Step 3: Create Split Repositories"

packages=(
    "contracts:Pixielity Contracts - Framework interfaces"
    "exceptions:Pixielity Exceptions - Exception classes"
    "foundation:Pixielity Foundation - Core application"
    "package-a:Pixielity Package A - Core service functionality"
    "package-b:Pixielity Package B - Extended functionality"
)

for package in "${packages[@]}"; do
    name="${package%%:*}"
    description="${package##*:}"
    
    print_info "Creating repository: pixielity/$name"
    
    if gh repo view "pixielity/$name" &> /dev/null; then
        print_warning "Repository pixielity/$name already exists, skipping..."
    else
        gh repo create "pixielity/$name" \
            --public \
            --description "$description" \
            --homepage "https://docs.pixielity.com/packages/$name"
        print_success "Created pixielity/$name"
    fi
done

# ==============================================================================
# Step 4: Generate SSH Key for Splitting
# ==============================================================================

print_header "Step 4: Generate SSH Key"

SSH_KEY_PATH="$HOME/.ssh/pixielity_split"

if [ -f "$SSH_KEY_PATH" ]; then
    print_warning "SSH key already exists at $SSH_KEY_PATH"
    read -p "Regenerate? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -f "$SSH_KEY_PATH" "$SSH_KEY_PATH.pub"
    else
        print_info "Using existing key"
    fi
fi

if [ ! -f "$SSH_KEY_PATH" ]; then
    print_info "Generating SSH key..."
    ssh-keygen -t ed25519 -C "bot@pixielity.com" -f "$SSH_KEY_PATH" -N ""
    print_success "SSH key generated"
fi

print_info "Public key:"
cat "$SSH_KEY_PATH.pub"
echo

# ==============================================================================
# Step 5: Add Deploy Keys
# ==============================================================================

print_header "Step 5: Add Deploy Keys"

print_info "Adding deploy keys to split repositories..."

for package in "${packages[@]}"; do
    name="${package%%:*}"
    
    print_info "Adding deploy key to pixielity/$name..."
    
    gh api repos/pixielity/$name/keys \
        --method POST \
        --field title="Monorepo Split Key" \
        --field key="$(cat $SSH_KEY_PATH.pub)" \
        --field read_only=false \
        2>/dev/null && print_success "Added to $name" || print_warning "Failed or already exists for $name"
done

# ==============================================================================
# Step 6: Configure GitHub Secrets
# ==============================================================================

print_header "Step 6: Configure GitHub Secrets"

print_info "Adding secrets to pixielity/framework..."

# Add Packagist credentials
echo "$PACKAGIST_USERNAME" | gh secret set PACKAGIST_USERNAME
print_success "Added PACKAGIST_USERNAME"

echo "$PACKAGIST_TOKEN" | gh secret set PACKAGIST_TOKEN
print_success "Added PACKAGIST_TOKEN"

# Add SSH key
cat "$SSH_KEY_PATH" | gh secret set SPLIT_SSH_KEY
print_success "Added SPLIT_SSH_KEY"

# ==============================================================================
# Step 7: Submit to Packagist
# ==============================================================================

print_header "Step 7: Submit to Packagist"

print_info "Please submit the following packages to Packagist manually:"
echo ""
echo "1. Main package:"
echo "   ${YELLOW}https://packagist.org/packages/submit${NC}"
echo "   Repository: https://github.com/pixielity/framework"
echo ""
echo "2. Split packages:"
for package in "${packages[@]}"; do
    name="${package%%:*}"
    echo "   Repository: https://github.com/pixielity/$name"
done
echo ""

read -p "Press Enter when you've submitted all packages to Packagist..."

# ==============================================================================
# Step 8: Configure Webhooks
# ==============================================================================

print_header "Step 8: Configure Webhooks"

print_info "Configuring webhook for main repository..."

WEBHOOK_URL="https://packagist.org/api/github?username=$PACKAGIST_USERNAME"

# Check if webhook already exists
if gh api repos/pixielity/framework/hooks | jq -e ".[] | select(.config.url == \"$WEBHOOK_URL\")" > /dev/null 2>&1; then
    print_warning "Webhook already exists"
else
    gh api repos/pixielity/framework/hooks \
        --method POST \
        --field name=web \
        --field active=true \
        --field events[]=push \
        --field config[url]="$WEBHOOK_URL" \
        --field config[content_type]=json \
        > /dev/null 2>&1 && print_success "Webhook configured" || print_warning "Webhook may already exist or Packagist created it automatically"
fi

# ==============================================================================
# Step 9: Test Setup
# ==============================================================================

print_header "Step 9: Test Setup"

print_info "Testing webhook..."
gh workflow run webhook-test.yml
print_success "Webhook test triggered"

print_info "Validating composer.json files..."
composer validate --strict --no-check-lock
for dir in src/*/; do
    if [ -f "$dir/composer.json" ]; then
        composer validate --strict --no-check-lock --working-dir="$dir"
    fi
done
print_success "All composer.json files valid"

# ==============================================================================
# Step 10: Summary
# ==============================================================================

print_header "Step 10: Setup Complete!"

print_success "Packagist setup completed successfully!"
echo ""
print_info "Summary:"
echo "  ✅ Split repositories created"
echo "  ✅ SSH key generated and added"
echo "  ✅ GitHub secrets configured"
echo "  ✅ Webhooks configured"
echo "  ✅ Composer files validated"
echo ""

print_info "Next Steps:"
echo ""
echo "1. Create your first release:"
echo "   ${YELLOW}git tag v1.0.0${NC}"
echo "   ${YELLOW}git push origin v1.0.0${NC}"
echo ""
echo "2. Monitor workflows:"
echo "   ${YELLOW}gh run list${NC}"
echo "   ${YELLOW}gh run watch${NC}"
echo ""
echo "3. Verify on Packagist:"
echo "   ${YELLOW}https://packagist.org/packages/pixielity/framework${NC}"
echo ""
echo "4. Test installation:"
echo "   ${YELLOW}composer create-project pixielity/framework test-install${NC}"
echo ""

print_header "All Done! 🎉"
