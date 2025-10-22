#!/bin/bash
set -e

# --- Repository List: Defines the structural core of the MSH Platform ---
# These are the sub-repositories needed to make the Codespace workspace complete.
# Format: "owner/repo -> folder-name" or "owner/repo"
# We use shallow clones (--depth 1) for speed during Codespace startup.

REPOS=(
    "Makingsmileshappen/uii-protocol-core -> uii-protocol-core" # The heart of the UII logic (the 5-field wrapper)
    "Makingsmileshappen/msh-patient-portal -> patient-portal"  # The front-end for Trust Custodians/Social Workers
    "Makingsmileshappen/partner-reporting-dashboard -> partner-reporting" # The dashboard Kimpton will use (Integrity Audit)
    "Makingsmileshappen/msu-platform-docs -> documentation" # The open-source documentation and white papers
)

echo "--- Cloning Repositories for MSH Codespace Workspace ---"

for repo_entry in "${REPOS[@]}"; do
    repo_name=$(echo "$repo_entry" | awk '{print $1}')
    folder_name=$(echo "$repo_entry" | awk '{print $3}') # Checks for '-> folder-name'

    if [ -z "$folder_name" ]; then
        # Default folder name is the repo name without the owner part
        folder_name=$(basename "$repo_name")
    fi

    if [ ! -d "$folder_name" ]; then
        echo "Cloning $repo_name into $folder_name..."
        
        # Use 'gh' for seamless authentication, and '--depth 1' for a fast clone.
        # This is the command that handles the repository fetching.
        gh repo clone "$repo_name" "$folder_name" -- --depth 1
        
        if [ $? -eq 0 ]; then
            echo "Successfully cloned $repo_name."
        else
            echo "Error cloning $repo_name. Please ensure 'gh login' or permissions are set."
        fi
    else
        echo "Skipping $folder_name: Folder already exists."
    fi
done

echo "--- Repository Setup Complete ---"
