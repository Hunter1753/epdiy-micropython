#!/bin/sh

# Exit immediately if a command exits with a non-zero status
set -e

echo "Build cross-compiler..."

cd micropython/
make -C mpy-cross
cd -

echo "Cross-compiler build done."

# Get the root directory of the project (where this script lives)
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PATCH_BASE_DIR="$PROJECT_ROOT/patches"

echo "Checking for patches to apply..."

# 1. Iterate through each subdirectory in the patches folder
for SUBMODULE_NAME in $(ls "$PATCH_BASE_DIR"); do
    SUBMODULE_PATH="$PROJECT_ROOT/$SUBMODULE_NAME"
    PATCH_DIR="$PATCH_BASE_DIR/$SUBMODULE_NAME"

    # Check if the submodule directory actually exists
    if [ -d "$SUBMODULE_PATH" ]; then
        echo "--> Processing patches for: $SUBMODULE_NAME"
        
        # 2. Find all .patch files and apply them
        for PATCH_FILE in $(ls "$PATCH_DIR"/*.patch 2>/dev/null); do
            
            # Check if patch is already applied to avoid errors
            if git -C "$SUBMODULE_PATH" apply --check "$PATCH_FILE" > /dev/null 2>&1; then
                echo "    Applying: $(basename "$PATCH_FILE")"
                git -C "$SUBMODULE_PATH" apply "$PATCH_FILE"
            else
                echo "    Skipping: $(basename "$PATCH_FILE") (already applied or conflict)"
            fi
        done
    else
        echo "--> Warning: Submodule directory $SUBMODULE_NAME not found. Skipping."
    fi
done

echo "Preparation complete."