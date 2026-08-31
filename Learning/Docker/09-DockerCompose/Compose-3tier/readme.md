# Docker Compose – 3-Tier Application

This project uses **Docker Compose** to deploy a 3-tier application consisting of:

- **Frontend**
- **Backend**
- **MySQL Database**

The services communicate through a custom Docker bridge network, and the MySQL database uses a persistent Docker volume.

---

# Architecture

```text
                    Docker Host

        ┌──────────────────────────────┐
        │                              │
        │       app-network            │
        │                              │
        │  ┌───────────┐               │
        │  │ Frontend  │               │
        │  │ Port 3000 │               │
        │  └─────┬─────┘               │
        │        │                     │
        │        ▼                     │
        │  ┌───────────┐               │
        │  │  Backend  │               │
        │  │ Port 5000 │               │
        │  └─────┬─────┘               │
        │        │                     │
        │        ▼                     │
        │  ┌───────────┐               │
        │  │ MySQL DB  │               │
        │  │   appdb   │               │
        │  └─────┬─────┘               │
        │        │                     │
        │        ▼                     │
        │    db-data Volume            │
        │                              │
        └──────────────────────────────┘
```

---

# Docker Compose Configuration

The `docker-compose.yml` file defines three services:

```text
Frontend
    ↓
Backend
    ↓
MySQL Database
```

All services are connected through the `app-network`.

---

## Services

The `services` section defines all the containers required to run the application.

```yaml
services:
```

In this project, there are three services:

- `db`
- `backend`
- `frontend`

---

# Database Service

```yaml
db:
  image: mysql:8.0
  container_name: mysql-db
```

The `db` service runs the MySQL database.

### `image: mysql:8.0`

Uses the MySQL Docker image with version `8.0`.

### `container_name: mysql-db`

Assigns the name `mysql-db` to the running container.

---

## Database Environment Variables

```yaml
environment:
  MYSQL_ROOT_PASSWORD: root
  MYSQL_DATABASE: appdb
```

These environment variables configure MySQL.

| Variable | Description |
|---|---|
| `MYSQL_ROOT_PASSWORD` | Sets the password for the MySQL root user. |
| `MYSQL_DATABASE` | Automatically creates a database named `appdb`. |

---

## Database Volumes

```yaml
volumes:
  - ./db/init.sql:/docker-entrypoint-initdb.d/init.sql
  - db-data:/var/lib/mysql
```

### Initialize Database

```yaml
- ./db/init.sql:/docker-entrypoint-initdb.d/init.sql
```

The local `init.sql` file is mounted inside the MySQL container.

When MySQL starts for the first time, SQL files inside:

```text
/docker-entrypoint-initdb.d/
```

are executed automatically.

This can be used to:

- Create tables
- Insert initial data
- Configure the database

### Persistent Storage

```yaml
- db-data:/var/lib/mysql
```

MySQL stores its data inside:

```text
/var/lib/mysql
```

The `db-data` Docker volume stores the database files.

This ensures that the database data persists even if the MySQL container is removed and recreated.

---

# Database Network

```yaml
networks:
  - app-network
```

The database is connected to `app-network`.

Other containers on the same network can communicate with the database using the service name:

```text
db
```

For example:

```text
Backend → db
```

---

# Database Health Check

```yaml
healthcheck:
  test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
  interval: 10s
  timeout: 5s
  retries: 5
  start_period: 10s
```

The health check verifies whether MySQL is running and ready to accept connections.

The following command is executed inside the container:

```bash
mysqladmin ping -h localhost
```

### Health Check Configuration

| Option | Description |
|---|---|
| `interval: 10s` | Runs the health check every 10 seconds. |
| `timeout: 5s` | Waits up to 5 seconds for the command to complete. |
| `retries: 5` | Marks the container as unhealthy after 5 consecutive failures. |
| `start_period: 10s` | Gives MySQL time to start before failures are counted. |

---

# Backend Service

```yaml
backend:
  build: ./backend
  container_name: backend-service
```

The `backend` service runs the backend application.

## Build Context

```yaml
build: ./backend
```

The `./backend` directory is used as the **build context**.

Docker Compose looks for the `Dockerfile` inside this directory and builds the backend image.

Example project structure:

```text
project/
├── docker-compose.yml
├── backend/
│   ├── Dockerfile
│   └── ...
├── frontend/
│   ├── Dockerfile
│   └── ...
└── db/
    └── init.sql
```

---

## Backend Ports

```yaml
ports:
  - "5000:5000"
```

Maps:

```text
Host Port 5000 → Backend Container Port 5000
```

