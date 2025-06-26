#!/bin/bash
# set -e

ROOT_DIR="/mnt/c/project/openmetadata-assets/infra/terragrunt/module/module/aws/openmetadata/ecr/dockerfile"
ELASTICSEARCH_TAG="8.11.4"
OPENMETADATA_TAG="1.6.2-release"

ELASTICSEARCH_REPO="https://github.com/elastic/dockerfiles/archive/refs/tags/v${ELASTICSEARCH_TAG}.zip"
OPENMETADATA_REPO="https://github.com/open-metadata/OpenMetadata/archive/refs/tags/${OPENMETADATA_TAG}.zip"

# create temp directory
TEMP_DIR_ELASTIC="$(mktemp -d)"
TEMP_DIR_OM="$(mktemp -d)"

cleanup() {
  echo "=== Cleaning up ==="
  rm -rf "${TEMP_DIR_ELASTIC}" "${TEMP_DIR_OM}"
}
trap cleanup EXIT

echo "=== Downloading zip ==="
curl --retry 3 --retry-delay 5 -fsSL "${ELASTICSEARCH_REPO}" -o "${TEMP_DIR_ELASTIC}/elastic.zip"
curl --retry 3 --retry-delay 5 -fsSL "${OPENMETADATA_REPO}" -o "${TEMP_DIR_OM}/openmetadata.zip"

echo "=== Extracting zip ==="
unzip -q "${TEMP_DIR_ELASTIC}/elastic.zip" -d "${TEMP_DIR_ELASTIC}"
unzip -q "${TEMP_DIR_OM}/openmetadata.zip" -d "${TEMP_DIR_OM}"

echo "=== Syncing (with --delete) ==="
# elastic search
rsync -av --delete --exclude="image_build.sh" \
  "${TEMP_DIR_ELASTIC}/dockerfiles-${ELASTICSEARCH_TAG}/elasticsearch/" \
  "${ROOT_DIR}/elasticsearch/"

# ingestion
rsync -av --delete \
  "${TEMP_DIR_OM}/OpenMetadata-${OPENMETADATA_TAG}/ingestion/examples/airflow/" \
  "${ROOT_DIR}/ingestion/ingestion/examples/airflow/"
rsync -av --delete \
  "${TEMP_DIR_OM}/OpenMetadata-${OPENMETADATA_TAG}/ingestion/examples/sample_data/" \
  "${ROOT_DIR}/ingestion/ingestion/examples/sample_data/"
rsync -av --delete \
  "${TEMP_DIR_OM}/OpenMetadata-${OPENMETADATA_TAG}/ingestion/ingestion_dependency.sh" \
  "${ROOT_DIR}/ingestion/ingestion/ingestion_dependency.sh"
rsync -av --delete \
  "${TEMP_DIR_OM}/OpenMetadata-${OPENMETADATA_TAG}/ingestion/__init__.py" \
  "${ROOT_DIR}/ingestion/__init__.py"
rsync -av --delete \
  "${TEMP_DIR_OM}/OpenMetadata-${OPENMETADATA_TAG}/ingestion/Dockerfile" \
  "${ROOT_DIR}/ingestion/Dockerfile"
rsync -av --delete \
  "${TEMP_DIR_OM}/OpenMetadata-${OPENMETADATA_TAG}/ingestion/pyproject.toml
" \
  "${ROOT_DIR}/ingestion/pyproject.toml
"
rsync -av --delete \
  "${TEMP_DIR_OM}/OpenMetadata-${OPENMETADATA_TAG}/ingestion/setup.py" \
  "${ROOT_DIR}/ingestion/setup.py"

# openmetadata
rsync -av --delete \
  "${TEMP_DIR_OM}/OpenMetadata-${OPENMETADATA_TAG}/bin/" \
  "${ROOT_DIR}/openmetadata/bin/"
rsync -av --delete \
  "${TEMP_DIR_OM}/OpenMetadata-${OPENMETADATA_TAG}/bootstrap/" \
  "${ROOT_DIR}/openmetadata/bootstrap/"
rsync -av --delete \
  "${TEMP_DIR_OM}/OpenMetadata-${OPENMETADATA_TAG}/conf/" \
  "${ROOT_DIR}/openmetadata/conf/"
rsync -av --delete \
  "${TEMP_DIR_OM}/OpenMetadata-${OPENMETADATA_TAG}/docker/openmetadata-start.sh" \
  "${ROOT_DIR}/openmetadata/docker/openmetadata-start.sh"
rsync -av --delete \
  "${TEMP_DIR_OM}/OpenMetadata-${OPENMETADATA_TAG}/openmetadata-dist/" \
  "${ROOT_DIR}/openmetadata/openmetadata-dist/"
rsync -av --delete \
  "${TEMP_DIR_OM}/OpenMetadata-${OPENMETADATA_TAG}/docker/development/Dockerfile" \
  "${ROOT_DIR}/openmetadata/Dockerfile"
rsync -av --delete \
  "${TEMP_DIR_OM}/OpenMetadata-${OPENMETADATA_TAG}/README.md" \
  "${ROOT_DIR}/openmetadata/README.md"

echo "Done."