#!/bin/zsh

# Git Push and Open Merge/Pull Request Script
# Usage: ./git_push_mr.sh [git push arguments]
# Example: ./git_push_mr.sh --force-with-lease
# Add --verbose to see status messages
# Supports both GitLab (merge requests) and GitHub (pull requests)

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check for verbose flag
VERBOSE=false
ARGS=()
for arg in "$@"; do
    if [[ "$arg" == "--verbose" ]]; then
        VERBOSE=true
    else
        ARGS+=("$arg")
    fi
done

# Function to print colored output (only if verbose)
print_status() {
    if [[ "$VERBOSE" == true ]]; then
        echo -e "${BLUE}[INFO]${NC} $1"
    fi
}

print_success() {
    if [[ "$VERBOSE" == true ]]; then
        echo -e "${GREEN}[SUCCESS]${NC} $1"
    fi
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    print_error "Not in a git repository"
    exit 1
fi

# Get current branch name
current_branch=$(git branch --show-current)
if [[ -z "$current_branch" ]]; then
    print_error "Unable to determine current branch"
    exit 1
fi

print_status "Current branch: $current_branch"

# Check if pushing to main/master - skip MR/PR URL extraction
if [[ "$current_branch" == "main" || "$current_branch" == "master" ]]; then
    print_status "Pushing to $current_branch - skipping merge/pull request URL extraction"

    # Just run git push and exit
    git push "${ARGS[@]}"
    print_success "Push to $current_branch completed!"
    exit 0
fi

# Capture git push output
print_status "Pushing branch..."
push_output=$(git push "${ARGS[@]}" 2>&1) || {
    print_error "Git push failed"
    echo "$push_output"
    exit 1
}

# Display the push output
echo "$push_output"

# Extract merge/pull request URL from the output
# Look for GitLab merge request URLs or GitHub pull request URLs
mr_url=$(echo "$push_output" | grep -oE 'https://[^[:space:]]*(merge_requests/new|pull/new)[^[:space:]]*' | head -1)

if [[ -n "$mr_url" ]]; then
    print_success "Found merge/pull request URL"
    print_status "Opening: $mr_url"
    
    # Open URL in default browser (macOS)
    open "$mr_url"
else
    print_warning "No merge/pull request URL found in git push output"
    print_status "This might happen if:"
    echo "  - The branch already exists on remote"
    echo "  - You're pushing to main/master branch"
    echo "  - Git hosting service is not configured to show request URLs"
fi

print_success "Done!"

