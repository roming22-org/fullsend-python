#!/usr/bin/env bash
# post-haiku.sh — Post a comment with the cat image and haiku text.
#
# Runs on the host runner after the sandbox exits.
# Reads the agent's JSON output, extracts the haiku and image,
# and posts a GitHub comment on the triggering issue or PR.
#
# Required env vars:
#   GITHUB_ISSUE_URL — HTML URL of the issue or PR
#   GH_TOKEN         — GitHub token with issues/pull-requests write scope

set -euo pipefail

: "${GITHUB_ISSUE_URL:?GITHUB_ISSUE_URL must be set}"

# --- Parse issue URL ---

REPO=$(echo "${GITHUB_ISSUE_URL}" | sed 's|https://github.com/||; s|/issues/.*||; s|/pull/.*||')
ISSUE_NUMBER=$(basename "${GITHUB_ISSUE_URL}")

# --- Find agent output ---

RESULT_FILE=""
if [[ -n "${FULLSEND_VALIDATED_ITERATION_DIR:-}" ]]; then
  if [[ -f "${FULLSEND_VALIDATED_ITERATION_DIR}/agent-result.json" ]]; then
    RESULT_FILE="${FULLSEND_VALIDATED_ITERATION_DIR}/agent-result.json"
  fi
else
  for dir in iteration-*/output; do
    if [[ -f "${dir}/agent-result.json" ]]; then
      RESULT_FILE="${dir}/agent-result.json"
    fi
  done
fi

if [[ -z "${RESULT_FILE}" ]]; then
  echo "ERROR: agent-result.json not found" >&2
  exit 1
fi

echo "Reading haiku result from: ${RESULT_FILE}"

# --- Extract fields from agent output ---

HAIKU=$(jq -r '.haiku // empty' "${RESULT_FILE}")
if [[ -z "${HAIKU}" ]]; then
  echo "ERROR: haiku field is empty or missing in agent output" >&2
  exit 1
fi

IMAGE_B64=$(jq -r '.image // empty' "${RESULT_FILE}")
if [[ -z "${IMAGE_B64}" ]]; then
  echo "ERROR: image field is empty or missing in agent output" >&2
  exit 1
fi

# --- Build the comment ---

# Try to get the permanent cat URL saved by the pre-script
CAT_URL=""
if [[ -f "/tmp/haiku-input/cat-url.txt" ]]; then
  CAT_URL=$(cat /tmp/haiku-input/cat-url.txt)
fi

# Build the comment body with the image and haiku
if [[ -n "${CAT_URL}" ]]; then
  # Use the permanent URL for the image
  COMMENT_BODY=$(cat <<EOF
![Cat](${CAT_URL})

${HAIKU}
EOF
)
else
  # No permanent URL available — post the haiku without an inline image.
  # This is preferable to dumping raw base64 data which is unreadable.
  echo "Warning: No permanent image URL available, posting haiku without image"
  COMMENT_BODY=$(cat <<EOF
${HAIKU}

*🐱 (cat image could not be displayed)*
EOF
)
fi

# --- Post the comment ---

echo "Posting haiku comment to ${REPO}#${ISSUE_NUMBER}..."
printf '%s' "${COMMENT_BODY}" | gh issue comment "${ISSUE_NUMBER}" --repo "${REPO}" --body-file -

echo "Post-script complete."
