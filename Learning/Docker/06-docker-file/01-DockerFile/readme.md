## Create a Custom NGINX IMAGE

A custom NGINX Docker image can be created using a Dockerfile. In this example, we start with the official NGINX image, remove the default web content, and copy our own index.html file into the NGINX web root.

the docker file is similar to :

`docker run -p 8080:80 -v{pwd}:/usr/share/nginx/html/ nginx`

### Code explanation
- `FROM nginx:latest` : Uses the official NGINX image as the base image.

- `RUN rm -rf /usr/share/nginx/html/*` : Removes the default NGINX web files so they can be replaced with our custom content.

- `COPY index.html /usr/share/nginx/html/` :Copies the local index.html file into NGINX's default web root directory.
- `EXPOSE 80` : Documents that NGINX listens on port 80 inside the container.
- `CMD ["nginx", "-g", "daemon off;"]` : Starts NGINX in the foreground so the container continues running.

## Code to Build And Run
Run the code from the directry in which dockerfile is present 

Build image : `docker build -t <image-name> .`
Run the Container: `docker run -d -p 8080:80 --name <container-name> <image-name>`

You can then access the custom NGINX page at:

http://localhost:8080

