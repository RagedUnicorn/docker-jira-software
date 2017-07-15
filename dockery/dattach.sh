#!/bin/bash
# @author Michael Wiesendanger <michael.wiesendanger@gmail.com>
# @description script for attaching to running docker-jira-software container

# abort when trying to use unset variable
set -o nounset

WD="${PWD}"

# variable setup
DOCKER_JIRA_SOFTWARE_NAME="jira-software"

# get absolute path to script and change context to script folder
SCRIPTPATH="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
cd "${SCRIPTPATH}"

echo "$(date) [INFO]: attaching to container ${DOCKER_JIRA_SOFTWARE_NAME}. To detach from the container use Ctrl-p Ctrl-q"
# attach to container
docker attach "${DOCKER_JIRA_SOFTWARE_NAME}"

cd "${WD}"
