# Install docker

Follow the instructions on Docker's official website to [install Docker](https://docs.docker.com/engine/install/) in your machine. Make sure you install Docker Compose as well.

To verify if Docker is installed correctly, run:
```bash
docker run hello-world
```

If the installation is successful, you should see the following message:
```
Hello from Docker!
This message shows that your installation appears to be working correctly.
...
```

To verify if Docker compose is installed, run:
```bash
docker compose version
```
You should see something similar to the following:
```
Docker Compose version v...
```

NOTE: Docker is already installed in CSL machines. To start the service in CSL, follow the instructions in [this page](https://csl.cs.wisc.edu/docs/csl/docker/).

For an introduction to Docker, you can look at this [lecture on Wed, Sep 13](https://tyler.caraza-harter.com/cs544/f23/schedule.html) 



# Setup a Container for xv6

Clone this repository and navigate to the directory where the `docker-compose.yml` and `Dockerfile` are located.


### Build the Docker Image locally

Run the following command to build the Docker image: 
```bash
docker build -t cs537-v1 --platform=linux/amd64 .
```

It should create a Docker image named `cs537-v1`. You can verify the image exists by running: 
```bash
docker images
```   

### Bring up the Docker Compose Environment

Start the container with Docker Compose by running:
```bash
docker compose up -d
```

This will start a container named `cs537`. You can verify it by running: 
```bash
docker ps -a
```

You should also see a new directory `cs537` in the current folder. This directory is mounted to `/cs537` inside the container, meaning any changes you make in `./cs537` on your host machine will be reflected in the container's `/cs537` directory.


### Access the container

To access the container, run:
```bash
docker exec -it cs537 bash
```

It opens a bash session inside the container. You can run this command multiple times to open multiple bash sessions in the same container.


### Setup xv6

Copy your `xv6-public` folder to the `cs537` directory of your host machine. This will be reflected as `/cs537/xv6-public` inside the container. 

To build and run xv6, bash into the container, navigate to `/cs537/xv6-public`, and run:
```bash
make qemu-nox
``` 


### Stop the container

Once you're done using the container, you can stop it with:
```bash
docker stop cs537
```

Stopping the container does not delete it or the work inside.


# Reusing the container 

Once the docker image and the container are created, it will remain saved in your machine. So, the next time you want to use this container, follow these steps:

1. **Start the container**
    ```bash 
    docker start cs537
    ```

2. **Access the container with bash**
    ```bash
    docker exec -it cs537 bash
    ```

3.  **Stop the container**
    ```bash
    docker stop cs537
    ```