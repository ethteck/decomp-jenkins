# Decomp Jenkins Agent Dockerfile

This repo contains the `Dockerfile` used to create a [Jenkins Agent](https://www.jenkins.io/doc/book/using/using-agents/) that contains the programs and packages used in a number of Decomp projects.

## Running the Jenkins Agent

Create a `roms` directory and add the relevant ROMs to it

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

| Game (version) | Desired filename  | SHA256 Hash                                                        |
| -------------- | ----------------- | ------------------------------------------------------------------ |
| OOT MQ Debug   | baserom_oot.z64   | `38aff72bac70f1dcd1562174aa271a8e136bfa94f585a132ce892e40c4775a6f` |
| MM US          | mm.us.rev1.z64    | `efb1365b3ae362604514c0f9a1a2d11f5dc8688ba5be660a37debf5e3be43f2b` |
| Paper Mario JP | papermario.jp.z64 | `a62c669817f87fba067248962f6737d9a8d27e78a843798d739d9d2a39d73874` |
| Paper Mario US | papermario.us.z64 | `9ec6d2a5c2fca81ab86312328779fd042b5f3b920bf65df9f6b87b376883cb5b` |
| TMC Demo JP    | tmc.demo.jp.gba   | `f2e91f7f9950ae840d8840ba324ea65527e235f19b5d2395b75d80fd5a465c4f` |
| TMC Demo US    | tmc.demo.gba      | `1babc4d5754cc03d2c59dc74d8179e1a5de600b76a93f09667a29080e1bbfb33` |
| TMC EU         | tmc.eu.gba        | `c84645731952b7677f514ae222683504066334ab2af904e64a8a84ffc1af46c6` |
| TMC JP         | tmc.jp.gba        | `16ac2572ba17e9cb2a70093d41f97ef8cff66c56417e45ea98adacdc51bb4b38` |
| TMC US         | tmc.us.gba        | `bedc74df62755f705398273de8ed3bc59be610cf55760d0b9aa277f1f5035e73` |

## Building image locally

If you wish to make changes to the `Dockerfile`, you can build your own version of the image:

```sh
docker build . -t decomp-jenkins
```
