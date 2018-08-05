#!/bin/sh
# @author Michael Wiesendanger <michael.wiesendanger@gmail.com>
# @description launch script for jira

set -euo pipefail

exec su-exec ${JIRA_USER} /opt/atlassian/jira/bin/catalina.sh run
