#!/bin/bash

ROOT_DIR="/mnt/c/project/openmetadata-assets"
TFLINT_CONFIG_FILE="$ROOT_DIR/.tflint.hcl"
MODULES_DIR="$ROOT_DIR/infra/terragrunt/modules"

for module_dir in $(find "$MODULES_DIR" -maxdepth 5 -type d); do
  echo "Running tflint at: $module_dir"
  pushd "$module_dir" >/dev/null
    TFLINT_CONFIG_FILE="$TFLINT_CONFIG_FILE" tflint --recursive
  popd >/dev/null
done
