#!/bin/sh
# @author Michael Wiesendanger <michael.wiesendanger@gmail.com>
# @description launch script for jira

# abort when trying to use unset variable
set -o nounset

/opt/atlassian/jira/bin/catalina.sh run