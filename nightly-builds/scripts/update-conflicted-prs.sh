#!/bin/bash
# Update conflicted nightly build PRs by rebasing on main
# Usage: ./update-conflicted-prs.sh [--dry-run]

set -e

DRY_RUN=false
if [ "$1" = "--dry-run" ]; then
  DRY_RUN=true
  echo "🔍 DRY RUN MODE - No changes will be made"
fi

REPOS=(
  "jamesalmeida/konteks-ios:/Users/james/repos/konteks-ios"
  "jamesalmeida/konteks-web:/Users/james/repos/konteks-web"
)

for repo_path in "${REPOS[@]}"; do
  repo="${repo_path%%:*}"
  local_path="${repo_path##*:}"
  
  echo "📁 Checking $repo..."
  
  # Get conflicted PRs
  conflicted=$(gh pr list --repo "$repo" --state open --json number,title,headRefName,mergeable \
    --jq '.[] | select(.mergeable == "CONFLICTING") | "\(.number)|\(.title)|\(.headRefName)"' 2>/dev/null || true)
  
  if [ -z "$conflicted" ]; then
    echo "   No conflicted PRs"
    continue
  fi
  
  while IFS='|' read -r num title branch; do
    echo "   ⚠️  #$num: $title"
    
    if [ "$DRY_RUN" = true ]; then
      echo "      ↳ Would rebase $branch on main"
      continue
    fi
    
    # Check if local repo exists
    if [ ! -d "$local_path/.git" ]; then
      echo "      ↳ ❌ Local repo not found at $local_path"
      continue
    fi
    
    # Try to rebase
    cd "$local_path"
    git fetch origin --quiet
    
    # Check if branch exists locally, if not fetch it
    if ! git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
      echo "      ↳ ❌ Branch not found on origin"
      continue
    fi
    
    # Create a temp branch for the rebase
    temp_branch="temp-rebase-$num"
    git checkout -B "$temp_branch" "origin/$branch" --quiet 2>/dev/null || {
      echo "      ↳ ❌ Failed to checkout branch"
      continue
    }
    
    # Attempt rebase
    if git rebase origin/main --quiet 2>/dev/null; then
      # Push force with lease
      if git push --force-with-lease origin "$temp_branch:$branch" --quiet 2>/dev/null; then
        echo "      ↳ ✅ Rebased and pushed"
      else
        echo "      ↳ ❌ Push failed (may need manual intervention)"
      fi
    else
      echo "      ↳ ❌ Rebase failed (manual conflict resolution needed)"
      git rebase --abort 2>/dev/null || true
    fi
    
    # Cleanup
    git checkout main --quiet 2>/dev/null || git checkout - --quiet 2>/dev/null || true
    git branch -D "$temp_branch" --quiet 2>/dev/null || true
    
  done <<< "$conflicted"
  
  echo ""
done

echo "✨ Done!"
