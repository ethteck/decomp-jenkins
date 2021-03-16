# Decomp Jenkins Agent Dockerfile

1. Build the docker image:
`docker build . -t decomp`

2. Create a roms dir and add relevant roms to it
`mkdir roms` 
`cp some_roms_here roms/`

3. Run the image, mounting the roms dir. Replace `<SECRET>` and `<AGENT_NAME>` with your given secret and agent name.
```
docker run -v "$(pwd)"/roms:/usr/local/etc/roms --init decomp:latest -url https://jenkins.zelda64.dev/ <SECRET> <AGENT_NAME>
```

