q# Docker — 50 Q&A (25 Theory + 25 Scenario)

## Theory-Based

1. **Q: What is Docker?**
   A: A platform for building, packaging, and running applications in lightweight, portable containers that share the host OS kernel.

2. **Q: What is the difference between a container and a VM?**
   A: Containers share the host OS kernel and are lightweight/fast to start; VMs virtualize full hardware with their own OS, making them heavier and slower to boot.

3. **Q: What is a Docker image?**
   A: A read-only, layered template containing application code, dependencies, and runtime, used to create containers.

4. **Q: What is a Dockerfile?**
   A: A text file with instructions (FROM, RUN, COPY, CMD, etc.) that Docker uses to build an image.

5. **Q: What is the difference between CMD and ENTRYPOINT?**
   A: ENTRYPOINT defines the fixed executable that always runs; CMD provides default arguments that can be overridden at runtime. They're often combined.

6. **Q: What is a Docker layer, and why do layers matter for build performance?**
   A: Each Dockerfile instruction creates a cached, immutable layer; Docker reuses unchanged layers on rebuild, speeding up builds when instructions are ordered from least to most frequently changing.

7. **Q: What is Docker Compose?**
   A: A tool for defining and running multi-container applications using a YAML file (`docker-compose.yml`), managing networking and dependencies between services.

8. **Q: What is a Docker volume?**
   A: A persistent storage mechanism managed by Docker, decoupled from the container's writable layer, used to persist data beyond a container's lifecycle.

9. **Q: Difference between volumes and bind mounts?**
   A: Volumes are managed by Docker and stored in Docker's storage area; bind mounts map a specific host filesystem path directly into the container.

10. **Q: What is a multi-stage build?**
    A: A Dockerfile technique using multiple `FROM` stages to compile/build in one stage and copy only the final artifacts into a lean final image, reducing image size.

11. **Q: What is the Docker daemon?**
    A: The background service (`dockerd`) that manages images, containers, networks, and volumes, exposed via a REST API used by the Docker CLI.

12. **Q: What is a Docker network, and what are the common driver types?**
    A: A virtual network enabling container communication. Common drivers: bridge (default, single host), host (shares host network), overlay (multi-host, for Swarm/K8s), and none.

13. **Q: What is the difference between `docker run` and `docker start`?**
    A: `docker run` creates and starts a new container from an image; `docker start` restarts an existing, stopped container.

14. **Q: What is a Docker registry?**
    A: A storage/distribution system for Docker images (e.g., Docker Hub, ECR, private registries) where images are pushed and pulled.

15. **Q: What is the purpose of `.dockerignore`?**
    A: It excludes specified files/folders from the build context sent to the Docker daemon, reducing build time and preventing sensitive files from being included.

16. **Q: What is container orchestration and why is it needed?**
    A: The automated management (deployment, scaling, networking, healing) of multiple containers across hosts — needed because manually managing containers at scale is impractical. Kubernetes and Docker Swarm are examples.

17. **Q: What is the difference between an image and a container?**
    A: An image is a static, immutable template; a container is a running (or stopped) instance of that image with its own writable layer and state.

18. **Q: What is Docker Swarm?**
    A: Docker's native container orchestration tool for clustering multiple Docker hosts and managing service deployment/scaling.

19. **Q: What does `docker exec` do?**
    A: It runs a new command inside an already running container, commonly used for debugging (e.g., `docker exec -it <container> bash`).

20. **Q: What is image tagging and why is it important?**
    A: Tags (e.g., `myapp:1.2.0`) identify specific image versions; avoiding `latest` in production ensures deployments are reproducible and traceable.

21. **Q: What is the purpose of `HEALTHCHECK` in a Dockerfile?**
    A: It defines a command Docker runs periodically to determine if the container is functioning properly, marking it healthy/unhealthy.

22. **Q: What is container immutability and why does it matter?**
    A: Containers should be treated as disposable/replaceable rather than modified in place, ensuring consistency and easier rollback — config/data changes belong outside the container.

23. **Q: What is the difference between COPY and ADD in a Dockerfile?**
    A: COPY simply copies files/directories; ADD does the same but also supports remote URLs and automatic extraction of tar archives — COPY is generally preferred for clarity.

24. **Q: What is Docker's default network isolation model?**
    A: By default, containers on the same bridge network can communicate with each other but are isolated from the host's other containers/networks unless explicitly connected or ports are published.

25. **Q: What is a "distroless" or minimal base image and why use one?**
    A: An image containing only the application and its runtime dependencies (no shell, package manager, OS utilities), reducing attack surface and image size.

## Scenario-Based

26. **Q: Your Docker image is 2GB and slow to deploy. How do you reduce its size?**
    A: Use a smaller base image (e.g., alpine), implement multi-stage builds to drop build tools from the final image, combine RUN commands to reduce layers, and add a `.dockerignore`.

27. **Q: A container exits immediately after `docker run`. How do you debug it?**
    A: Check logs with `docker logs <container>`, verify the CMD/ENTRYPOINT isn't a short-lived process, and try running interactively (`-it`) with a shell to inspect.

28. **Q: You need containers on different hosts to communicate. What do you use?**
    A: An overlay network (in Docker Swarm mode) or a container orchestrator like Kubernetes with its own CNI networking, since default bridge networks are single-host only.

