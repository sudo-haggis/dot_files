#!/bin/bash
# Smart Tag Script
# Syncs version headers to match tag, commits, then creates tag
# Usage: smart-tag.sh v2.1.0

set -e

# Consistent color scheme
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Get tag from argument
NEW_TAG="$1"

# Validate tag provided
if [ -z "$NEW_TAG" ]; then
    echo -e "${RED}❌ No tag specified${NC}"
    echo "Usage: smart-tag.sh v2.1.0"
    exit 1
fi

# Validate tag format
if ! [[ "$NEW_TAG" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo -e "${RED}❌ Invalid tag format: $NEW_TAG${NC}"
    echo "Expected format: v1.2.3"
    exit 1
fi

echo -e "${BLUE}🏷️  Smart tagging with $NEW_TAG...${NC}"
echo ""

# Check if tag already exists
if git rev-parse "$NEW_TAG" >/dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  Tag $NEW_TAG already exists${NC}"
    echo -e -n "${YELLOW}Delete and recreate? [y/N]: ${NC}"
    read -r response
    
    if [[ "$response" =~ ^[Yy]$ ]]; then
        git tag -d "$NEW_TAG"
        echo -e "${GREEN}✅ Deleted old tag${NC}"
    else
        echo -e "${RED}❌ Aborted${NC}"
        exit 1
    fi
fi

echo ""
echo -e "${BLUE}✏️  Syncing versions to $NEW_TAG...${NC}"

# Track what changed
files_updated=0
declare -a UPDATED_FILES

# Check if file has version header in first 10 lines
has_version_header() {
    head -10 "$1" 2>/dev/null | grep -qE "@version|__version__|version\s*[:=]"
}

# Check if file opted out
is_opted_out() {
    head -10 "$1" 2>/dev/null | grep -qiE "@version\s+(null|none|N/A)|__version__\s*=\s*[\"'](null|none|N/A)[\"']"
}

# Get version from file
get_file_version() {
    local file="$1"
    
    if [[ "$file" =~ \.(js|ts|php)$ ]]; then
        head -10 "$file" | grep "@version" | sed 's/.*@version[[:space:]]*//' | head -1
    elif [[ "$file" =~ \.py$ ]]; then
        head -10 "$file" | grep "__version__" | sed "s/.*[\"']\(v\?[0-9.]*\)[\"'].*/\1/" | head -1
    elif [[ "$file" =~ \.go$ ]]; then
        head -10 "$file" | grep "version" | sed 's/.*"\(v\?[0-9.]*\)".*/\1/' | head -1
    fi
}

# Update version in file
update_file_version() {
    local file="$1"
    local new_version="$2"
    
    if [[ "$file" =~ \.(js|ts|php)$ ]]; then
        sed -i "s/@version.*/@version $new_version/" "$file"
    elif [[ "$file" =~ \.py$ ]]; then
        sed -i "s/__version__[[:space:]]*=[[:space:]]*[\"']v\?[0-9.]*[\"']/__version__ = \"$new_version\"/" "$file"
    elif [[ "$file" =~ \.go$ ]]; then
        sed -i "s/version[[:space:]]*=[[:space:]]*\"v\?[0-9.]*\"/version = \"$new_version\"/" "$file"
    fi
}

# Search all git-tracked files
while IFS= read -r file; do
    [ ! -f "$file" ] && continue
    [ ! -r "$file" ] && continue
    
    has_version_header "$file" || continue
    is_opted_out "$file" && continue
    
    FILE_VERSION=$(get_file_version "$file")
    [ -z "$FILE_VERSION" ] && continue
    
    NORMALIZED_FILE="${FILE_VERSION#v}"
    NORMALIZED_TAG="${NEW_TAG#v}"
    
    if [ "$NORMALIZED_FILE" != "$NORMALIZED_TAG" ]; then
        update_file_version "$file" "$NEW_TAG"
        echo -e "${GREEN}  ✅ $file: $FILE_VERSION → $NEW_TAG${NC}"
        UPDATED_FILES+=("$file")
        ((files_updated++))
    fi
done < <(git ls-files)

# Check package.json
if [ -f "package.json" ]; then
    PACKAGE_VERSION=$(grep '"version"' package.json | cut -d'"' -f4 2>/dev/null || echo "")
    CLEAN_TAG=${NEW_TAG#v}
    
    if [ -n "$PACKAGE_VERSION" ] && [ "$PACKAGE_VERSION" != "$CLEAN_TAG" ]; then
        sed -i "s/\"version\": \"[^\"]*\"/\"version\": \"$CLEAN_TAG\"/" package.json
        echo -e "${GREEN}  ✅ package.json: $PACKAGE_VERSION → $CLEAN_TAG${NC}"
        UPDATED_FILES+=("package.json")
        ((files_updated++))
    fi
fi

# Check pyproject.toml
if [ -f "pyproject.toml" ]; then
    PYPROJECT_VERSION=$(grep '^version' pyproject.toml | cut -d'"' -f2 2>/dev/null || echo "")
    CLEAN_TAG=${NEW_TAG#v}
    
    if [ -n "$PYPROJECT_VERSION" ] && [ "$PYPROJECT_VERSION" != "$CLEAN_TAG" ]; then
        sed -i "s/^version = \"[^\"]*\"/version = \"$CLEAN_TAG\"/" pyproject.toml
        echo -e "${GREEN}  ✅ pyproject.toml: $PYPROJECT_VERSION → $CLEAN_TAG${NC}"
        UPDATED_FILES+=("pyproject.toml")
        ((files_updated++))
    fi
fi

# Commit if files were updated
if [ $files_updated -gt 0 ]; then
    echo ""
    echo -e "${BLUE}📝 Committing version changes...${NC}"
    
    git add "${UPDATED_FILES[@]}"
    git commit -m "chore(version): sync versions to $NEW_TAG" --no-verify
    
    echo -e "${GREEN}✅ Committed $files_updated file(s)${NC}"
else
    echo -e "${CYAN}  No version changes needed${NC}"
fi

# Create the tag
echo ""
echo -e "${BLUE}🏷️  Creating tag $NEW_TAG...${NC}"
git tag "$NEW_TAG"

echo ""
echo -e "${GREEN}✅ Tag $NEW_TAG created successfully!${NC}"
echo ""
echo -e "${CYAN}Next steps:${NC}"
echo -e "${CYAN}  git push origin $(git branch --show-current)${NC}"
echo -e "${CYAN}  git push origin --tags${NC}"
