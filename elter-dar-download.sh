#!/usr/bin/env bash

DATASET_IDS=("XXXXX-XXXXX" "YYYYY-YYYYY" "ZZZZZ-ZZZZZ")

# Path where the script is stored
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Read personal DAR access token from file
# token to be generated in DAR: https://dar.elter-ri.eu/account/settings/applications/tokens/new/
ACCESS_TOKEN=$(grep -Ev "^\s*(#|$)" ${BASE_DIR}/.elter-dar-access-token | head -n1)

for DATASET_ID in "${DATASET_IDS[@]}"; do
  echo "Processing: $DATASET_ID"
  DATASET_URL="https://dar.elter-ri.eu/api/datasets/${DATASET_ID}/draft/files-archive"
  # wget --header "Cookie: session=${SESSION_COOKIE}" "${DATASET_URL}"
  wget --header "Authorization: Bearer ${ACCESS_TOKEN}" "${DATASET_URL}"
  unzip "files-archive"
  rm "files-archive"
done
