#!/usr/bin/env bash

# json fields to query to select fields
QUERY=$(cat <<'EOF'
.id,
.metadata.titles[0].titleText,
.metadata.siteReferences[0].siteName,
.metadata.siteReferences[0].siteID,
.metadata.datasetType.datasetTypeCode,
.metadata.descriptions[0].descriptionText,
.metadata.responsibleOrganizations[0].organizationName,
.access.embargo.active,
.access.embargo.reason
EOF
)

# Path where the script is stored
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Read personal DAR access token from file
# token to be generated in DAR: https://dar.elter-ri.eu/account/settings/applications/tokens/new/
ACCESS_TOKEN=$(grep -Ev "^\s*(#|$)" ${BASE_DIR}/.elter-dar-access-token | head -n1)

# Print query as csv heading
echo ${QUERY}
JQ_QUERY="[${QUERY}] | @csv"

while IFS= read -r p
  do
    # Handles CRLF, skip empty lines, skip comment lines starting with #
    p="${p%$'\r'}"
    [[ -z "$p" || "$p" =~ ^# ]] && continue

    ENDPOINT="https://dar.elter-ri.eu/api/datasets/${p}/draft"
    curl "${ENDPOINT}" -H "Authorization: Bearer ${ACCESS_TOKEN}" | jq -r "${JQ_QUERY}"
done < ${BASE_DIR}/eLTER-Data-Call-2025-Uploads.md