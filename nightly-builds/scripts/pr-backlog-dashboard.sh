#!/bin/bash
# PR Backlog Dashboard - Shows status of all nightly build PRs across repos
# Usage: ./pr-backlog-dashboard.sh

set -e

REPOS=(
  "jamesalmeida/konteks-ios"
  "jamesalmeida/konteks-web"
  "jamesalmeida/konteks-relay"
  "jamesalmeida/konteks"
  "jamesalmeida/fastclaw"
)

echo "🌙 Nightly Build PR Dashboard"
echo "============================="
echo "Generated: $(date)"
echo ""

total_prs=0
mergeable_prs=0
conflicted_prs=0

for repo in "${REPOS[@]}"; do
  echo "📁 $repo"
  echo "   $(gh repo view "$repo" --json url -q .url)"
  
  # Get open PRs
  prs=$(gh pr list --repo "$repo" --state open --json number,title,headRefName,mergeStateStatus,mergeable --jq '.[] | "\(.number)|\(.title)|\(.headRefName)|\(.mergeStateStatus)|\(.mergeable)"' 2>/dev/null || true)
  
  if [ -z "$prs" ]; then
    echo "   No open PRs"
  else
    while IFS='|' read -r num title branch status mergeable; do
      total_prs=$((total_prs + 1))
      
      # Determine status icon
      if [ "$mergeable" = "MERGEABLE" ]; then
        icon="✅"
        mergeable_prs=$((mergeable_prs + 1))
      elif [ "$status" = "DIRTY" ]; then
        icon="⚠️"
        conflicted_prs=$((conflicted_prs + 1))
      else
        icon="⏳"
      fi
      
      # Truncate title
      if [ ${#title} -gt 50 ]; then
        title="${title:0:47}..."
      fi
      
      echo "   $icon #$num: $title"
      
      # Check if it's a nightly build branch
      if [[ "$branch" == nightly/* ]] || [[ "$branch" == feat/* ]] || [[ "$branch" == fix/* ]] || [[ "$branch" == feature/* ]]; then
        pr_url="https://github.com/$repo/pull/$num"
        echo "      ↳ $pr_url"
      fi
    done <<< "$prs"
  fi
  
  echo ""
done

echo "============================="
echo "📊 Summary"
echo "   Total open PRs: $total_prs"
echo "   ✅ Mergeable: $mergeable_prs"
echo "   ⚠️  Has conflicts: $conflicted_prs"
echo "   ⏳  Pending checks: $((total_prs - mergeable_prs - conflicted_prs))"
echo ""

if [ $conflicted_prs -gt 0 ]; then
  echo "💡 Tip: Run './scripts/update-conflicted-prs.sh' to rebase conflicted PRs"
fi
