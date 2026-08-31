## Multistage Dockerfile

A **multistage Dockerfile** is used to optimize the final Docker image size.

It allows you to use multiple `FROM` statements in a single Dockerfile. Each `FROM` instruction starts a new build stage.

The output or artifacts created in one stage can be copied into another stage using the `COPY --from` instruction.

Typically, the first stage is used to:

- Install build dependencies
- Compile or build the application
- Generate production-ready artifacts

The final stage contains only the files and dependencies required to run the application.

This helps create a **smaller, cleaner, and more secure Docker image**.

### Example Flow

```text
Build Stage
    │
    │ Install dependencies
    │ Build / Compile application
    ▼
Build Artifacts
    │
    │ Copy only required files
    ▼
Production Stage
    │
    │ Run the application
    ▼
Smaller Final Image
```

---

### Advantages of Multistage Dockerfiles

- **Smaller image size** – Only the required runtime files are included in the final image.
- **Improved security** – Build tools and unnecessary dependencies can be excluded from the production image.
- **Faster image transfer** – Smaller images can be pushed and pulled faster.
- **Reduced storage usage** – Smaller images consume less storage.
- **Cleaner deployments** – The final image contains only what is needed to run the application.
- **Separation of build and runtime environments** – Build dependencies can remain in the build stage and do not need to exist in the production stage.

---

# Multistage Dockerfile for Node.js

A normal Node.js Dockerfile may look like this:

```dockerfile
FROM node:20

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "start"]
```

This image may contain:

- Node.js runtime
- Build dependencies
- Development dependencies
- Source code
- Package manager cache

For some applications, especially frontend applications that need a build step, these files are not required in the final production image.

A multistage build can separate the **build environment** from the **runtime environment**.

## Node.js Example

```dockerfile
# --------------------
# Stage 1: Build Stage
# --------------------
FROM node:20 AS builder

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build


# -------------------------
# Stage 2: Production Stage
# -------------------------
FROM node:20-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install --omit=dev

COPY --from=builder /app/dist ./dist

EXPOSE 3000

CMD ["node", "dist/server.js"]
```

### How It Works

```text
Stage 1: builder

Node.js Full Image
        │
        ▼
Install Dependencies
        │
        ▼
Copy Source Code
        │
        ▼
npm run build
        │
        ▼
Generate dist/
        │
        │ COPY --from=builder
        ▼
Stage 2: Production

node:20-alpine
        │
        ▼
Copy dist/
        │
        ▼
Install Production Dependencies
        │
        ▼
Run Application
```

The final image does not need to contain all the files from the build stage.

Only the required files are copied:

```dockerfile
COPY --from=builder /app/dist ./dist
```

---

# Multistage Dockerfile for React

React applications are a common use case for multistage builds.

During development, Node.js is required to:

- Install packages
- Run the build process
- Compile and optimize the React application

However, after building the application, the final output consists of static files such as:

```text
HTML
CSS
JavaScript
Images
```

Node.js is not required to serve these static files in production.

Therefore, we can use:

- **Node.js** for building the application
- **Nginx** for serving the final static files

## React Multistage Dockerfile

```dockerfile
# --------------------
# Stage 1: Build Stage
# --------------------
FROM node:20 AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

RUN npm run build


# -------------------------
# Stage 2: Production Stage
# -------------------------
FROM nginx:alpine

COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

> For Create React App, the build output directory is usually `build` instead of `dist`.

```dockerfile
COPY --from=builder /app/build /usr/share/nginx/html
```

### React Build Flow

```text
React Source Code
        │
        ▼
Node.js Build Stage
        │
        ▼
npm ci
        │
        ▼
npm run build
        │
        ▼
Static Files
HTML + CSS + JavaScript
        │
        ▼
COPY --from=builder
        │
        ▼
Nginx Production Image
        │
        ▼
Serve React Application
```

The final Nginx image does not contain:

- Node.js
- `node_modules`
- Source code
- Build tools

It contains only the built static files required to serve the application.

---

# Multistage Dockerfile for Python

Python applications can also benefit from multistage builds.

The build stage can contain:

- Compilers
- Build tools
- Development packages
- Dependencies required to build Python packages

The final stage contains only:

- Python runtime
- Required application dependencies
- Application source code

## Python Multistage Dockerfile

```dockerfile
# --------------------
# Stage 1: Build Stage
# --------------------
FROM python:3.12 AS builder

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir --prefix=/install -r requirements.txt


# -------------------------
# Stage 2: Production Stage
# -------------------------
FROM python:3.12-slim

WORKDIR /app

COPY --from=builder /install /usr/local

COPY . .

EXPOSE 8000

CMD ["python", "app.py"]
```

### Python Build Flow

```text
Build Stage
    │
    ▼
Python Full Image
    │
    ▼
Install Dependencies
    │
    ▼
Dependencies Installed
    │
    │ COPY --from=builder
    ▼
Production Stage
    │
    ▼
Python Slim Image
    │
    ▼
Copy Dependencies
    │
    ▼
Copy Application Code
    │
    ▼
Run Python Application
```

For example, a Flask application could use:

```dockerfile
CMD ["python", "app.py"]
```

A FastAPI application could use:

```dockerfile
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

---

# Choosing the Right Base Image

A multistage build allows you to use a larger image during the build process and a smaller image for production.

```text
┌─────────────────────────────────────┐
│           Build Stage               │
│                                     │
│  Full Base Image                    │
│                                     │
│  - Compilers                        │
│  - Build tools                      │
│  - Development dependencies         │
│  - Source code                      │
└──────────────────┬──────────────────┘
                   │
                   │ Copy required output
                   ▼
┌─────────────────────────────────────┐
│        Production Stage             │
│                                     │
│  Minimal Base Image                 │
│                                     │
│  - Runtime                          │
│  - Production dependencies          │
│  - Build artifacts                  │
└─────────────────────────────────────┘
```

For example:

| Application | Build Image | Production Image |
|---|---|---|
| Node.js Backend | `node:20` | `node:20-alpine` or `node:20-slim` |
| React | `node:20` | `nginx:alpine` |
| Python | `python:3.12` | `python:3.12-slim` |
| Java | JDK image | JRE/runtime image |

---

# Important Multistage Commands

### `AS`

The `AS` keyword gives a name to a build stage.

```dockerfile
FROM node:20 AS builder
```

Here, the stage is named:

```text
builder
```

---

### `COPY --from`

The `COPY --from` instruction copies files from another build stage.

```dockerfile
COPY --from=builder /app/dist ./dist
```

This means:

```text
Copy files from:

builder → /app/dist

To:

current stage → ./dist
```

---

## Summary

A multistage Dockerfile separates the application build process from the production runtime.

```text
Source Code
     │
     ▼
Build Stage
     │
     ├── Install dependencies
     ├── Compile application
     └── Generate artifacts
              │
              ▼
        COPY --from
              │
              ▼
Production Stage
     │
     ├── Minimal base image
     ├── Runtime dependencies
     └── Application artifacts
              │
              ▼
       Smaller Docker Image
```

Using multistage builds is especially useful for applications such as:

- Node.js
- React
- Angular
- Python
- Java
- Go

The main idea is simple:

> **Use a full or heavy image to build the application when necessary, then copy only the required output into a smaller production image.**