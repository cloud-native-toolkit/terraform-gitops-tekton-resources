#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)
MODULE_DIR=$(cd "${SCRIPT_DIR}/.."; pwd -P)

NAME="$1"
DEST_DIR="$2"
VERSION="$3"

if [[ -z "${VERSION}" ]]; then
  VERSION="v2.7.1"
fi

mkdir -p "${DEST_DIR}"

echo "Downloading tekton resources release: https://github.com/IBM/ibm-garage-tekton-tasks/releases/download/${VERSION}/release.yaml"
curl -Lso "${DEST_DIR}/tekton-resources.yaml" "https://github.com/IBM/ibm-garage-tekton-tasks/releases/download/${VERSION}/release.yaml"

find "${DEST_DIR}" -name "*"
