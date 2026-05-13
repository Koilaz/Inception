This project has been created as part of the 42 curriculum by lmarck

This project has been created as part of the 42 curriculum by lmarck

	Description

This project is an introduction to the containerization of services and the use of Docker Compose to make different containers work together in an isolated environment.
The core architecture consists of 3 different containers, each running a single service:
- NGINX: The only container exposed to the host machine (via port 8443). It acts as a web server and reverse proxy, redirecting all incoming `.php` requests to the WordPress container.
- WordPress: A dynamic website engine (PHP-FPM) that processes PHP requests routed by NGINX and sends the response back via the internal container network.
- MariaDB: The relational database that stores WordPress data. It exchanges data exclusively via the internal container network and is never exposed directly to the outside.

For data persistence, two Docker volumes are created: one for the database files and one for the WordPress site files.

	Instructions

- Use the command `make` at the root of the project to build all the Docker images and launch the containers via Docker Compose.

	Requirements

- You must provide a `.env` file in the `srcs` directory and a `secrets` directory containing the environment variables and sensitive information, respectively. You can use `srcs/example_env.txt` and `example_secrets/` as templates. Rename them to `srcs/.env` and `secrets/`, and modify them as you wish to configure the services.
- You may need `sudo` rights on your device in order to launch the Docker daemon and map local host paths.

	Ressources

https://blog.stephane-robert.info/docs/conteneurisation/
https://www.ionos.fr/digitalguide/serveur/know-how/docker-vs-virtual-machines/
https://mariadb.com/docs/server/server-management/automated-mariadb-deployment-and-administration/docker-and-mariadb/creating-a-custom-container-image
https://wp-cli.org/fr/

AI was use for various part of this project, ChatGPT and Gemini Pro for
-Search of information and documentation about container, docker, mariadb and wordpress setup.
-Finding lead about the root of buggs
-Good practices advices and suggestions of possible improovement
-For fastly make redundant and simple task such as modification on path after a change in the directory structures etc..
-Typo correcctions and rereading of documentations files.


*Virtual Machine Vs Docker*

Strictly speaking, a Virtual Machine should be compared to a container (concept vs concept), while Docker is just one tool used to manage containers.

A Virtual Machine virtualizes an entire computer system, including its own complete operating system and kernel, using a hypervisor. This provides strong isolation but comes with higher resource usage (CPU, RAM, Storage) and much slower startup times.
Containers share the host system’s kernel and only include the application and its required dependencies. Containers are lightweight, start in seconds, and are more efficient in terms of resource usage.

*Secret vs Environment Variables*

Environment Variables are used to configure and customize the project (like domain names or debug modes) and can generally be visible in your configuration files.
Secrets, on the other hand, are strictly for sensitive information (passwords, API keys). They should never be shared publicly or pushed to a repository. In Docker, secrets are mounted securely into the container's RAM (usually under `/run/secrets/`) and are never written to the container's disk image.

*Docker Network vs Host Network*

Containers communicate together internaly via a Docker network, which is completely isolated from the host machine's physical network. Containers within the same Docker network can talk to each other using their container names as DNS hostnames.
To communicate with the host machine or the outside internet, a container must explicitly expose and map a port using Docker (e.g., `8443:443`), effectively punching a controlled hole through the isolation.

*Docker Volume vs Bind Mounts*

- **Docker Volumes:** These are managed entirely by Docker and are stored in a hidden, secure directory on the host machine (usually `/var/lib/docker/volumes`). They are the preferred way to persist data because they are completely abstracted from the host's operating system, easier to back up, and work seamlessly across different platforms.

- **Bind Mounts:** These map a specific, exact file path from your host machine (like `/home/user/data`) directly into a path inside the container. They tie the container directly to the host's filesystem structure. Bind mounts are great for development (so you can edit code on the host and see changes instantly in the container), but can cause permission issues and are less portable than Volumes.
