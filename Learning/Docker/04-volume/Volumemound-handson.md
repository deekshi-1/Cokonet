## Docker Volume Mount for MySQL

### 1. Create a Docker volume
Create a named Docker volume to persist MySQL data:
```
docker volume create <volume-name>
```
### 2. Create a MySQL container
Run a MySQL container and mount the Docker volume to MySQL's data directory:

```
docker run -d \ -v <volume-name>:/var/lib/mysql \ --name volmount \ -e MYSQL_ROOT_PASSWORD=<password> \ mysql
```

### 3. Open the container 
Use `docker exec` to open a shell inside the running MySQL container:
```
docker exec -it <container-name> /bin/bash
```
Then connect to MySQL:`mysql -u root -p`

Enter the root password when prompted.

Now, you can use MySQL queries to create and store data:
```
SHOW DATABASES;

CREATE DATABASE mydb;

USE mydb;

CREATE TABLE students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    age INT,
    email VARCHAR(100)
);

DESCRIBE students;

INSERT INTO students (name, age, email)
VALUES
    ('John', 20, 'john@example.com'),
    ('Alice', 22, 'alice@example.com'),
    ('Bob', 19, 'bob@example.com'),
    ('David', 25, 'david@example.com'),
    ('Emma', 21, 'emma@example.com');

SELECT * FROM students;
```
### 4. Remove the Container
Exit MySQL and the container shell, then remove the container:
```
docker rm -f <container name>
```
Note: Removing the container does not remove the Docker volume. The data stored in the volume will remain available

### 5. Create a New Container Using the Same Volume
Create a new MySQL container and mount the same Docker volume:\
```
docker run -d \ -v <volume-name>:/var/lib/mysql \ --name volmountnew \ -e MYSQL_ROOT_PASSWORD=<password> \ mysql

```
Open the new container:`docker exec -it <container-name> /bin/bash`

Connect to MySQL:`mysql -u root -p`

Use the same root password that was used when the volume was initially initialized.

Now check whether the previously created data is still available:
```
SHOW DATABASES;
USE mydb;
DESCRIBE students;
SELECT * FROM students;
```