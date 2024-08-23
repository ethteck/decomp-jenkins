# Decomp Jenkins Agent Dockerfile

This repo contains the `Dockerfile` used to create a [Jenkins Agent](https://www.jenkins.io/doc/book/using/using-agents/) that contains the programs and packages used in a number of Decomp projects.

## Running the Jenkins Agent

Create a `roms` directory and add the relevant ROMs to it:

```sh
mkdir -p roms
cp some_roms_here roms/
```

Spin up a Docker container, mounting in the `roms` directory that you just created

**NOTE:** Replace `MY_SECRET` and `MY_AGENT_NAME` with your given secret and agent name.

```sh
docker run \
    -v "$(pwd)"/roms:/usr/local/etc/roms \
    --init ghcr.io/ethteck/decomp-jenkins:latest \
    -url https://jenkins.deco.mp/ MY_SECRET MY_AGENT_NAME
```

**NOTE:** You can pass the `--detach` argument to `docker run` to run the container in the background.

## Supported ROMs

Below are the supported ROMs and their filenames. They should be placed in your `roms` directory.

| Game (version)   | Desired filename     | SHA1 Hash                                  |
| ---------------- | -------------------- | ------------------------------------------ |
| OOT N64 1.0 US   | oot-ntsc-1.0-us.z64  | `ad69c91157f6705e8ab06c79fe08aad47bb57ba7` |
| OOT N64 1.1 US   | oot-ntsc-1.1-us.z64  | `d3ecb253776cd847a5aa63d859d8c89a2f37b364` |
| OOT N64 1.2 US   | oot-ntsc-1.2-us.z64  | `41b3bdc48d98c48529219919015a1af22f5057c2` |
| OOT N64 1.0 PAL  | oot-pal-1.0.z64      | `328a1f1beba30ce5e178f031662019eb32c5f3b5` |
| OOT N64 1.1 PAL  | oot-pal-1.1.z64      | `cfbb98d392e4a9d39da8285d10cbef3974c2f012` |
| OOT GC JP        | oot-gc-jp.z64        | `0769c84615422d60f16925cd859593cdfa597f84` |
| OOT GC JP MQ     | oot-gc-jp-mq.z64     | `dd14e143c4275861fe93ea79d0c02e36ae8c6c2f` |
| OOT GC JP CE     | oot-gc-jp-ce.z64     | `2ce2d1a9f0534c9cd9fa04ea5317b80da21e5e73` |
| OOT GC US        | oot-gc-us.z64        | `b82710ba2bd3b4c6ee8aa1a7e9acf787dfc72e9b` |
| OOT GC US MQ     | oot-gc-us-mq.z64     | `8b5d13aac69bfbf989861cfdc50b1d840945fc1d` |
| OOT GC PAL       | oot-gc-eu.z64        | `0227d7c0074f2d0ac935631990da8ec5914597b4` |
| OOT GC PAL MQ    | oot-gc-eu-mq.z64     | `f46239439f59a2a594ef83cf68ef65043b1bffe2` |
| OOT MQ Debug     | oot-gc-eu-mq-dbg.z64 | `bdd50f5e84d6fe2683dac92de3fd0485c06c1b51` |
| MM US            | mm.us.rev1.z64       | `d6133ace5afaa0882cf214cf88daba39e266c078` |
| Paper Mario JP   | papermario.jp.z64    | `b9cca3ff260b9ff427d981626b82f96de73586d3` |
| Paper Mario US   | papermario.us.z64    | `3837f44cda784b466c9a2d99df70d77c322b97a0` |
| Paper Mario PAL  | papermario.us.z64    | `2111d39265a317414d359e35a7d971c4dfa5f9e1` |
| Paper Mario iQue | papermario.cn.z64    | `5c724685085eba796537573dd6f84aaddedc8582` |
| TMC Demo JP      | tmc.demo.jp.gba      | `9cdb56fa79bba13158b81925c1f3641251326412` |
| TMC Demo US      | tmc.demo.gba         | `63fcad218f9047b6a9edbb68c98bd0dec322d7a1` |
| TMC EU           | tmc.eu.gba           | `cff199b36ff173fb6faf152653d1bccf87c26fb7` |
| TMC JP           | tmc.jp.gba           | `6c5404a1effb17f481f352181d0f1c61a2765c5d` |
| TMC US           | tmc.us.gba           | `b4bd50e4131b027c334547b4524e2dbbd4227130` |
| Animal Forest JP | af.jp.z64            | `e106dff7146f72415337c96deb14f630e1580efb` |
| Pokemon Snap US  | pokemonsnap.us.z64   | `edc7c49cc568c045fe48be0d18011c30f393cbaf` |

## Building image locally

If you wish to make changes to the `Dockerfile`, you can build your own version of the image:

```sh
docker build . -t decomp-jenkins
```
