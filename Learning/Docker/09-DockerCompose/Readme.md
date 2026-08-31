## Docker Compose
Docker Compose is a tool that helps you define, run, and manage multiple Docker containers as a single application.

### Key Benefits
- Run multiple containers using a single command.
- Define application services in a YAML configuration file.
- Automatically create and manage networks for services.
- Easily configure environment variables, volumes, ports, and dependencies.
- Simplify local development and testing environments.
- Start, stop, rebuild, and remove the entire application stack easily.

### Docker Compose Commands
#### Start Containers
- Start all services defined in the Docker Compose configuration:`docker compose up`
- Run the services in detached mode:`docker compose up -d`
- Detached mode runs the containers in the background, allowing you to continue using the terminal.

#### Stop Containers
- Stop and remove the services, networks, and containers created by Docker Compose:`docker compose down`
- Note: Volumes are not removed by default. To remove volumes as well, use:`docker compose down -v`

#### View Running Services
- Check the status of services managed by Docker Compose:`docker compose ps`
- This command displays information such as the service name, container status, and exposed ports.

#### View Logs
View logs from all services:`docker compose logs`
Continuously follow the logs in real time:`docker compose logs -f`
View logs for a specific service:`docker compose logs -f <service-name>`

#### Rebuild Services

If you make changes to your application's Dockerfile or source code, you can rebuild the images and start the services using:`docker compose up --build`
To rebuild and run the services in detached mode:`docker compose up -d --build`

#### Restart Services
Restart all running services:`docker compose restart`
Restart a specific service:`docker compose restart <service-name>`

#### Execute Commands Inside a Container

Run a command inside a running service:`docker compose exec <service-name> <command>`

For example, to open a shell inside a service:`docker compose exec app sh`

### Docker Compose File
A Docker Compose file uses YAML syntax to define and configure one or more containers as services.

Instead of running long docker run commands manually, you can define the container configuration in a Compose file, usually named:

compose.yaml

or:

docker-compose.yml

Let's understand this with a simple container example.

Using `docker run`

The following command starts an Nginx container:

`docker run -d -p 8080:80 --name nginx-app nginx`

This command:

- Runs the container in detached mode using -d.
- Names the container nginx-app.
- Uses the nginx image.
- Maps port 8080 on the host machine to port 80 inside the container.

The same configuration can be defined using Docker Compose.

Using Docker Compose

```
services:
 nginx-app:
  image: nginx
  ports:
   - "8080:80"

```
This Compose file defines a service called nginx-app using the Nginx image.

To start the container, run:

docker compose up -d

Docker Compose will create and start the required container in detached mode.

#### Multi-Container Application
One of the main advantages of Docker Compose is the ability to manage multiple containers using a single configuration file.
```
services:
 frontend:
  image: nginx
  ports:
   - "8080:80"
 backend:
  image: hashicorp/http-echo
  command:["-text-hello world"]
```
To start both services, run:

`docker compose up -d`

This command starts both the frontend and backend services.

By default, Docker Compose creates a dedicated bridge network for the project. All services in the same Compose project are connected to this network and can communicate with each other using their service names.

For example, the `frontend` service can communicate with the backend using:

backend

Docker Compose provides internal DNS resolution, so there is usually no need to manually configure container IP addresses.


### Docker Volumes
Containers are generally designed to be ephemeral. This means that data stored only inside a container can be lost when the container is removed.

Docker volumes provide a way to persist data independently of the container lifecycle.

For example, the following Compose file creates a MySQL database with persistent storage:
```
services:
 db:
  image:mysql:8
  volumes:
   - mysql_data:/var/lib/mysql
  environment:
   MYSQL_ROOT_PASSWORD: root
volumes:
 mysql_data:
  external: true
  ```
In this configuration:

- The db service uses the mysql:8 image.
- MySQL stores its database files in /var/lib/mysql.
- The named volume mysql_data is mounted to /var/lib/mysql.
- The MYSQL_ROOT_PASSWORD environment variable sets the password for the MySQL root user.
- The database data persists even if the container is removed and recreated, as long as the volume is not removed.

#### External Volume

If the volume already exists and is managed outside the current Compose project, you can define it as an external volume:
```
services:
  db:
    image: mysql:8
    volumes:
      - mysql_data:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: root

volumes:
  mysql_data:
    external: true
```
Before starting the Compose application, the volume must already exist:

`docker volume create mysql_data`

Note: If `external: true` is not specified, Docker Compose can create and manage the volume automatically.

### 3-Tier Web Application

For a complete example of a Docker Compose-based 3-tier application, refer to the:

Compose-3tier/

folder.

The Compose configuration in this folder demonstrates how multiple services can work together, communicate through Docker networks, and use volumes for persistent database storage.