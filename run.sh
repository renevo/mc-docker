#! /bin/bash

set -e

echo "Setting initial memory to ${INIT_MEMORY:-${MEMORY}} and max to ${MAX_MEMORY:-${MEMORY}}"
JVM_OPTS="-Dlog4j.configurationFile=log4j2.xml -Xms${INIT_MEMORY:-${MEMORY}} -Xmx${MAX_MEMORY:-${MEMORY}} ${JVM_OPTS}"

EXTRA_ARGS=""

# Optional enable console
if [ ! -z "${CONSOLE}" -a "${CONSOLE}" != " " ]; then
    echo "Console enabled..."
else
    EXTRA_ARGS+=" --noconsole"
fi

EXTRA_ARGS+=" nogui"

if [ ! -e /home/minecraft/eula.txt ]; then
  if [ "$EULA" != "" ]; then
    echo "# Generated via Docker on $(date)" > eula.txt
    echo "eula=$EULA" >> eula.txt
    if [ $? != 0 ]; then
      echo "ERROR: unable to write eula to /data."
      exit 2
    fi
  else
    echo ""
    echo "Please accept the Minecraft EULA at"
    echo "  https://account.mojang.com/documents/minecraft_eula"
    echo "by adding the following immediately after 'docker run':"
    echo "  -e EULA=TRUE"
    echo ""
    exit 1
  fi
fi

# just in case they don't exist
mkdir -p /home/minecraft/logs
mkdir -p /home/minecraft/world
mkdir -p /home/minecraft/backups

echo "Starting Minecraft"
exec java $JVM_XX_OPTS $JVM_OPTS -jar /home/minecraft/forge.jar "$@" $EXTRA_ARGS