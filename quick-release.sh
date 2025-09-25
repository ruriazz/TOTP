#!/bin/bash

# Quick release dengan GitHub CLI
# Usage: ./quick-release.sh [version]
# Contoh: ./quick-release.sh v1.0.1

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}⚡ Quick Release dengan GitHub CLI${NC}"
echo "=================================="

# Check if version is provided
if [ -z "$1" ]; then
    echo -e "${RED}❌ Error: Version tag required${NC}"
    echo "Usage: ./quick-release.sh [version]"
    echo "Example: ./quick-release.sh v1.0.1"
    exit 1
fi

VERSION=$1

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    echo -e "${RED}❌ Error: GitHub CLI (gh) not installed${NC}"
    echo "Install with: brew install gh"
    echo "Or use manual release: ./release.sh $VERSION"
    exit 1
fi

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo -e "${RED}❌ Error: Not authenticated with GitHub CLI${NC}"
    echo "Run: gh auth login"
    exit 1
fi

# Validate version format
if [[ ! $VERSION =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo -e "${RED}❌ Error: Invalid version format${NC}"
    echo "Version should be in format: v1.0.0"
    exit 1
fi

echo -e "${YELLOW}📋 Pre-release checks...${NC}"

# Check for uncommitted changes
if [[ -n $(git status --porcelain) ]]; then
    echo -e "${RED}❌ Error: You have uncommitted changes${NC}"
    git status --short
    echo "Please commit or stash your changes first"
    exit 1
fi

# Run tests and build
echo -e "${YELLOW}🔍 Running type check...${NC}"
npm run check

echo -e "${YELLOW}🏗️  Building project...${NC}"
npm run build

echo -e "${GREEN}✅ All checks passed!${NC}"

# Update package.json version
echo -e "${YELLOW}📝 Updating package.json version...${NC}"
CLEAN_VERSION=${VERSION#v}  # Remove 'v' prefix
npm version $CLEAN_VERSION --no-git-tag-version

# Commit version bump
git add package.json
git commit -m "chore: bump version to $VERSION"

# Push changes
echo -e "${YELLOW}📤 Pushing changes...${NC}"
git push origin $(git rev-parse --abbrev-ref HEAD)

# Create GitHub release (will auto-create tag and trigger deployment)
echo -e "${YELLOW}🚀 Creating GitHub release...${NC}"
gh release create $VERSION \
    --title "Release $VERSION" \
    --notes "## 🚀 TOTP Generator $VERSION

### What's New
- Production-ready build
- Automatic deployment via Cloudflare Pages  
- Optimized bundle size and performance

### Deployment
This release is automatically deployed to:
https://totp.dev.ruriazz.com

Generated on: $(date -u)" \
    --latest

echo -e "${GREEN}🎉 Release $VERSION published successfully!${NC}"
echo ""
echo -e "${BLUE}📋 What happens now:${NC}"
echo "1. ✅ GitHub release published and tagged"
echo "2. 🔄 GitHub Actions deployment triggered automatically"
echo "3. 🌐 App will be live at: https://totp.dev.ruriazz.com"
echo ""
echo -e "${BLUE}🔗 Useful links:${NC}"
echo "- Release: https://github.com/ruriazz/TOTP/releases/tag/$VERSION"
echo "- Actions: https://github.com/ruriazz/TOTP/actions"
echo ""
echo -e "${GREEN}✨ Happy deploying!${NC}"
