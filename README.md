# code-server-snort3

This repository contains a sample [code-server](https://coder.com/docs/code-server/latest) development environment for [Snort3](https://www.github.com/snort3). The environment also has the Docker Daemon (Docker in Docker) available.

Feel free to customize as needed, additions, installed APT packages, cloned repositories, etc for your own needs.

## Requirements

[Docker](https://docs.docker.com/engine/install/) (with [Compose Plugin](https://docs.docker.com/compose/install/)]

## Usage:

Clone the repository and start the Docker Compose service

```
git clone https://github.com/datmanslo/code-server-snort3.git
cd code-server-snort3
docker compose up # or docker-compose up if running the binary directly
```

After some time the generated password for the code-server instance will be printed in the terminal. Copy/save this password.

Launch a web browser and point to http://localhost:18080

Login with the paswword from the terminal output earlier.

## Enjoy
