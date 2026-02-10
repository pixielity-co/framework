#!/usr/bin/env bash

# ==============================================================================
# Pixielity Framework Subtree Split Script
# ==============================================================================
# This script automates the process of splitting the monorepo into individual
# read-only repositories for each package. It uses splitsh-lite to perform
# the extraction and pushes the resulting commits to GitHub.
#
# Requirements:
#   - splitsh-lite (https://github.com/splitsh/lite)
#   - jq (for parsing splitsh.json)
#   - GH_TOKEN environment variable (for authentication)
# ==============================================================================

set -e # Exit immediately if a command exits with a non-zero status
set -u # Treat unset variables as an error
# set -x # Uncomment for debugging: print commands and their arguments as they are executed

# ------------------------------------------------------------------------------
# 1. Environment and Dependency Checks
# ------------------------------------------------------------------------------

# Ensure splitsh-lite is available in the system PATH
if ! command -v splitsh-lite &> /dev/null
then
    echo "Error: splitsh-lite could not be found. Please install it."
    echo "Visit: https://github.com/splitsh/lite"
    exit 1
fi

# Ensure jq is available for JSON parsing
if ! command -v jq &> /dev/null
then
    echo "Error: jq could not be found. Please install it."
    exit 1
fi

# Ensure GH_TOKEN is set for GitHub authentication
if [ -z "${GH_TOKEN:-}" ]; then
  echo "Error: GH_TOKEN environment variable is not set."
  echo "This is required for pushing to GitHub repositories."
  exit 1
fi

# ------------------------------------------------------------------------------
# 2. Configuration and Preparation
# ------------------------------------------------------------------------------

# Path to the configuration file
CONFIG_FILE="splitsh.json"

# Check if the configuration file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Configuration file $CONFIG_FILE not found."
    exit 1
fi

# Target branch in the sub-repositories (usually 'main' or 'master')
CURRENT_BRANCH="main"

# Extract package mapping from splitsh.json
# Format: "package-name path/to/package"
PACKAGES=$(jq -r ".subtrees | to_entries | .[] | \"\(.key) \(.value)\"" "$CONFIG_FILE")

# ------------------------------------------------------------------------------
# 3. Execution of the Splitting Process
# ------------------------------------------------------------------------------

echo "Starting subtree split process..."

# Iterate over each package defined in the configuration
while read -r PACKAGE_NAME PACKAGE_PATH; do
    if [ -z "$PACKAGE_NAME" ]; then continue; fi

    echo "----------------------------------------------------------------"
    echo "Processing Package: ${PACKAGE_NAME}"
    echo "Source Path: ${PACKAGE_PATH}"

    # Construct the remote URL using the GH_TOKEN for authentication
    # This format allows pushing without manual credential entry
    REMOTE_URL="https://x-access-token:${GH_TOKEN}@github.com/${PACKAGE_NAME}.git"

    # Execute splitsh-lite to get the SHA1 of the split subtree
    # --prefix: The directory to extract
    # --target: The branch/reference to split from
    echo "Extracting subtree..."
    SHA1=$(splitsh-lite --prefix="${PACKAGE_PATH}" --target=HEAD)
    
    # Push the split subtree to the remote repository
    # -f: Force push to ensure the remote matches the local split exactly
    echo "Pushing to remote: ${REMOTE_URL}"
    git push "${REMOTE_URL}" "${SHA1}:refs/heads/${CURRENT_BRANCH}" -f
    
    echo "Successfully pushed ${PACKAGE_NAME}"

done <<< "$PACKAGES"

echo "================================================================"
echo "All packages split and pushed successfully."
echo "================================================================"