The backend can be accessed from the host machine at:

```text
http://localhost:5000
```

---

## Backend Dependency

```yaml
depends_on:
  db:
    condition: service_healthy
```

The backend depends on the MySQL database.

Docker Compose waits until the database health check passes before starting the backend.

```text
MySQL Starts
     ↓
MySQL Becomes Healthy
     ↓
Backend Starts
```

---

## Backend Environment Variables

```yaml
environment:
  DB_HOST: db
  DB_USER: root
  DB_PASSWORD: root
  DB_NAME: appdb
```

These variables provide the backend application with the database connection details.

| Variable | Description |
|---|---|
| `DB_HOST` | The database hostname. Uses the Docker service name `db`. |
| `DB_USER` | MySQL username. |
| `DB_PASSWORD` | MySQL password. |
| `DB_NAME` | Database name. |

The backend connects to MySQL using:

```text
DB_HOST=db
```

> `localhost` should not be used to connect from the backend container to the database container because `localhost` refers to the backend container itself.

---

# Frontend Service

```yaml
frontend:
  build: ./frontend
  container_name: frontend-service
```

The `frontend` service runs the frontend application.

## Build Context

```yaml
build: ./frontend
```

Docker Compose uses the `./frontend` directory as the build context and builds the frontend image using its `Dockerfile`.

---

## Frontend Ports

```yaml
ports:
  - "3000:3000"
```

Maps:

```text
Host Port 3000 → Frontend Container Port 3000
```

The frontend can be accessed at:

```text
http://localhost:3000
```

---

## Frontend Dependency

```yaml
depends_on:
  backend:
    condition: service_healthy
```

The frontend waits for the backend to become healthy before starting.

For this configuration to work, the backend service must also define a `healthcheck`.

The startup sequence is:

```text
MySQL Starts
     ↓
MySQL Becomes Healthy
     ↓
Backend Starts
     ↓
Backend Becomes Healthy
     ↓
Frontend Starts
```

---

# Docker Network

```yaml
networks:
  app-network:
    driver: bridge
```

This creates a custom Docker network named `app-network`.

The network uses the `bridge` driver.

All three services are connected to this network:

```text
Frontend
    │
    ▼
Backend
    │
    ▼
MySQL Database
```

Containers connected to the same Docker network can communicate with each other using their service names.

For example:

```text
Frontend → backend
Backend  → db
```

---

# Persistent Volume

```yaml
volumes:
  db-data:
```

This creates a named Docker volume called `db-data`.

The volume is mounted inside the MySQL container:

```yaml
db-data:/var/lib/mysql
```

This provides persistent storage for the database.

```text
MySQL Container
      │
      ▼
/var/lib/mysql
      │
      ▼
Docker Volume
db-data
```

Even if the MySQL container is removed, the database data remains in the `db-data` volume unless the volume is explicitly deleted.

---

# Complete Docker Compose File

```yaml
services:

  # Database Service
  db:
    image: mysql:8.0
    container_name: mysql-db

    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: appdb

    volumes:
      - ./db/init.sql:/docker-entrypoint-initdb.d/init.sql
      - db-data:/var/lib/mysql

    networks:
      - app-network

    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 10s

  # Backend Service
  backend:
    build: ./backend
    container_name: backend-service

    ports:
      - "5000:5000"

    depends_on:
      db:
        condition: service_healthy

    networks:
      - app-network

    environment:
      DB_HOST: db
      DB_USER: root
      DB_PASSWORD: root
      DB_NAME: appdb

  # Frontend Service
  frontend:
    build: ./frontend
    container_name: frontend-service

    ports:
      - "3000:3000"

    depends_on:
      backend:
        condition: service_healthy

    networks:
      - app-network

# Custom Docker Network
networks:
  app-network:
    driver: bridge

# Persistent Database Volume
volumes:
  db-data:
```

---

# Application Startup Flow

```text
1. MySQL container starts
          ↓
2. MySQL health check passes
          ↓
3. Backend container starts
          ↓
4. Backend health check passes
          ↓
5. Frontend container starts
```

# Run the Application

Build and start all services:

```bash
docker compose up --build
```

Run the containers in detached mode:

```bash
docker compose up -d --build
```

Check running containers:

```bash
docker compose ps
```

View application logs:

```bash
docker compose logs
```

Stop the containers:

```bash
docker compose down
```

Stop the containers and remove the persistent database volume:

```bash
docker compose down -v
```

> **Warning:** `docker compose down -v` removes the `db-data` volume and permanently deletes the stored MySQL data.