# Decomp Jenkins Agent Dockerfile

1. Build the docker image:
`docker build . -t decomp`

2. Create a roms dir and add relevant roms to it
`mkdir roms` 
`cp some_roms_here roms/`

3. Run the image, mounting the roms dir. Replace `<SECRET>` and `<AGENT_NAME>` with your given secret and agent name.
```
docker run -v "$(pwd)"/roms:/usr/local/etc/roms --init decomp:latest -url https://jenkins.deco.mp/ <SECRET> <AGENT_NAME>
```

## Supported Roms
Below are the supported roms and the filenames they should be in your roms directory for our Jenkins platform

| Game / version | Desired filename | sha256 |
| ------------- | ------------- | ------------- |
| OOT MQ Debug | baserom_oot.z64 | `38aff72bac70f1dcd1562174aa271a8e136bfa94f585a132ce892e40c4775a6f` |
| MM US | mm.us.rev1.z64 | `efb1365b3ae362604514c0f9a1a2d11f5dc8688ba5be660a37debf5e3be43f2b` |
| Paper Mario JP | papermario.jp.z64 | `a62c669817f87fba067248962f6737d9a8d27e78a843798d739d9d2a39d73874` |
| Paper Mario US | papermario.us.z64 | `9ec6d2a5c2fca81ab86312328779fd042b5f3b920bf65df9f6b87b376883cb5b` |
| TMC Demo  | tmc.demo.gba | `1babc4d5754cc03d2c59dc74d8179e1a5de600b76a93f09667a29080e1bbfb33` |
| TMC Demo (JP) | tmc.demo.jp.gba | `f2e91f7f9950ae840d8840ba324ea65527e235f19b5d2395b75d80fd5a465c4f` |
| TMC EU | tmc.eu.gba | `c84645731952b7677f514ae222683504066334ab2af904e64a8a84ffc1af46c6` |
| TMC JP | tmc.jp.gba | `16ac2572ba17e9cb2a70093d41f97ef8cff66c56417e45ea98adacdc51bb4b38` |
| TMC US | tmc.us.gba | `bedc74df62755f705398273de8ed3bc59be610cf55760d0b9aa277f1f5035e73` |