29. **Q: Your application container loses all data every time it restarts. How do you fix this?**
    A: Mount a Docker volume (or bind mount) to the directory where the application writes persistent data, so it survives container recreation.

30. **Q: A security scan flags your image for running as root. How do you fix it?**
    A: Add a non-root `USER` instruction in the Dockerfile, creating and switching to a dedicated user before the app runs.

31. **Q: Two containers on the same host need to talk to each other by name. How do you set that up?**
    A: Put them on the same user-defined bridge network (or Compose service network) — Docker's embedded DNS resolves container/service names automatically.

32. **Q: Your build is slow because dependencies reinstall every time even when code changes are unrelated. How do you fix the Dockerfile?**
    A: Reorder the Dockerfile so dependency installation (e.g., `COPY package.json` + `npm install`) happens before copying the full source code, leveraging layer caching.

33. **Q: You need to run the same app with different configs in dev/staging/prod using Docker. How?**
    A: Use environment variables (via `-e`, `.env` files, or Compose `environment:`) or externalized config files mounted as volumes, keeping the image itself environment-agnostic.

34. **Q: Your container is running out of memory and getting OOM-killed. How do you investigate and fix?**
    A: Check `docker stats` and logs for OOM events, profile the app's memory usage, and set/adjust memory limits (`--memory`) appropriately or fix a memory leak in the app.

35. **Q: How do you securely pass a database password to a container without hardcoding it in the image?**
    A: Pass it via environment variables at runtime, or better, use Docker secrets (in Swarm) or an external secrets manager, never baking it into the Dockerfile/image.

36. **Q: Your CI pipeline builds an image, but you want to ensure it's the exact same image promoted through test → staging → prod. How?**
    A: Build once, tag with a unique identifier (e.g., git SHA), push to a registry, and reference that exact image digest/tag in each environment rather than rebuilding.

37. **Q: A container needs to bind to port 80, but you're running Docker as a non-root user with limited privileges. How do you handle this?**
    A: Map an unprivileged host port to the container's port (e.g., `-p 8080:80`), or configure the app inside the container to listen on a non-privileged port.

38. **Q: You suspect a running container has been compromised. What's your immediate action?**
    A: Isolate it (disconnect from network), capture logs/forensic data (`docker inspect`, `docker logs`, filesystem diff), then stop and remove it, and rebuild from a known-clean image.

39. **Q: Your multi-container app (web, api, db) needs to start in the correct order. How do you manage this with Compose?**
    A: Use `depends_on` for startup ordering, combined with health checks so dependent services wait until the dependency is actually ready, not just started.

40. **Q: How would you migrate a legacy monolith into containers without a full rewrite?**
    A: Containerize the existing app as-is first (lift-and-shift into a Docker image with its dependencies), validate it runs correctly, then incrementally decompose into services afterward.

41. **Q: Disk space on your Docker host is filling up. What's likely the cause and fix?**
    A: Dangling images, stopped containers, and unused volumes accumulate over time — clean up with `docker system prune` (and `-a --volumes` carefully) and set up regular pruning.

42. **Q: Your app needs different behavior for local development (hot reload) vs production builds. How do you structure Dockerfiles/Compose for this?**
    A: Use multi-stage Dockerfiles with a `dev` and `prod` target, or separate `docker-compose.override.yml` for dev-specific volume mounts and commands.

43. **Q: A teammate's image works on their machine but fails on the CI server with a different behavior. What do you check?**
    A: Confirm both use the exact same image tag/digest (not just `latest`), check for host-OS dependent behavior (e.g., file permissions, architecture differences like ARM vs x86).

44. **Q: You need to limit a noisy-neighbor container from consuming all host CPU. How?**
    A: Set CPU limits/shares with `--cpus` or `--cpu-shares` when running the container, or define resource limits in Compose/orchestrator config.

45. **Q: How would you roll back a bad container deployment quickly?**
    A: Redeploy the previous known-good image tag/digest from the registry — since images are immutable and versioned, rollback is just running the prior tag.

46. **Q: Your Dockerfile installs packages that require credentials, which you don't want left in image layers. How do you handle this securely?**
    A: Use Docker BuildKit secret mounts (`--mount=type=secret`) so credentials are available during build but never persisted in the final image layers.

47. **Q: A container needs access to the host's Docker daemon to manage other containers (Docker-in-Docker use case). How do you set this up, and what's the risk?**
    A: Mount `/var/run/docker.sock` into the container; this grants root-equivalent access to the host, so it should be used cautiously and only in trusted contexts.

48. **Q: You want automated vulnerability scanning of images before they're deployed. How do you integrate this?**
    A: Add an image scanning step (e.g., Trivy, Docker Scout, Snyk) in the CI pipeline after build, failing the pipeline if critical CVEs are found.

49. **Q: Your service needs to scale to handle more load, but it's just running as standalone `docker run` containers. What's the next step?**
    A: Move to an orchestrator (Docker Swarm or Kubernetes) that supports declarative scaling, load balancing, and self-healing across multiple hosts.

50. **Q: How do you ensure consistent container behavior across ARM (e.g., Apple Silicon, AWS Graviton) and x86 environments?**
    A: Build multi-architecture images using `docker buildx` with a manifest list, so the correct architecture-specific image is pulled automatically at runtime.
