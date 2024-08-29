#!/bin/bash

set -Eeuo pipefail

# Create necessary directories
mkdir -vp /data/config/comfy/custom_nodes
mkdir -vp /data/config/comfy/catvton_nodes
mkdir -vp /data/.cache

# Declare mounts as an associative array
declare -A MOUNTS

# Define the mounts
MOUNTS["/root/.cache"]="/data/.cache"

## Loop through each mount and create symlinks
#for to_path in "${!MOUNTS[@]}"; do
#  set -Eeuo pipefail
#  from_path="${MOUNTS[${to_path}]}"
#
#  # Only attempt to create the symlink if the destination doesn't already exist
#  if [ ! -L "${to_path}" ] && [ ! -d "${to_path}" ]; then
#    ln -sT "${from_path}" "${to_path}"
#    echo "Mounted $(basename "${from_path}")"
#  else
#    echo "Symlink for ${to_path} already exists or is a directory"
#  fi
#done
#
## Check if any additional startup scripts are needed
#if [ -f "/data/config/comfy/startup.sh" ]; then
#  pushd ${ROOT}
#  . /data/config/comfy/startup.sh
#  popd
#fi
#
#exec "$@"

#!/bin/bash

set -Eeuo pipefail

ROOT="/comfyui"

# Create necessary directories
mkdir -vp /data/config/comfy/custom_nodes
mkdir -vp /data/config/comfy/catvton_nodes
mkdir -vp /data/.cache

# Declare mounts as an associative array
declare -A MOUNTS

# Define the mounts
MOUNTS["/root/.cache"]="/data/.cache"

# Loop through each mount and create symlinks
for to_path in "${!MOUNTS[@]}"; do
  set -Eeuo pipefail
  from_path="${MOUNTS[${to_path}]}"

  # Only attempt to create the symlink if the destination doesn't already exist
  if [ ! -L "${to_path}" ] && [ ! -d "${to_path}" ]; then
    ln -sT "${from_path}" "${to_path}"
    echo "Mounted $(basename "${from_path}")"
  else
    echo "Symlink for ${to_path} already exists or is a directory"
  fi
done

# Check if any additional startup scripts are needed
if [ -f "/data/config/comfy/startup.sh" ]; then
  pushd ${ROOT}
  . /data/config/comfy/startup.sh
  popd
fi

exec "$@"

