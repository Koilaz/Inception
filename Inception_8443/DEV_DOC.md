# Developer Documentation

This document outlines the setup, build, and management processes for the Inception project, including how data is stored and persists.

## 1. Setting Up the Environment from Scratch

### Prerequisites
- Docker and Docker Compose must be installed on the system.
- The make utility is required.
- Sudo access is needed so the setup can modify your hosts file to point your domain to the local loopback.

### Configuration Files and Secrets
Before building or launching the project, the environment variables and secrets must be configured.

1. Environment Variables:
	Copy the provided example_env.txt to a file named .env inside the srcs directory. Ensure DOMAIN_NAME is defined appropriately (for example, DOMAIN_NAME=lmarck.42.fr), as the setup relies on this value to configure your hosts system.

2. Secrets:
	The project uses file-based secrets to safely handle passwords and credentials without hardcoding them into the images.
	Copy the example_secrets directory to a new folder named secrets. Ensure this new folder contains the required plain-text password files: db_password.txt, db_root_password.txt, wp_admin_user.txt, wp_admin_password.txt, and wp_normal_password.txt.
	Important: Make sure to modify the contents of these secret files with your own complex, secure passwords. Never share them publicly.

## 2. Building and Launching the Project

The project is orchestrated using the provided Makefile, which handles directory creation, host configurations, and Docker Compose commands.

- To build and start from scratch:
	Run the command: make build
	This automatically adds your domain to your hosts file, creates the necessary folders for Docker volumes on your host machine, builds the images, and launches the containers in the background.

- To start the project if already built:
	Run the command: make up

## 3. Managing Containers and Volumes

You can use standard make commands for everyday container management:

- make stop: Stops the currently running containers without removing them.
- make start: Starts stopped containers.
- make down or make clean: Stops and removes containers, networks, and base resources.
- make fclean: Performs a total wipe of the Docker resources for this project. It removes configurations, images, and wipes out mapped volumes. Use with caution as this deletes local configurations.
- make re: Executes a full clean followed by a fresh restart.

For lower-level management, standard Docker commands like docker ps, docker logs, and docker exec can still be fully utilized.

## 4. Project Data Storage and Persistence

Data in this project is strictly isolated from the ephemeral Docker container instances. If a container crashes, is stopped, or is removed, your state is completely preserved across restarts via local bind mount volumes.

### Where is the data stored locally?
Volume paths are defined as absolute paths within your local user's home folder.

Specifically:
- WordPress Data:
	Stored locally at the absolute path: /home/${USER}/data/wordpress
	It is mounted to the HTML directory in both the nginx and wordpress containers and contains core WordPress files, themes, plugins, and uploaded user media.

- MariaDB Data:
	Stored locally at the absolute path: /home/${USER}/data/mariadb
	It is mounted to the MySQL library directory in the mariadb container and contains the actual database records, user tables, and SQL dumps.

The setup target automatically ensures these paths exist prior to startup. Because these volumes are mapped as local bound volumes, changes made by the containers go directly to your host's disk. As long as you don't manually delete these data folders on your host machine, the data persists permanently.

### How to modify the local storage path
If you wish to store the project data in a different location on your host machine, you will need to update two files:

1. Update the Makefile:
	Modify the dir rule to create your new desired directories (for example, replacing /home/$(USER)/data/).

2. Update the Docker Compose file:
	In the srcs/docker-compose.yml file, scroll down to the volumes block at the bottom.
	Modify the device value under driver_opts for both wp_data and db_data to match the new absolute paths you set in the Makefile.
