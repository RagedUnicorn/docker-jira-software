FROM ragedunicorn/openjdk:1.0.1-jdk-stable

LABEL com.ragedunicorn.maintainer="Michael Wiesendanger <michael.wiesendanger@gmail.com>"

#         __________  ___       _____       ______
#        / /  _/ __ \/   |     / ___/____  / __/ /__      ______ _________
#   __  / // // /_/ / /| |     \__ \/ __ \/ /_/ __/ | /| / / __ `/ ___/ _ \
#  / /_/ // // _, _/ ___ |    ___/ / /_/ / __/ /_ | |/ |/ / /_/ / /  /  __/
#  \____/___/_/ |_/_/  |_|   /____/\____/_/  \__/ |__/|__/\__,_/_/   \___/

ENV \
  JIRA_SOFTWARE_VERSION=7.4.0 \
  SU_EXEC_VERSION=0.2-r0 \
  CURL_VERSION=7.57.0-r0 \
  TAR_VERSION=1.29-r1

ENV \
  JIRA_USER=jira \
  JIRA_GROUP=jira \
  JIRA_HOME=/var/atlassian/jira \
  JIRA_INSTALL=/opt/atlassian/jira


# explicitly set user/group IDs
RUN addgroup -S "${JIRA_GROUP}" -g 9999 && adduser -S -G "${JIRA_GROUP}" -u 9999 "${JIRA_USER}"

RUN \
  set -ex; \
  apk add --no-cache su-exec="${SU_EXEC_VERSION}"

RUN \
  set -ex; \
  apk add --no-cache \
    tar="${TAR_VERSION}" \
    curl="${CURL_VERSION}"; \
  mkdir -p "${JIRA_HOME}"; \
  mkdir -p  "${JIRA_HOME}/caches/indexes"; \
  chmod -R 700 "${JIRA_HOME}"; \
  chown -R "${JIRA_USER}":"${JIRA_GROUP}" "${JIRA_HOME}"; \
  mkdir -p "${JIRA_INSTALL}/conf/Catalina"; \
  curl --location "https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-${JIRA_SOFTWARE_VERSION}.tar.gz" \
    | tar -xz --directory "${JIRA_INSTALL}" --strip-components=1 --no-same-owner; \
  curl --location "https://jdbc.postgresql.org/download/postgresql-9.4.1212.jar" \
    -o "${JIRA_INSTALL}/lib/postgresql-9.4.1212.jar"; \
  chmod -R 700 "${JIRA_INSTALL}/logs"; \
  chmod -R 700 "${JIRA_INSTALL}/temp"; \
  chmod -R 700 "${JIRA_INSTALL}/work"; \
  chmod -R 700 "${JIRA_INSTALL}/conf"; \
  chown -R "${JIRA_USER}":"${JIRA_GROUP}" "${JIRA_INSTALL}/logs"; \
  chown -R "${JIRA_USER}":"${JIRA_GROUP}" "${JIRA_INSTALL}/temp"; \
  chown -R "${JIRA_USER}":"${JIRA_GROUP}" "${JIRA_INSTALL}/work"; \
  chown -R "${JIRA_USER}":"${JIRA_GROUP}" "${JIRA_INSTALL}/conf"; \
  sed --in-place "s/java version/openjdk version/g" "${JIRA_INSTALL}/bin/check-java.sh"; \
  echo -e "\njira.home=${JIRA_HOME}" >> "${JIRA_INSTALL}/atlassian-jira/WEB-INF/classes/jira-application.properties"

# add launch script
COPY docker-entrypoint.sh /

RUN \
  chmod 755 docker-entrypoint.sh

EXPOSE 8080

# Set volume mount points for installation and home directory. Changes to the
# home directory needs to be persisted as well as parts of the installation
# directory due to eg. logs.
VOLUME ["/var/atlassian/jira", "/opt/atlassian/jira/logs"]

ENTRYPOINT ["/docker-entrypoint.sh"]
