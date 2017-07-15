#!/bin/bash
# @author Michael Wiesendanger <michael.wiesendanger@gmail.com>
# @description run script for docker-jira-software container

# abort when trying to use unset variable
set -o nounset

WD="${PWD}"

# variable setup
DOCKER_JIRA_SOFTWARE_TAG="ragedunicorn/jira-software"
DOCKER_JIRA_SOFTWARE_NAME="jira-software"
DOCKER_JIRA_SOFTWARE_DATA_VOLUME="jira_data"
DOCKER_JIRA_SOFTWARE_LOGS_VOLUME="jira_logs"
DOCKER_JIRA_SOFTWARE_ID=0

# get absolute path to script and change context to script folder
SCRIPTPATH="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
cd "${SCRIPTPATH}"

# check if there is already an image created
docker inspect ${DOCKER_JIRA_SOFTWARE_NAME} &> /dev/null

if [ $? -eq 0 ]; then
  # start container
  docker start "${DOCKER_JIRA_SOFTWARE_NAME}"
else
  ## run image:
  # -v mount volume
  # -p expose port
  # -d run in detached mode
  # --name define a name for the container(optional)
  DOCKER_JIRA_SOFTWARE_ID=$(docker run \
  -v ${DOCKER_JIRA_SOFTWARE_DATA_VOLUME}:/var/atlassian/jira \
  -v ${DOCKER_JIRA_SOFTWARE_LOGS_VOLUME}:/opt/atlassian/jira/logs \
  -p 8080:8080 \
  -d \
  --name "${DOCKER_JIRA_SOFTWARE_NAME}" "${DOCKER_JIRA_SOFTWARE_TAG}")
fi

if [ $? -eq 0 ]; then
  # print some info about containers
  echo "$(date) [INFO]: Container info:"
  docker inspect -f '{{ .Config.Hostname }} {{ .Name }} {{ .Config.Image }} {{ .NetworkSettings.IPAddress }}' ${DOCKER_JIRA_SOFTWARE_NAME}
else
  echo "$(date) [ERROR]: Failed to start container - ${DOCKER_JIRA_SOFTWARE_NAME}"
fi

cd "${WD}"
