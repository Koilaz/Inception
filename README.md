*This project has been created as part of the 42 curriculum by lmarck*

## Description

This project is an introduction to the containerization of services and the use of Docker Compose to make different containers work together in an isolated environment.

The core architecture consists of 3 different containers, each running a single service:
- **NGINX:** The only container exposed to the host machine (via the port defined by `PORT` in `.env`, default: `443`). It acts as a web server and reverse proxy, redirecting all incoming `.php` requests to the WordPress container.
- **WordPress:** A dynamic website engine (PHP-FPM) that processes PHP requests routed by NGINX and sends the response back via the internal container network.
- **MariaDB:** The relational database that stores WordPress data. It exchanges data exclusively via the internal container network and is never exposed directly to the outside.

For data persistence, two Docker volumes are created: one for the database files and one for the WordPress site files.

In addition to the mandatory services, the following bonus containers are included:
- **Redis:** An in-memory cache that stores WordPress object cache entries, reducing the number of database queries and improving page load times. It runs as a background service on the internal network and is connected to WordPress via the Redis Object Cache plugin.
- **FTP:** A vsftpd server that exposes the WordPress data volume over FTP (port 21 + passive ports 21000-21010), allowing direct file access to the website's uploads and theme files.
- **Adminer:** A lightweight PHP-based database management interface, accessible at `/adminer` through NGINX. It connects to MariaDB directly over the internal network.
- **Webserv:** A custom HTTP server written in C++ (a separate 42 project), served on port 8080. It runs in its own isolated network, completely independent from the main inception stack.
- **Homer:** A static dashboard served by its own NGINX instance and proxied by the main NGINX at `/dashboard/`. It provides a simple landing page with links to the project's services.

## Instructions

- Use the command `make` at the root of the project to build all the Docker images and launch the containers via Docker Compose.
- You must provide a `.env` file in the `srcs` directory and a `secrets` directory containing the environment variables and sensitive information, respectively. You can use `srcs/example_env.txt` and `example_secrets/` as templates. Rename them to `srcs/.env` and `secrets/`, and modify them as you wish to configure the services.
- You may need `sudo` rights on your device in order to launch the Docker daemon and map local host paths.

## Resources

https://blog.stephane-robert.info/docs/conteneurisation/
https://www.ionos.fr/digitalguide/serveur/know-how/docker-vs-virtual-machines/
https://mariadb.com/docs/server/server-management/automated-mariadb-deployment-and-administration/docker-and-mariadb/creating-a-custom-container-image
https://wp-cli.org/fr/

AI was used for various parts of this project, ChatGPT and Gemini Pro for:
- Search of information and documentation about containers, Docker, MariaDB and WordPress setup.
- Finding leads about the root of bugs.
- Good practices, advice and suggestions for possible improvements.
- Quickly completing redundant and simple tasks such as path modifications after directory structure changes.
- Typo corrections and proofreading of documentation files.

## Virtual Machine vs Docker

Strictly speaking, a Virtual Machine should be compared to a container (concept vs concept), while Docker is just one tool used to manage containers.

A Virtual Machine virtualizes an entire computer system, including its own complete operating system and kernel, using a hypervisor. This provides strong isolation but comes with higher resource usage (CPU, RAM, Storage) and much slower startup times.
Containers share the host system's kernel and only include the application and its required dependencies. Containers are lightweight, start in seconds, and are more efficient in terms of resource usage.

## Secrets vs Environment Variables

Environment Variables are used to configure and customize the project (like domain names or debug modes) and can generally be visible in your configuration files.
Secrets, on the other hand, are strictly for sensitive information (passwords, API keys). They should never be shared publicly or pushed to a repository. In Docker, secrets are mounted securely into the container's RAM (usually under `/run/secrets/`) and are never written to the container's disk image.

## Docker Network vs Host Network

Containers communicate together internally via a Docker network, which is completely isolated from the host machine's physical network. Containers within the same Docker network can talk to each other using their container names as DNS hostnames.
To communicate with the host machine or the outside internet, a container must explicitly expose and map a port using Docker (e.g., `${PORT}:${PORT}`), effectively punching a controlled hole through the isolation.

## Docker Volumes vs Bind Mounts

- **Docker Volumes:** These are managed entirely by Docker and are stored in a hidden, secure directory on the host machine (usually `/var/lib/docker/volumes`). They are the preferred way to persist data because they are completely abstracted from the host's operating system, easier to back up, and work seamlessly across different platforms.

- **Bind Mounts:** These map a specific, exact file path from your host machine (like `/home/user/data`) directly into a path inside the container. They tie the container directly to the host's filesystem structure. Bind mounts are great for development (so you can edit code on the host and see changes instantly in the container), but can cause permission issues and are less portable than Volumes.
