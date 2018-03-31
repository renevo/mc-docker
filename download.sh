#! /bin/bash

set -e

wget -nv https://minecraft.curseforge.com/projects/${CURSE_PROJECT}/files/${CURSE_PROJECT_VERSION} -O /home/minecraft/pack/${CURSE_PROJECT}.zip --no-check-certificate

unzip /home/minecraft/pack/${CURSE_PROJECT}.zip -d /home/minecraft/pack/${CURSE_PROJECT}/
cp -r /home/minecraft/pack/${CURSE_PROJECT}/overrides/* /home/minecraft/

MANIFEST=$(cat /home/minecraft/pack/${CURSE_PROJECT}/manifest.json)
MC_VERSION=$(echo ${MANIFEST} | jq -r '.minecraft.version')
FORGE_VERSION=$(echo ${MANIFEST} | jq -r '.minecraft.modLoaders[0].id')
FORGE_VERSION="${MC_VERSION}-${FORGE_VERSION#*-}"
MOD_NAME=$(echo ${MANIFEST} | jq -r '.name')
MOD_VERSION=$(echo ${MANIFEST} | jq -r '.version')
MOD_AUTHOR=$(echo ${MANIFEST} | jq -r '.author')

wget -nv http://files.minecraftforge.net/maven/net/minecraftforge/forge/${FORGE_VERSION}/forge-${FORGE_VERSION}-installer.jar -O /home/minecraft/forge-installer.jar

FILES=$(echo ${MANIFEST} | jq -r '.files[] | "/projects/" + (.projectID|tostring) + "/files/" + (.fileID|tostring) + "/download"')

mkdir -p /home/minecraft/mods

FAILS=""

for FILE in ${FILES[@]}
do
    wget -nv https://minecraft.curseforge.com${FILE} --content-disposition -P /home/minecraft/mods/ --no-check-certificate || WGET_EXIT=$? && true
    if [[ "${WGET_EXIT}" -gt "0" ]]; then
        FAILS="${FAILS}https://minecraft.curseforge.com${FILE}\n"
    fi
    WGET_EXIT=0
done

echo "Installing forge"
# installer actually takes care of getting the minecraft version for us - how nice
java -jar /home/minecraft/forge-installer.jar --installServer
mv /home/minecraft/forge-${FORGE_VERSION}-universal.jar /home/minecraft/forge.jar

ls -al /home/minecraft

if [ ! -z "${FAILS}" -a "${FAILS}" != " " ]; then
    echo -e "Failed to download the following mods: ${FAILS}"
fi

echo "Mod ${MOD_NAME} version ${MOD_VERSION} by ${MOD_AUTHOR} downloaded for Minecraft Version ${MC_VERSION} using Forge ${FORGE_VERSION}"