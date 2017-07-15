#!/bin/bash
# @author Michael Wiesendanger <michael.wiesendanger@gmail.com>
# @description cleanup script for docker-jira-software container.
# Does not delete other containers that where built from the Dockerfile

# abort when trying to use unset variable
set -o nounset

WD="${PWD}"

# variable setup
DOCKER_JIRA_SOFTWARE_NAME="jira-software"

# get absolute path to script and change context to script folder
SCRIPTPATH="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
cd "${SCRIPTPATH}"

# search for containers including non-running containers
docker ps -a | grep "${DOCKER_JIRA_SOFTWARE_NAME}" > /dev/null

# if a container can be found - delete it
if [ $? -eq 0 ]; then
  echo "$(date) [INFO]: Cleaning up container ${DOCKER_JIRA_SOFTWARE_NAME} ..."
  docker rm "${DOCKER_JIRA_SOFTWARE_NAME}" > /dev/null
else
  echo "$(date) [INFO]: No existing container with name: ${DOCKER_JIRA_SOFTWARE_NAME} found"
fi

cd "${WD}"
