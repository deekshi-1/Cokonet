## Docker Data Persistence
By default, containers are ephemeral, meaning any data stored inside a container can be lost when the container is removed.

To persist data beyond the container's lifecycle, Docker provides mounts, which allow data to be stored outside the container's writable layer.

### Types of Docker Mounts
Docker mainly provides two commonly used types of mounts:
#### Bind Mount
A bind mount stores data in a specific location on the host machine and makes that location available inside the container.
```
docker run -v /path/on/host:/path/in/container myapp
```
- Use cases:
    - Sharing source code between the host and container
    - Development environments
    - Accessing specific host files or directories

#### Volume mount
A Docker volume is managed by Docker and stored in Docker's own storage area on the host. The volume can be attached to one or more containers.
```
docker volume create myvolume docker run -v myvolume:/app/data myapp
```
- Use cases:
    - Database data
    - Application data that needs to persist
    - Production environments

### Key Difference
| Bind Mount | Docker Volume |
|---|---|
| Managed by the user | Managed by Docker |
| Uses a specific host path | Uses Docker-managed storage |
| Common in development | Common for persistent application data |
| More dependent on the host filesystem | More portable and easier to manage |
