#!/bin/bash

# Branch Protection Script for GitHub Repos
# Usage: ./scripts/protect.sh <owner/repo>
# Example: ./scripts/protect.sh LeBaThien/my-new-repo

REPO=$1

if [ -z "$REPO" ]; then
  echo "Usage: ./scripts/protect.sh <owner/repo>"
  echo "Example: ./scripts/protect.sh LeBaThien/my-new-repo"
  exit 1
fi

echo "Setting branch protection for $REPO (main)..."

gh api "repos/$REPO/branches/main/protection" -X PUT --input - <<'EOF'
{
  "required_pull_request_reviews": {
    "required_approving_review_count": 0,
    "dismiss_stale_reviews": true,
    "require_last_push_approval": false
  },
  "enforce_admins": false,
  "required_status_checks": null,
  "restrictions": null,
  "required_linear_history": true,
  "allow_force_pushes": false,
  "allow_deletions": false,
  "block_creations": false,
  "required_conversation_resolution": true
}
EOF

if [ $? -eq 0 ]; then
  echo ""
  echo "Branch protection enabled for $REPO/main:"
  echo "  - Require PR before merging"
  echo "  - Dismiss stale reviews"
  echo "  - Required linear history"
  echo "  - Required conversation resolution"
  echo "  - Block force pushes"
  echo "  - Block deletions"
else
  echo "Failed to set branch protection. Check repo name and gh auth."
fi
