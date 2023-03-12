{ pkgs, inputs, config, ... }:
let
  aikarFlags = memory: "-Xms${memory} -Xmx${memory} -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1";
in
{
  services.minecraft-servers.servers.survival = {
    enable = true;
    # Latest 1.19.3 build
    package = pkgs.inputs.nix-minecraft.paperServers.paper-1_19_3;
    jvmOpts = aikarFlags "1G";
    serverProperties = {
      server-port = 25561;
      online-mode = false;
    };
    files = {
      "ops.json".value = [
        {
          uuid = "3fc76c64-b1b2-4a95-b3cf-0d7d94db2d75";
          name = "Misterio7x";
          level = 4;
        }
      ];
      "config/paper-global.yml".value = {
        proxies.velocity = {
          enabled = true;
          online-mode = false;
          secret = "@VELOCITY_FORWARDING_SECRET@";
        };
      };
      "bukkit.yml".value = {
        settings.shutdown-message = "Servidor fechado (provavelmente reiniciando).";
      };
      "spigot.yml".value = {
        messages = {
          whitelist = "Você não está na whitelist!";
          unknown-command = "Comando desconhecido.";
          restart = "Servidor reiniciando.";
        };
      };
      "plugins/ViaVersion/config.yml".value = {
        checkforupdates = false;
      };
      "plugins/LuckPerms/config.yml".value = {
        server = "survival";
        storage-method = "mysql";
        data = {
          address = "127.0.0.1";
          database = "minecraft";
          username = "minecraft";
          password = "@DATABASE_PASSWORD@";
          table-prefix = "luckperms_";
        };
        messaging-service = "sql";
      };
    };
    symlinks = {
      "plugins/LuckPerms/initial.json.gz" =
        config.services.minecraft-servers.proxy.symlinks."plugins/luckperms/initial.json.gz";
      "plugins/ViaVersion.jar" = pkgs.fetchurl rec {
        pname = "ViaVersion";
        version = "4.5.1";
        url = "https://github.com/ViaVersion/${pname}/releases/download/${version}/${pname}-${version}.jar";
        sha256 = "sha256-hMxl5QyMxNL/vx58Jz0tJ8E/SlJ3w7sIvm8Dc70GBXQ=";
      };
      "plugins/ViaBackwards.jar" = pkgs.fetchurl rec {
        pname = "ViaBackwards";
        version = "4.5.1";
        url = "https://github.com/ViaVersion/${pname}/releases/download/${version}/${pname}-${version}.jar";
        sha256 = "sha256-wugRc0J2+oche6pI0n97+SabTOmGGDvamBItbl1neuU=";
      };
      "plugins/LuckPerms.jar" = pkgs.fetchurl rec {
        pname = "LuckPerms";
        version = "5.4.58";
        url = "https://download.luckperms.net/1467/bukkit/loader/${pname}-Bukkit-${version}.jar";
        sha256 = "sha256-roi16xTu+04ofFccuSLwFl/UqfvG0flHDq0R9/20oIM=";
      };
      "plugins/HidePLayerJoinQuit.jar" = pkgs.fetchurl rec {
        pname = "HidePLayerJoinQuit";
        version = "1.0";
        url = "https://github.com/OskarZyg/${pname}/releases/download/v${version}-full-version/${pname}-${version}-Final.jar";
        sha256 = "sha256-UjLlZb+lF0Mh3SaijNdwPM7ZdU37CHPBlERLR3LoxSU=";
      };
    };
  };
}
