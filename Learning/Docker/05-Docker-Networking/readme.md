## Docker Network 
A Docker network is used to enable communication between Docker containers and, depending on the network type, with the host machine or external networks.

### Types of Docker Networks
Docker commonly provides these network drivers:

#### 1. Bridge Network
- Default network for standalone Docker containers.
- Provides network isolation from the host network.
- Allows containers on the same bridge network to communicate with each other.
- Containers can also communicate with external networks through the host.
#### 2. Host Network
- Removes network isolation between the container and the Docker host.
- The container uses the host's network stack directly.
- There is no separate container IP address.
- Useful when high network performance or direct access to host networking is needed.
#### 3. None Network
- Provides no network connectivity to the container.
- The container has only the loopback interface (localhost).
- Useful when a container should be completely isolated from the network.

### Docker Network Commands
#### 1. Create a Network :
```
docker network create <network-name> --driver=<driver-name(bridge/host/none)>
```
Note: For a custom network, bridge is the commonly used driver. host and none have special behavior and are generally used differently.

#### 2. List Networks : 
```
docker network ls
```
This displays all Docker networks.

#### 3. Inspect a Network:
 ```
 docker network inspect <network name>
 ```
 This shows detailed information such as:

- Network driver
- Subnet and gateway
- Connected containers
- Network configuration

### Hands-on: Test the Default Bridge Network
1. Create two containers
```
docker run -itd --name=sys1 centos:8
docker run -itd --name=sys2 centos:8

```
Both containers will automatically be connected to Docker's default `bridge` network.

2. Inspect the bridge network
```
docker network inspect bridge
```
Look under the `Containers` section. You should see both `sys1` and `sys2` listed, along with their IP addresses

3. Find the IP addresses
```
docker inspect sys1 | grep -iA 3 ipaddress
docker inspect sys2 | grep -iA 3 ipaddress
```
4. Enter sys1 and Test internet connectivity

Inside sys1:
```
docker exec -it sys1 /bin/bash
ping google.com
ping <sys2-ip>
```
### Hands-on: Test a New Bridge Network
1. Create a new bridge network
```
docker network create <network-name> --driver=bridge
```
2. Create two containers using the new network
```
docker run -itd --name=sys3 --network=<newnetworkname> centos:8
docker run -itd --name=sys4 --network=<newnetworkname> centos:8
```
3. Test internet connectivity
    - Enter `sys3:`
    - `ping -c 6 google.com`If you receive replies, sys3 can access the internet.
4. Test container-to-container communication
    - From inside `sys3:`
    - `ping -c 6 sys4` This should work because user-defined bridge networks provide Docker's built-in DNS resolution.
5. Test network isolation
    - From `sys3`, try to ping `sys1` using its IP address:`ping -c 6 <sys1-ip-address>`
    - You should not normally be able to communicate directly between the two separate bridge networks.
### Hands-on: Test Host Network
Boot up an Nginx instance using the `host` network:
```
docker run -d --name=<container-name> --network=host <image-name>
docker inspect <container-name>
docker network inspect host
```
Inspect the container and host network configuration. You should not see a separate container IP address because the container shares the host's network namespace.
Now verify that Nginx is running:

`curl localhost:80`

If Nginx is working correctly, the command should return the default Nginx HTML response.

You can also verify that Nginx is listening on port 80:

ss -lntp | grep :80

Because the container uses the host network, you do not need to publish the port with -p 80:80. The service is directly accessible through the host's network interface.

### Hands-on: Test None Network
Boot up a centos image with netwoke none
`docker run -t --name=none --network=none centos:8`

check by `ping google.com`
