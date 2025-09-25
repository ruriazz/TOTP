#!/bin/bash

# Emergency deployment script untuk test Cloudflare Pages
# Usage: ./test-deploy.sh

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🔧 Emergency Deployment Test${NC}"
echo "=================================="

# Build project
echo -e "${YELLOW}🏗️  Building project...${NC}"
npm run build

echo -e "${YELLOW}📤 Testing deployment options...${NC}"

echo ""
echo -e "${BLUE}Option 1: Deploy as production (master branch)${NC}"
echo "Command: wrangler pages deploy dist --project-name=totp --branch=master"
echo ""

echo -e "${BLUE}Option 2: Deploy as preview${NC}"  
echo "Command: wrangler pages deploy dist --project-name=totp"
echo ""

echo -e "${BLUE}Option 3: Check project info${NC}"
echo "Command: wrangler pages project list"
echo ""

echo -e "${YELLOW}Choose deployment method:${NC}"
echo "1) Deploy to production (master branch)"
echo "2) Deploy as preview"
echo "3) List projects"
echo "4) Exit"

read -p "Enter choice (1-4): " choice

case $choice in
    1)
        echo -e "${GREEN}🚀 Deploying to production...${NC}"
        wrangler pages deploy dist --project-name=totp --branch=master --commit-message="Emergency deployment $(date)"
        ;;
    2)
        echo -e "${GREEN}🔍 Deploying as preview...${NC}"
        wrangler pages deploy dist --project-name=totp
        ;;
    3)
        echo -e "${GREEN}📋 Listing projects...${NC}"
        wrangler pages project list
        ;;
    4)
        echo -e "${GREEN}👋 Aborted${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}❌ Invalid choice${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}✅ Deployment completed!${NC}"
echo -e "${BLUE}Check your Cloudflare Pages dashboard for results.${NC}"
