## Dockerfile
A Dockerfile is a text file that contains instructions for building a `Docker image`. Think of it as a recipe that tells Docker exactly how to create a portable environment for your application.

### How It Works
The basic workflow is:

1. Create a Dockerfile with the required instructions.
2. Docker reads and executes the instructions in the `Dockerfile`.
3. Docker builds a Docker image based on those instructions.
4. You can run the image as a Docker container.


### Basic Dockerfile Example
```
# Use Ubuntu as the base image 
FROM ubuntu:latest 

# Update package lists 
RUN apt update 
# Install Nginx 
RUN apt install -y nginx 

# Start Nginx in the foreground 
CMD ["nginx", "-g", "daemon off;"]
```

### Docker file terms
Some of the important terms to remember in docker file are:
| Instruction | Description |
|---|---|
| `FROM` | Specifies the base image to use. |
| `RUN` | Executes commands during the image build process. |
| `COPY` | Copies files or directories from the host machine into the image. |
| `ADD` | Copies files into the image and provides additional features such as archive extraction. |
| `WORKDIR` | Sets the working directory for subsequent instructions. |
| `CMD` | Specifies the default command to run when a container starts. |
| `ENTRYPOINT` | Configures the main executable for the container. |
| `EXPOSE` | Documents the port that the application listens on inside the container. |
| `ENV` | Defines environment variables inside the image and container. |
| `ARG` | Defines variables that can be passed during the image build process. |
| `USER` | Specifies the user that runs subsequent commands and the container process. |
| `LABEL` | Adds metadata to the Docker image. |
| `VOLUME` | Defines a mount point for persistent data. |
| `HEALTHCHECK` | Specifies a command to check the health of a container. |
| `SHELL` | Specifies the default shell used by `RUN` instructions. |
| `ONBUILD` | Specifies instructions that execute when the image is used as a base image for another image. |

### Dockerfie Commands
1. Build a Docker Image
Build a Docker image using the Dockerfile in the current directory:
```
docker build -t <image-name> . 
```
- **`-t`:** It gives your Docker image a name
- **`.`:** Specifies the current directory as the build context. Docker can access files from this directory during the build

---

2. Dockerfile has a different name
If your Dockerfile has a different name, use the -f option to specify it explicitly:
```
docker build -f Dockerfile.dev -t myapp .
```
- **`-f`:** Specifies the Dockerfile to use.
- **`Dockerfile.dev`:** The name or path of the Dockerfile.

---

3. Tag a Docker Image
Tags are commonly used to identify different versions of a Docker image.
```
docker tag <source-image> <target-image>:<tag>

#Examples
docker tag my-app my-app:1.0
docker tag my-app my-app:latest
```
- **`my-app`:** Image name.
- **`1.0`:** Image version/tag.
- **`latest`:** A commonly used tag for the default/latest version.

---

4. Push an Image
Push a Docker image to a Docker registry:
```
docker push <username>/<image-name>:<tag>

#Example
docker push username/myapp:1.0
```
Before pushing an image, you generally need to authenticate with the registry:`docker login`