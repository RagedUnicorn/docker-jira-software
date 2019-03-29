FROM ragedunicorn/openjdk:1.2.0-jdk-stable

LABEL com.ragedunicorn.maintainer="Michael Wiesendanger <michael.wiesendanger@gmail.com>"

#         __________  ___       _____       ______
#        / /  _/ __ \/   |     / ___/____  / __/ /__      ______ _________
#   __  / // // /_/ / /| |     \__ \/ __ \/ /_/ __/ | /| / / __ `/ ___/ _ \
#  / /_/ // // _, _/ ___ |    ___/ / /_/ / __/ /_ | |/ |/ / /_/ / /  /  __/
#  \____/___/_/ |_/_/  |_|   /____/\____/_/  \__/ |__/|__/\__,_/_/   \___/

# image args
ARG JIRA_USER=jira
ARG JIRA_GROUP=jira

ENV \
  JIRA_SOFTWARE_VERSION=8.0.2 \
  POSTGRESQL_VERSION=11.1-r0 \
  BASH_VERSION=4.4.19-r1 \
  NSS_VERSION=3.41-r0 \
  SU_EXEC_VERSION=0.2-r0

ENV \
  JIRA_USER="${JIRA_USER}" \
  JIRA_GROUP="${JIRA_GROUP}" \
  JIRA_HOME=/var/atlassian/jira \
  JIRA_INSTALL=/opt/atlassian/jira \
  JIRA_DATA_DIR=/var/atlassian/jira \
  JIRA_LOGS_DIR=/opt/atlassian/jira/logs

# explicitly set user/group IDs
RUN addgroup -S "${JIRA_GROUP}" -g 9999 && adduser -S -G "${JIRA_GROUP}" -u 9999 "${JIRA_USER}"

WORKDIR /home

RUN \
  set -ex; \
  apk add --no-cache \
    su-exec="${SU_EXEC_VERSION}" \
    nss="${NSS_VERSION}" \
    postgresql="${POSTGRESQL_VERSION}" \
    bash="${BASH_VERSION}" && \
  mkdir -p "${JIRA_HOME}" && \
  mkdir -p  "${JIRA_HOME}/caches/indexes" && \
  chmod -R 700 "${JIRA_HOME}" && \
  chown -R "${JIRA_USER}":"${JIRA_GROUP}" "${JIRA_HOME}" && \
  mkdir -p "${JIRA_INSTALL}/conf/Catalina" && \
  if ! wget -q "https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-${JIRA_SOFTWARE_VERSION}.tar.gz"; then \
    echo >&2 "Error: Failed to download Jira binary"; \
    exit 1; \
  fi && \
  tar zxf atlassian-jira-software-"${JIRA_SOFTWARE_VERSION}".tar.gz --directory  "${JIRA_INSTALL}" --strip-components=1 --no-same-owner && \
  chmod -R 700 "${JIRA_INSTALL}/logs" && \
  chmod -R 700 "${JIRA_INSTALL}/temp" && \
  chmod -R 700 "${JIRA_INSTALL}/work" && \
  chmod -R 700 "${JIRA_INSTALL}/conf" && \
  chown -R "${JIRA_USER}":"${JIRA_GROUP}" "${JIRA_INSTALL}/logs" && \
  chown -R "${JIRA_USER}":"${JIRA_GROUP}" "${JIRA_INSTALL}/temp" && \
  chown -R "${JIRA_USER}":"${JIRA_GROUP}" "${JIRA_INSTALL}/work" && \
  chown -R "${JIRA_USER}":"${JIRA_GROUP}" "${JIRA_INSTALL}/conf" && \
  sed --in-place "s/java version/openjdk version/g" "${JIRA_INSTALL}/bin/check-java.sh" && \
  echo -e "\njira.home=${JIRA_HOME}" >> "${JIRA_INSTALL}/atlassian-jira/WEB-INF/classes/jira-application.properties"

# add healthcheck script
COPY docker-healthcheck.sh /

# add launch script
COPY docker-entrypoint.sh /

RUN \
  chmod 755 /docker-entrypoint.sh && \
  chmod 755 /docker-healthcheck.sh

EXPOSE 8080

# Set volume mount points for installation and home directory. Changes to the
# home directory needs to be persisted as well as parts of the installation
# directory due to eg. logs.
VOLUME ["${JIRA_DATA_DIR}", "${JIRA_LOGS_DIR}"]

ENTRYPOINT ["/docker-entrypoint.sh"]
