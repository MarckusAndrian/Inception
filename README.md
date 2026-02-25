*This project has been created as part of the 42 curriculum by kandrian.*

## DESCRIPTION
The **Inception** project is an advanced introduction to system administration and service orchestration using **Docker**. The goal is to build a complete, stable, and secure infrastructure composed of several interconnected services, all running on a Debian-based environment.
To ensure a deep understanding of containerization, this project follows strict requirements:
* **Multi-service Architecture:** Each service (NGINX, MariaDB, WordPress) runs in its own dedicated container.
* **Native Builds:** The use of pre-made "ready-to-use" images from Docker Hub is forbidden. Every image is built from scratch using **Dockerfiles** based on Debian Bullseye/Bookworm.
* **Security & TLS:** The entire infrastructure is isolated within a virtual private network, and web access is secured via **TLS v1.2/v1.3** protocols.
* **Data Persistence:** Docker volumes are implemented to ensure that database records and website files are preserved even if the containers are removed or restarted.

### *Technical Design Analysis*

A key part of the project was choosing the right tools and strategies. Below is a comparison of the main architectural choices made:

### 1. Virtual Machines vs Docker
* **Virtual Machines (VM)**: Each VM runs a full "Guest OS" with its own kernel, consuming significant RAM and disk space. They are slow to boot because the entire system must load.
* **Docker (Containers)**: Containers share the **Host OS Kernel**. They only package the application and its dependencies, making them lightweight, fast to start (seconds), and highly efficient in resource usage.
* **Choice**: Docker was chosen for its portability and low overhead.

### 2. Secrets vs Environment Variables
* **Environment Variables**: Stored in plain text. They are easy to use but can be exposed via `docker inspect` or log files.
* **Secrets**: A more secure method where sensitive data is encrypted and mounted as a temporary file in memory.
* **Choice**: For the scope of Inception, **Environment Variables** (via `.env` files) were used for configuration, while acknowledging that Secrets are the standard for high-security production environments.

### 3. Docker Network vs Host Network
* **Host Network**: The container shares the host's IP and ports directly, offering no network isolation.
* **Docker Network (Bridge)**: Creates a **Virtual Private Switch**. Containers can communicate with each other using service names (DNS), but remain invisible to the outside world unless a port is specifically mapped.
* **Choice**: **Bridge Network** was implemented to isolate the MariaDB database from the public internet.

### 4. Docker Volumes vs Bind Mounts
* **Bind Mounts**: Link a specific path on the host to the container. They depend on the host's file structure.
* **Docker Volumes**: Managed entirely by Docker in a dedicated area of the disk. They are more performant, easier to back up, and isolated from the host's OS structure.
* **Choice**: **Named Docker Volumes** were used to ensure the persistence of WordPress files and SQL databases independently of the container lifecycle.

## INSTRUCTIONS
* **Mandatory Dependencies (Secrets & .env)**: 
Before launching the infrastructure, you must manually create the local directory for persistence and the environment file containing sensitive data
* **Commands**:
This project is managed with a Makefile in the root

    `make` *Builds and starts all services.*

    `make` *down	Stops and removes containers.*

    `make` *fclean	Deletes everything (Images, Volumes, Networks).*

    `make` *re	Full reset and rebuild.*
* **TSL**: use this command to check if TLS is used with the version required `curl -I -k --tlsv1.3 https://kandrian.42.fr`
* **Usage**: Access the website at: https://kandrian.42.fr Check status with: docker ps

## RESOURCES

### Video Tutorials
This two-part series by **Bande de Codeurs** was fundamental to my initiation into the Docker ecosystem:

* **Part 1: [Docker explained in 5 minutes](https://www.youtube.com/watch?v=mspEJzb8LC4)** *A high-level introduction to the core concepts of images, containers, and the importance of environment consistency in software development.*
* **Part 2: [Deploying a Docker environment](https://www.youtube.com/watch?v=ES4BcZcsBdU)** *A practical deep-dive into writing **Dockerfiles** and orchestrating services with **Docker Compose**. It specifically helped me master port mapping, volume persistence, and networking between services.*

###  Official Documentation
* **Docker Docs**: [docs.docker.com](https://docs.docker.com/)  
    *The primary source for understanding container orchestration and security best practices.*
* **WordPress CLI Handbook**: [make.wordpress.org/cli](https://make.wordpress.org/cli/handbook/)  
    *The reference guide used to script the automated installation and configuration of the WordPress site.*
* **MariaDB Knowledge Base**: [mariadb.com/kb](https://mariadb.com/kb/en/library/)  
    *Documentation used for setting up the database environment and managing secure user credentials.*

##  AI Usage

I used Artificial Intelligence (specifically Gemini) as a supportive collaborator throughout this project. My goal was not to bypass the learning process, but to deepen my understanding and solve complex architectural roadblocks.

### Tasks & Contributions
* **Conceptual Learning**: AI helped me break down complex Docker concepts such as the **PID 1** behavior, the difference between **Bridge networks** and host networks, and the lifecycle of a container.
* **Debugging & Troubleshooting**: When services failed to communicate (e.g., WordPress not reaching MariaDB), AI assisted in analyzing logs and suggesting fixes for networking and dependency issues.
* **Code Structuring**: I used AI to brainstorm the most efficient structure for my **Dockerfiles** and to ensure my **Makefile** followed 42's strict requirements.
* **Documentation**: AI helped in drafting and refining this README, ensuring technical terms were used accurately in English.

*AI served as a peer-mentor, providing guidance while I remained the architect and decision-maker of the final infrastructure.*