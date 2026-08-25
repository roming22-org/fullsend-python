#!/usr/bin/env bash
# pre-haiku.sh — Download a cat image for the haiku agent.
#
# Runs on the host runner before the sandbox starts.
# Downloads a random cat image from one of several sources, base64
# encodes it, and saves both the raw image and encoded data for
# host_files to copy into the sandbox.
#
# Outputs:
#   /tmp/haiku-input/cat.jpg      — raw cat image
#   /tmp/haiku-input/cat.b64      — base64 encoded image
#   /tmp/haiku-input/cat-url.txt  — permanent URL to the cat image

set -euo pipefail

INPUT_DIR="/tmp/haiku-input"
mkdir -p "${INPUT_DIR}"

echo "Fetching cat image..."

CAT_URL=""
GOT_IMAGE=false

# --- Attempt 1: cataas.com JSON API (get permanent ID) ---
echo "Trying cataas.com JSON API..."
if CAT_JSON=$(curl -sL --max-time 10 \
     "https://cataas.com/cat?json=true" 2>/dev/null); then
  CAT_ID=$(printf '%s' "${CAT_JSON}" \
    | jq -r '._id // empty' 2>/dev/null || true)
  if [[ -n "${CAT_ID}" ]]; then
    CAT_URL="https://cataas.com/cat/${CAT_ID}"
    echo "Downloading cat ${CAT_ID} from cataas.com..."
    if curl -sL --max-time 30 -o "${INPUT_DIR}/cat.jpg" "${CAT_URL}"; then
      FILE_SIZE=$(wc -c < "${INPUT_DIR}/cat.jpg")
      if [[ "${FILE_SIZE}" -ge 100 ]]; then
        GOT_IMAGE=true
        echo "Got cat image from cataas.com with permanent URL"
      fi
    fi
  fi
fi

# --- Attempt 2: cataas.com direct download (capture redirect URL) ---
if [[ "${GOT_IMAGE}" != "true" ]]; then
  echo "Trying cataas.com direct download..."
  EFFECTIVE_URL=$(curl -sL --max-time 30 \
    -o "${INPUT_DIR}/cat.jpg" \
    -w '%{url_effective}' "https://cataas.com/cat" 2>/dev/null || true)

  FILE_SIZE=$(wc -c < "${INPUT_DIR}/cat.jpg" 2>/dev/null || echo "0")
  if [[ "${FILE_SIZE}" -ge 100 ]]; then
    GOT_IMAGE=true
    # Try to extract a cat ID from the effective URL after redirects
    if [[ "${EFFECTIVE_URL}" =~ /cat/([a-zA-Z0-9]+) ]]; then
      CAT_URL="https://cataas.com/cat/${BASH_REMATCH[1]}"
      echo "Extracted permanent URL from redirect: ${CAT_URL}"
    fi
  fi
fi

# --- Attempt 3: thecatapi.com (reliable permanent URLs, no key needed) ---
if [[ "${GOT_IMAGE}" != "true" ]] || [[ -z "${CAT_URL}" ]]; then
  echo "Trying thecatapi.com..."
  if API_RESPONSE=$(curl -sL --max-time 10 \
       "https://api.thecatapi.com/v1/images/search" 2>/dev/null); then
    API_URL=$(printf '%s' "${API_RESPONSE}" \
      | jq -r '.[0].url // empty' 2>/dev/null || true)
    if [[ -n "${API_URL}" ]]; then
      echo "Downloading cat from thecatapi.com..."
      if curl -sL --max-time 30 -o "${INPUT_DIR}/cat.jpg" "${API_URL}"; then
        FILE_SIZE=$(wc -c < "${INPUT_DIR}/cat.jpg")
        if [[ "${FILE_SIZE}" -ge 100 ]]; then
          CAT_URL="${API_URL}"
          GOT_IMAGE=true
          echo "Got cat image from thecatapi.com"
        fi
      fi
    fi
  fi
fi

# --- Verify we got a valid image ---
if [[ "${GOT_IMAGE}" != "true" ]]; then
  echo "ERROR: Could not download a cat image from any source" >&2
  exit 1
fi

FILE_SIZE=$(wc -c < "${INPUT_DIR}/cat.jpg")
if [[ "${FILE_SIZE}" -lt 100 ]]; then
  echo "ERROR: Downloaded file is too small (${FILE_SIZE} bytes)" >&2
  exit 1
fi

# Save the permanent URL
echo "${CAT_URL}" > "${INPUT_DIR}/cat-url.txt"

# Base64 encode the image
base64 < "${INPUT_DIR}/cat.jpg" > "${INPUT_DIR}/cat.b64"

echo "Cat image saved (${FILE_SIZE} bytes)"
if [[ -n "${CAT_URL}" ]]; then
  echo "Permanent URL: ${CAT_URL}"
else
  echo "Warning: No permanent URL available for this image"
fi
echo "Pre-script complete."
