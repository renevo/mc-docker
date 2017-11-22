Minecraft Curse Mod Server Docker Container
===========================================

## Vanilla Forge

[Link to Mod Pack](https://minecraft.curseforge.com/projects/vanilla-forge)

```bash
docker volume create mc-vanilla-forge-world
docker volume create mc-vanilla-forge-backups
docker build --build-arg CURSE_PROJECT=vanilla-forge --build-arg CURSE_PROJECT_VERSION=latest -t mc-vanilla-forge:latest .
docker run --name vanilla-forge -it --rm -p 25565:25565 -e EULA=TRUE -v mc-vanilla-forge-world:/home/minecraft/world -v mc-vanilla-forge-backups:/home/minecraft/backups mc-vanilla-forge:latest
```

## Age of Engineering

[Link to Mod Pack](https://minecraft.curseforge.com/projects/age-of-engineering)

```bash
docker volume create mc-aoe-world
docker volume create mc-aoe-backups
docker build --build-arg CURSE_PROJECT=age-of-engineering --build-arg CURSE_PROJECT_VERSION=latest -t mc-age-of-engineering:latest .
docker run --name age-of-engineering -it --rm -p 25565:25565 -e EULA=TRUE -e MEMORY=4G -v mc-aoe-world:/home/minecraft/world -v mc-aoe-backups:/home/minecraft/backups mc-age-of-engineering:latest
```

Server Properties
```bash
#Minecraft server properties
#Wed Nov 22 01:13:53 GMT 2017
generator-settings=
use-native-transport=true
op-permission-level=4
level-name=world
allow-flight=false
announce-player-achievements=true
server-port=25565
max-world-size=29999984
level-type=DEFAULT
level-seed=teen-u
force-gamemode=false
server-ip=
network-compression-threshold=256
max-build-height=256
spawn-npcs=true
white-list=true
spawn-animals=true
hardcore=false
snooper-enabled=false
resource-pack-sha1=
online-mode=true
resource-pack=
pvp=true
difficulty=1
enable-command-block=false
gamemode=0
player-idle-timeout=0
max-players=5
spawn-monsters=true
view-distance=10
generate-structures=true
motd=RenEvo Age of Engineering!
```