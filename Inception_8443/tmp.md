# Developer Documentation (DEV_DOC)

This document provides all necessary instructions for a developer to set up, build, manage, and understand the internal structure of the Inception project environment.

## 1. Setting Up the Environment from Scratch

### Prerequisites
- **Docker** and **Docker Compose** installed on your system.
- `make` utility.
- `sudo` access (the `Makefile` modifies `/etc/hosts` to point your domain to local loopback).

### Configuration Files and Secrets
Before you can build or launch the project, you must set up the environment variables and Docker secrets.

1. **Environment Variables (`.env`)**:
   - Copy the provided example to the required location for Docker Compose.
   ```bash
   cp srcs/example_env.txt srcs/.env
   ```
   - Make sure `DOMAIN_NAME` is defined in `srcs/.env` (e.g., `DOMAIN_NAME=lmarck.42.fr`), as the `Makefile` reads this value to configure `/etc/hosts`.

2. **Secrets**:
   - The application relies on file-based Docker Secrets to safely pass database passwords and WordPress credentials without hardcoding them in images.
   - Copy the example secrets directory or create the `secrets/` folders and populate the required text files:
   ```bash
   cp -r example_secrets/ secrets/
   ```
   - Ensure the following files exist and contain the appropriate plain-text credentials:
         - `secrets/db_password.txt`
         - `secrets/db_root_password.txt`
         - `secrets/wp_admin_user.txt`
         - `secrets/wp_admin_password.txt`
         - `secrets/wp_normal_password.txt`

## 2. Building and Launching the Project

The project is easily orchestrated using the provided `Makefile` which handles directories, host configurations, and executing Docker Compose commands.

- **To build and start the project from scratch:**
  ```bash
  make build
  ```
  This command will:
  1. Add your `${DOMAIN_NAME}` to `/etc/hosts` if it isn't already there.
  2. Create the necessary host directories for Docker volumes.
  3. Run `docker compose up -d --build` to build images and launch containers in the background.

- **To start the project (if already built):**
  ```bash
  make up
  ```

## 3. Managing Containers and Volumes

You can use the `Makefile` for standard everyday commands instead of writing out long `docker compose` lines:

- `make stop` : Stops the currently running containers without removing them.
- `make start` : Starts stopped containers.
- `make down` : Stops and removes containers, networks, and base resources.
- `make clean` : Alias for `make down`.
- `make fclean` : Performs a total wipe of the Docker resources for this project, removing configurations, removing all associated images, and wiping out mapped volumes (`docker compose down -v --rmi all`). *(Note: Use with caution as this deletes local configurations in Docker!)*
- `make re` : Runs `make fclean` followed by `make all` (a completely fresh restart).

For lower-level management, you can still use:
- `docker ps` to view running containers.
- `docker logs <container_name>` to view standard output of services.
- `docker exec -it <container_name> /bin/bash` to enter a container.

## 4. Project Data Storage and Persistence

Data in this project is strictly isolated from ephemeral Docker container instances. If a container crashes, is stopped, or is removed, your state is completely preserved across restarts via **Local Bind Mount Volumes**.

### Where is the data stored?
Volume paths are defined in the `/home/${USER}/data` directory on the host machine.

Specifically:
- **WordPress Data**: Stored in `/home/${USER}/data/wordpress`.
  - Mounted to `/var/www/html` in both the `nginx` and `wordpress` containers.
  - Contains core WP files, themes, plugins, and uploaded user media.

- **MariaDB Data**: Stored in `/home/${USER}/data/mariadb`.
  - Mounted to `/var/lib/mysql` in the `mariadb` container.
  - Contains the actual database records, user tables, and SQL dumps.

*(Note: The `make dir` target automatically ensures these paths exist prior to startup.)*

Because these volumes are mapped as `local` bound volumes (`o: bind`), changes made by the containers go directly to your host's disk. As long as you don't use `sudo rm -rf /home/${USER}/data/` on the host machine, data persists permanently.


