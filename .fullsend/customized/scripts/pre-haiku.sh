#!/usr/bin/env bash
# pre-haiku.sh — Download a cat image for the haiku agent.
#
# Runs on the host runner before the sandbox starts.
# Downloads a random cat image from cataas.com, base64 encodes it,
# and saves both the raw image and encoded data for host_files to
# copy into the sandbox.
#
# Outputs:
#   /tmp/haiku-input/cat.jpg  — raw cat image
#   /tmp/haiku-input/cat.b64  — base64 encoded image
#   /tmp/haiku-input/cat-url.txt — permanent URL to the cat image (if available)

set -euo pipefail

INPUT_DIR="/tmp/haiku-input"
mkdir -p "${INPUT_DIR}"

echo "Fetching cat image from cataas.com..."

# Try to get a cat with a permanent ID first so the post-script
# can link to it in the GitHub comment.
CAT_ID=""
if CAT_JSON=$(curl -sL --max-time 10 "https://cataas.com/cat?json=true" 2>/dev/null); then
  CAT_ID=$(printf '%s' "${CAT_JSON}" | jq -r '._id // empty' 2>/dev/null || true)
fi

if [[ -n "${CAT_ID}" ]]; then
  CAT_URL="https://cataas.com/cat/${CAT_ID}"
  echo "Downloading cat ${CAT_ID}..."
  curl -sL --max-time 30 -o "${INPUT_DIR}/cat.jpg" "${CAT_URL}"
  echo "${CAT_URL}" > "${INPUT_DIR}/cat-url.txt"
else
  echo "Could not get cat ID, downloading random cat..."
  curl -sL --max-time 30 -o "${INPUT_DIR}/cat.jpg" "https://cataas.com/cat"
  echo "" > "${INPUT_DIR}/cat-url.txt"
fi

# Verify we got a non-empty image
FILE_SIZE=$(wc -c < "${INPUT_DIR}/cat.jpg")
if [[ "${FILE_SIZE}" -lt 100 ]]; then
  echo "ERROR: Downloaded file is too small (${FILE_SIZE} bytes), likely not a valid image" >&2
  exit 1
fi

# Base64 encode the image
base64 < "${INPUT_DIR}/cat.jpg" > "${INPUT_DIR}/cat.b64"

echo "Cat image saved (${FILE_SIZE} bytes)"
echo "Pre-script complete."
