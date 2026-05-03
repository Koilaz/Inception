# Description of the service

This project is an introduction to the containerization of services and the use of Docker Compose to make different containers work together in an isolated environment.

The core architecture consists of 3 different containers, each running a single service:

- **NGINX:** The only container exposed to the host machine (via port `443`). It acts as a web server and reverse proxy, redirecting all incoming `.php` requests to the WordPress container.

- **WordPress:** A dynamic website engine (PHP-FPM) that processes PHP requests routed by NGINX and sends the response back via the internal container network.

- **MariaDB:** The relational database that stores WordPress data. It exchanges data exclusively via the internal container network and is never exposed directly to the outside.

## ◦ Start and stop the project

Before starting the project, make sure to provide a `.env` file and a `secrets` directory. You will find simple examples of these files that you can simply modify and rename to customize and set up your own service.

You may need to have `sudo` access on your machine to launch the services, as the service will expose a port from your host machine (443) and manage permissions and build directories on your host machine.

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

## ◦ Access the website and the administration panel.

- **To access the website:** Open your usual web browser and navigate to the `DOMAIN_NAME` you set in the `.env` file (e.g., `https://lmarck.42.fr`). Because NGINX acts as a reverse proxy, you can also access the website locally via `https://localhost:443` (or simply `https://localhost`).

- **To access the administration panel:** Navigate to `https://<DOMAIN_NAME>/wp-admin/` (e.g., `https://lmarck.42.fr/wp-admin/`). To log in, use the administrator username and password that you configured in your `secrets` directory.

## ◦ Locate and manage credentials

- **Locating Credentials:** Sensitive information (such as root passwords, user passwords, and usernames) is stored as single-line text files in the `secrets` directory at the root of the project. Public configuration details (like domain names and database names) are stored in the `.env` file.

- **Inside the containers:** Docker mounts these secrets securely into RAM under the `/run/secrets/` directory in the containers that need them (e.g., WordPress and MariaDB).

- **Managing Credentials:** If you want to change passwords or usernames *after* the initial launch, simply changing the text files is not enough, because the database and WordPress are already initialized in the persistent volumes. You will need to change the files in the `secrets` directory, then run `make fclean` to wipe the volumes, and finally `make` to initialize the services from scratch with the newly set credentials.

## ◦ Check that the services are running correctly

- **Check container status:** Run `docker ps` or `docker compose ps` to verify that all 3 containers (`nginx`, `wordpress`, `mariadb`) are running. The MariaDB container should display a `(healthy)` status if the database is ready.

- **Check container logs:** If a service isn't behaving correctly, inspect its logs by running `docker logs <container_name>` (e.g., `docker logs nginx` or `docker logs mariadb`). This will show you initialization messages and any potential errors.

- **Inside the container:** To verify configurations or connections directly from inside a container, you can open a shell securely by running `docker exec -it <container_name> sh`.

- **Inspect local persistent data (Bind Mounts):** The data for your volumes is mapped directly to your host machine's disk. You can find the database data in `/home/${USER}/data/mariadb` and the WordPress website files in `/home/${USER}/data/wordpress`. Since these are owned by the Docker containers, you will need `sudo` rights to read the files inside these directories from your host machine.

