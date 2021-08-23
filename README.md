# Decomp Jenkins Agent Dockerfile

1. Obtain an agent name and agent secret from your network administrator.

2. Install the jenkins user agent.
```bash
./install.sh <agent_name> <roms_path> <agent_secret>
```

3. If you wish to run the agent manually outside of systemctl, you can run:
```bash
sudo systemctl stop decomp-jenkins
sudo su - <agent_name> -c 'docker run -v $HOME/decomp-jenkins/roms:/usr/local/etc/roms --init decomp:latest -url https://jenkins.deco.mp/ $(cat $HOME/decomp-jenkins/jenkins-secret) $USER'
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
| TMC EU | tmc.eu.gba | `c84645731952b7677f514ae222683504066334ab2af904e64a8a84ffc1af46c6` |
| TMC JP | tmc.jp.gba | `16ac2572ba17e9cb2a70093d41f97ef8cff66c56417e45ea98adacdc51bb4b38` |
| TMC US | tmc.us.gba | `bedc74df62755f705398273de8ed3bc59be610cf55760d0b9aa277f1f5035e73` |
