#!/bin/bash
# @author Michael Wiesendanger <michael.wiesendanger@gmail.com>
# @description stop script for docker-jira-software container

# abort when trying to use unset variable
set -o nounset

WD="${PWD}"

# variable setup
DOCKER_JIRA_SOFTWARE_NAME="jira-software"

# get absolute path to script and change context to script folder
SCRIPTPATH="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
cd "${SCRIPTPATH}"

# search running container
docker ps | grep "${DOCKER_JIRA_SOFTWARE_NAME}" > /dev/null

# if container is running - stop it
if [ $? -eq 0 ]; then
  echo "$(date) [INFO]: Stopping container "${DOCKER_JIRA_SOFTWARE_NAME}" ..."
  docker stop "${DOCKER_JIRA_SOFTWARE_NAME}" > /dev/null
else
  echo "$(date) [INFO]: No running container with name: ${DOCKER_JIRA_SOFTWARE_NAME} found"
fi

cd "${WD}"
