# Description of the service

This project is an introduction to the containerization of services and the use of Docker Compose to make different containers work together in an isolated environment.

The core architecture consists of 3 different containers, each running a single service:

- **NGINX:** The only container exposed to the host machine (via the port defined by `PORT` in `.env`, default: `443`). It acts as a web server and reverse proxy, redirecting all incoming `.php` requests to the WordPress container.

- **WordPress:** A dynamic website engine (PHP-FPM) that processes PHP requests routed by NGINX and sends the response back via the internal container network.

- **MariaDB:** The relational database that stores WordPress data. It exchanges data exclusively via the internal container network and is never exposed directly to the outside.

The following bonus services are also included:

- **Redis:** An in-memory object cache running in the background. WordPress automatically stores query results and computed data in Redis through the Redis Object Cache plugin, reducing database load and speeding up page rendering. It is never exposed outside the internal network.

- **FTP:** A vsftpd server that gives you direct file access to the WordPress volume. Useful for uploading themes, plugins, or media files without going through the WordPress admin panel.

- **Adminer:** A single-file PHP database management interface, accessible through the main NGINX at `/adminer`. It allows you to browse, query, and manage the MariaDB database from your browser.

- **Webserv:** A custom HTTP server written in C++ (a companion 42 project), accessible on port `8080`. It runs in its own isolated network, completely separate from the WordPress stack.

- **Homer:** A lightweight static dashboard, proxied by NGINX at `/dashboard/`. It serves as a central hub with links to the project's services.

## ◦ Start and stop the project

Before starting the project, make sure to provide a `.env` file inside the `srcs` directory and a `secrets` directory at the root. You will find simple examples of these files (`srcs/example_env.txt` and `example_secrets/`) that you can simply modify and rename to customize and set up your own service.

You may need to have `sudo` access on your machine to launch the services, as the service will expose a port from your host machine (defined by `PORT` in `.env`, default `443`) and manage permissions and build directories on your host machine.

- **To start the project:** simply execute the command `make` at the root of the repository.

- **To stop the service:** you can use the command `make stop`. This will stop the containers but keep the data stored in the volumes.

- **To completely destroy the images and empty the volumes:** use the command `make fclean`.

## ◦ All Commands

- **`make`** (or **`make up`**): Creates the required local directories, maps your domain in `/etc/hosts` (which may require sudo), and starts all containers in the background.

- **`make build`**: Rebuilds the Docker images from scratch and starts the containers.

- **`make stop`**: Stops the running containers but keeps them, their network, and the data stored in the volumes intact.

- **`make start`**: Restarts the containers if they were previously stopped.

- **`make down`**: Stops and removes the containers and the network, but preserves your downloaded/built images and volumes.

- **`make clean`**: Executes `make down` and cleans up unused Docker system resources to free up space.

- **`make fclean`**: Completely destroys the containers, networks, **all** images, and wipes the persistent volumes. Warning: this deletes your database and website data.

- **`make re`**: Performs a complete reset by running `fclean` followed by `make` (wipes everything and restarts from zero).

## ◦ Access the website and the administration panel and bonus services

- **To access the website:** Open your usual web browser and navigate to the `DOMAIN_NAME` you set in the `.env` file (e.g., `https://lmarck.42.fr`). If `PORT` is set to a non-standard value, append it to the URL (e.g., `https://lmarck.42.fr:8443`). You can also access the website locally via `https://localhost` (or `https://localhost:<PORT>` if using a non-standard port).

- **To access the administration panel:** Navigate to `https://<DOMAIN_NAME>/wp-admin/` (e.g., `https://lmarck.42.fr/wp-admin/`). To log in, use the administrator username and password that you configured in your `secrets` directory.

- **To access the database manager (Adminer):** Navigate to `https://<DOMAIN_NAME>/adminer`. On the login form, set the server to `mariadb`, and use the database username and password from your `secrets` directory (`MYSQL_USER` from `.env` and `db_password.txt`). Select the database named after `MYSQL_DATABASE` in your `.env`.

- **To access the Homer dashboard:** Navigate to `https://<DOMAIN_NAME>/dashboard/`. The dashboard is configured via the file `srcs/requirements/bonus/homer/conf/config.yml`. You can edit that file and restart the Homer container to update the links — no image rebuild required.

- **To access the FTP server:** Connect an FTP client (e.g., FileZilla) to your `DOMAIN_NAME` or `localhost` on port `21`. Use the FTP username defined by `FTP_USER` in your `.env` file and the password stored in `secrets/ftp_password.txt`. The FTP server gives you direct access to the WordPress volume (uploads, themes, plugins).

- **To access Webserv:** Open your browser and navigate to `http://<DOMAIN_NAME>:8080` (or `http://localhost:8080`). This is a standalone HTTP server and is completely independent from the WordPress stack.

## ◦ Change the HTTPS port

The NGINX listening port is controlled by the `PORT` variable in `srcs/.env` (default: `443`). To change it:

1. Edit `srcs/.env` and set the desired port, e.g. `PORT=8443`.
2. Run `make re` to wipe everything and rebuild from scratch.

> **Important:** changing `PORT` requires a full `make re` (volumes included), because WordPress stores its site URL in the database at first install. Reusing an existing volume with a mismatched port will cause redirect loops.

## ◦ Locate and manage credentials

- **Locating Credentials:** Sensitive information (such as root passwords, user passwords, and usernames) is stored as single-line text files in the `secrets` directory at the root of the project. Public configuration details (like domain names and database names) are stored in the `srcs/.env` file.

- **Inside the containers:** Docker mounts these secrets securely into RAM under the `/run/secrets/` directory in the containers that need them (e.g., WordPress and MariaDB).

- **Managing Credentials:** If you want to change passwords or usernames *after* the initial launch, simply changing the text files is not enough, because the database and WordPress are already initialized in the persistent volumes. You will need to change the files in the `secrets` directory, then run `make fclean` to wipe the volumes, and finally `make` to initialize the services from scratch with the newly set credentials.

## ◦ Check that the services are running correctly

- **Check container status:** Run `docker ps` or `docker compose ps` to verify that all containers are running. The expected containers are: `nginx`, `wordpress`, `mariadb`, `redis`, `adminer`, `ftp`, `webserv`, and `homer`. The MariaDB container should display a `(healthy)` status if the database is ready.

- **Check container logs:** If a service isn't behaving correctly, inspect its logs by running `docker logs <container_name>` (e.g., `docker logs nginx` or `docker logs mariadb`). This will show you initialization messages and any potential errors.

- **Inside the container:** To verify configurations or connections directly from inside a container, you can open a shell securely by running `docker exec -it <container_name> sh`.

- **Inspect local persistent data (Bind Mounts):** The data for your volumes is mapped directly to your host machine's disk. You can find the database data in `/home/${USER}/data/mariadb` and the WordPress website files in `/home/${USER}/data/wordpress`. Since these are owned by the Docker containers, you will need `sudo` rights to read the files inside these directories from your host machine.

