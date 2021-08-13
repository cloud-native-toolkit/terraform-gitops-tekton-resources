#!/usr/bin/env bash

GIT_REPO=$(cat git_repo)
GIT_TOKEN=$(cat git_token)

export KUBECONFIG=$(cat .kubeconfig)
NAMESPACE=$(cat .namespace)
BRANCH="main"

SERVER_NAME="default"
COMPONENT_NAME="tekton-resources"

mkdir -p .testrepo

git clone https://${GIT_TOKEN}@${GIT_REPO} .testrepo

cd .testrepo || exit 1

find . -name "*"

if [[ ! -f "argocd/2-services/cluster/${SERVER_NAME}/base/${NAMESPACE}-${COMPONENT_NAME}.yaml" ]]; then
  echo "ArgoCD config missing - argocd/2-services/cluster/${SERVER_NAME}/base/${NAMESPACE}-${COMPONENT_NAME}.yaml"
  exit 1
fi

echo "Printing argocd/2-services/cluster/${SERVER_NAME}/base/${NAMESPACE}-${COMPONENT_NAME}.yaml"
cat argocd/2-services/cluster/${SERVER_NAME}/base/${NAMESPACE}-${COMPONENT_NAME}.yaml

if [[ ! -f "payload/2-services/namespace/${NAMESPACE}/${COMPONENT_NAME}/${COMPONENT_NAME}.yaml" ]]; then
  echo "Resource yaml not found - payload/2-services/namespace/${NAMESPACE}/${COMPONENT_NAME}/${COMPONENT_NAME}.yaml"
  exit 1
fi

echo "Printing payload/2-services/namespace/${NAMESPACE}/${COMPONENT_NAME}/${COMPONENT_NAME}.yaml"
cat payload/2-services/namespace/${NAMESPACE}/${COMPONENT_NAME}/${COMPONENT_NAME}.yaml

count=0
until kubectl get namespace "${NAMESPACE}" 1> /dev/null 2> /dev/null || [[ $count -eq 20 ]]; do
  echo "Waiting for namespace: ${NAMESPACE}"
  count=$((count + 1))
  sleep 15
done

if [[ $count -eq 20 ]]; then
  echo "Timed out waiting for namespace: ${NAMESPACE}"
  exit 1
else
  echo "Found namespace: ${NAMESPACE}. Sleeping for 30 seconds to wait for everything to settle down"
  sleep 30
fi

count=0
until [[ $(kubectl get tasks -n "${NAMESPACE}" -o custom-columns=NAME:.metadata.name | grep -vc NAME) -gt 0 ]] || [[ $count -eq 20 ]]; do
  echo "Waiting for tasks in ${NAMESPACE}"
  count=$((count + 1))
  sleep 15
done

if [[ $count -eq 20 ]]; then
  echo "Timed out waiting for tasks in ${NAMESPACE}"
  kubectl get tasks -n "${NAMESPACE}"
  exit 1
fi

cd ..
rm -rf .testrepo
