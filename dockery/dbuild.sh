#!/bin/bash
# @author Michael Wiesendanger <michael.wiesendanger@gmail.com>
# @description build script for docker-jira-software container

set -euo pipefail

WD="${PWD}"

# variable setup
DOCKER_JIRA_SOFTWARE_TAG="ragedunicorn/jira-software"
DOCKER_JIRA_SOFTWARE_NAME="jira-software"
DOCKER_JIRA_SOFTWARE_DATA_VOLUME="jira_data"
DOCKER_JIRA_SOFTWARE_LOGS_VOLUME="jira_logs"

# get absolute path to script and change context to script folder
SCRIPTPATH="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
cd "${SCRIPTPATH}"

echo "$(date) [INFO]: Building container: ${DOCKER_JIRA_SOFTWARE_NAME}"

# build jira container
docker build -t "${DOCKER_JIRA_SOFTWARE_TAG}" ../

# check if jira data volume already exists
docker volume inspect "${DOCKER_JIRA_SOFTWARE_DATA_VOLUME}" > /dev/null 2>&1

if [ $? -eq 0 ]; then
  echo "$(date) [INFO]: Reusing existing volume: ${DOCKER_JIRA_SOFTWARE_DATA_VOLUME}"
else
  echo "$(date) [INFO]: Creating new volume: ${DOCKER_JIRA_SOFTWARE_DATA_VOLUME}"
  docker volume create --name "${DOCKER_JIRA_SOFTWARE_DATA_VOLUME}" > /dev/null
fi

# check if jira logs volume already exists
docker volume inspect "${DOCKER_JIRA_SOFTWARE_LOGS_VOLUME}" > /dev/null 2>&1

if [ $? -eq 0 ]; then
  echo "$(date) [INFO]: Reusing existing volume: ${DOCKER_JIRA_SOFTWARE_LOGS_VOLUME}"
else
  echo "$(date) [INFO]: Creating new volume: ${DOCKER_JIRA_SOFTWARE_LOGS_VOLUME}"
  docker volume create --name "${DOCKER_JIRA_SOFTWARE_LOGS_VOLUME}" > /dev/null
fi

cd "${WD}"
