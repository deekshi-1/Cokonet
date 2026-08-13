# Docker 
Docker is a platform that lets you package an application and everything it needs to run (code, libraries, dependencies, and configuration) into a container.


### VM vs Container
A VM virtualizes a whole computer/OS environment, whereas a container primarily isolates processes/applications while sharing the host kernel.

## Life cycle of container
```img
             docker create
Image ──────────────────────► Created
                                │
                                │ docker start
                                ▼
                             Running
                            /   │   \
                           /    │    \
                  pause   /     │     \ stop
                         ▼      │      ▼
                      Paused    │    Exited
                         │      │      │
                    unpause     │    start
                         │      │      │
                         └──────┴──────┘
                                │
                              rm
                                ▼
                             Removed
```

- Image = blueprint
- Container = isolated environment created from the image
- Process = application actually running inside the container

The Docker container lifecycle describes the different stages a container goes through from creation to deletion. First, a Docker image is used to create a container. The container starts in the Created state, and when it is started using docker start or docker run, it enters the Running state. A running container can be temporarily Paused using docker pause and later resumed using docker unpause. When the container is stopped using docker stop, it enters the Stopped/Exited state, but it still exists and can be started again. Finally, when the container is no longer needed, it can be Removed using docker rm. Thus, the basic lifecycle is Image → Created → Running → Paused/Stopped → Restarted or Removed.

## Docker CMD
**docker** is the main command-line interface (CLI) used to interact with Docker
```bash
docker <command> <options> <arguments>
docker --version #checks the version
```
## 🖼️ Image Management

### List Local Images
Displays all the Docker images currently downloaded to your local machine. 
*   **Command:** `docker images`
*   *Modern alternative:* `docker image ls`

### Pull an Image
Downloads the specified image from a Docker registry (defaults to Docker Hub) to your local machine without running it.
*   **Command:** `docker pull <image-name>`
*   **Example:** `docker pull ubuntu:latest`

### Remove an Image
Deletes an image from your local storage. 
> **Note:** You must stop and remove any containers using this image before it can be deleted.
*   **Command:** `docker rmi <image-name>`

---

## 📦 Container Management

### List Running Containers
Shows only the currently active, running containers.
*   **Command:** `docker ps`
*   *Modern alternative:* `docker container ls`

### List All Containers
Shows all containers on your system, including both running and stopped instances.
*   **Command:** `docker ps -a`

### Create and Start a Container
This command is a combination of `docker create` and `docker start`. Docker checks if the image exists locally; if not, it pulls it from Docker Hub, creates the container, and starts it.
*   **Command:** `docker run <image-name>`

---

## ⚙️ Essential `docker run` Flags

When starting a container with `docker run`, you will almost always use flags to configure its behavior.

| Flag | Name | Description | Example |
| :--- | :--- | :--- | :--- |
| `-d` | **Detached Mode** | Runs the container in the background and prints the container ID, freeing up your terminal. | `docker run -d <image-name>` |
| `-p` | **Port Mapping** | Binds a port on your local machine (host) to a specific port inside the container. | `docker run -p 8080:80 nginx`<br>*(Routes traffic from localhost:8080 to container's port 80)* |
| `--name` | **Container Name** | Assigns a custom, memorable name to your container instead of letting Docker generate a random one. | `docker run --name my-app <image-name>` |