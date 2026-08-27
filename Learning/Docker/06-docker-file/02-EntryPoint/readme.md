## Entry point vs CMD
Both `ENTRYPOINT` and `CMD` specify what a Docker container should do when it starts.
- `ENTRYPOINT` defines the main executable or application that the container runs. It is not normally replaced when you add arguments to `docker run`.
- `CMD` provides default arguments or a default command. It is easy to override when running the container.

The most important thing to understand about `CMD` is that if you provide a command or arguments at the end of `docker run`, they can replace the `CMD` instruction.

`ENTRYPOINT`, on the other hand, configures the container to run a specific application. Anything added to the end of `docker run` is passed to the `ENTRYPOINT` as an argument.

```
FROM ubuntu:latest

ENTRYPOINT ["ping"]

CMD ["google.com"]
```
Docker combines `ENTRYPOINT` and `CMD`:`ping google.com`

So the container will ping `google.com`.

`yahoo.com` overrides the `CMD` value (`google.com`) and becomes an argument to the `ENTRYPOINT`.

Here for the above code using `docker run <image-name>`. Then it will ping google.com but if you run `docker run <image-name> yahoo.com` the google.com get overriden by yahoo and the google wont be pinged
