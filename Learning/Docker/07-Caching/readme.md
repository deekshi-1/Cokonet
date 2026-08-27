## Docker Layering and Caching
A Docker image is not a single block of data. It is made up of multiple read-only layers stacked on top of each other.

```
FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y nginx
COPY index.html /var/www/html/
```
Each filesystem-changing instruction contributes to the image's layered filesystem.

### Docker Layer Caching

Imagine you build an image today.

The first build may take some time because Docker has to execute all the instructions:
```
FROM ubuntu:latest
       ↓
RUN apt-get update
       ↓
RUN apt-get install -y nginx
       ↓
COPY index.html /var/www/html/

```
Now, tomorrow, you only change index.html.

Docker doesn't need to rebuild everything from scratch. It can reuse the layers that haven't changed and only rebuild the affected layer and the steps that follow it.
```
First build:

FROM ubuntu          → Built
RUN apt-get update   → Built
RUN apt-get install  → Built
COPY index.html      → Built


Second build:

FROM ubuntu          → Cached
RUN apt-get update   → Cached
RUN apt-get install  → Cached
COPY index.html      → Rebuilt
```
This is why subsequent Docker builds can be much faster.

### Building a Node.js Application
The package.json file is an important part of a Node.js application. It contains information about the project's dependencies.

Installing dependencies with: `npm install` can take a significant amount of time, especially when there are many dependencies.

```
FROM node:21
WORKDIR /app
COPY . .
RUN npm install
CMD {"node","app.js"}
```
There is a caching problem here.

Suppose you change only: `app.js` Because of `COPY . .` Docker sees that the contents being copied have changed.

Therefore, the cache for that step is invalidated, and the following instruction:`npm install` may have to run again.

That is inefficient because your dependencies haven't changed.

**A Better Dockerfile**

Instead, copy the dependency files first:
 
```
FROM node:21
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
CMD {"node","app.js"}
```
Now the build is structured like this:
```
FROM node:21
       ↓
COPY package.json package-lock.json
       ↓
RUN npm install
       ↓
COPY application source code
       ↓
CMD
```
If you change only app.js,Docker can reuse the expensive npm install layer because the dependency files haven't changed.

**The General Rule**

A very useful rule for writing efficient Dockerfiles is:

- Put files that change frequently later, and expensive operations that depend on stable files earlier.


## .dockerignore and BUild context 

### Build context
The build context specifies the location and files that Docker sends to the Docker daemon for building an image. It usually contains the Dockerfile and other files required during the image build.
For example:
```
docker build -t my-image .
```
Here,`.` represents the current directory, which is used as the build context.

### .dockerignore
The `.dockerignore` file specifies files and directories that should be excluded from the build context and not sent to the Docker daemon during the image build.
Example:
```
node_modules
.git
.env
npm-debug.log
```

This helps reduce the build context size and prevents unnecessary or sensitive files from being included in the Docker image.

