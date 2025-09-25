#!/bin/bash

# Release script untuk TOTP Generator
# Usage: ./release.sh [version]
# Contoh: ./release.sh v1.0.0

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 TOTP Generator Release Script${NC}"
echo "=================================="

# Check if version is provided
if [ -z "$1" ]; then
    echo -e "${RED}❌ Error: Version tag required${NC}"
    echo "Usage: ./release.sh [version]"
    echo "Example: ./release.sh v1.0.0"
    exit 1
fi

VERSION=$1

# Validate version format
if [[ ! $VERSION =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo -e "${RED}❌ Error: Invalid version format${NC}"
    echo "Version should be in format: v1.0.0"
    exit 1
fi

echo -e "${YELLOW}📋 Pre-release checks...${NC}"

# Check if we're on the right branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$CURRENT_BRANCH" != "master" ] && [ "$CURRENT_BRANCH" != "main" ]; then
    echo -e "${YELLOW}⚠️  Warning: You're on branch '$CURRENT_BRANCH', not 'master' or 'main'${NC}"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${RED}❌ Aborted${NC}"
        exit 1
    fi
fi

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

# Create and push tag
echo -e "${YELLOW}🏷️  Creating tag $VERSION...${NC}"
git tag -a $VERSION -m "Release $VERSION

🚀 TOTP Generator $VERSION

## What's New
- Production-ready build
- Automatic deployment via Cloudflare Pages
- Optimized bundle size and performance

## Deployment
This release will be automatically deployed to:
https://totp-generator.pages.dev

Generated on: $(date -u)
"

echo -e "${YELLOW}📤 Pushing to remote...${NC}"
git push origin $CURRENT_BRANCH
git push origin $VERSION

echo -e "${GREEN}🎉 Release $VERSION created successfully!${NC}"
echo ""
echo -e "${BLUE}📋 What happens next:${NC}"
echo "1. GitHub Actions will automatically build and deploy to Cloudflare Pages"
echo "2. Check the 'Actions' tab in GitHub for deployment progress"
echo "3. Your app will be live at: https://totp-generator.pages.dev"
echo ""
echo -e "${BLUE}🔗 Useful links:${NC}"
echo "- GitHub Releases: https://github.com/ruriazz/TOTP/releases"
echo "- Actions: https://github.com/ruriazz/TOTP/actions"
echo "- Cloudflare Dashboard: https://dash.cloudflare.com/pages"
echo ""
echo -e "${GREEN}✨ Happy deploying!${NC}"
