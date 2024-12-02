Dynamic Load Balancer with Monitoring

This project implements a dynamic load balancing system using Docker Compose with OpenResty as the load balancer. It includes a monitoring stack with Prometheus, Grafana, and Node Exporter to visualize metrics and monitor the services.
Features

    Dynamic Load Balancer: OpenResty configured as a reverse proxy to route traffic between Flask microservices.
    Microservices: Three Flask-based services (server_1, server_2, server_3) running behind the load balancer.
    Monitoring Stack:
        Prometheus: Collects metrics from the services.
        Grafana: Provides dashboards to visualize metrics.
        Node Exporter: Exposes system-level metrics for Prometheus.

Prerequisites

    Docker (>= 20.x)
    Docker Compose (>= 2.x)
    Basic knowledge of Docker and networking.

Setup and Installation
Clone the Repository

git clone https://github.com/yourusername/dynamic-loadbalancer.git
cd dynamic-loadbalancer

Directory Structure

.
├── docker-compose.yml
├── prometheus.yml       # Configuration for Prometheus
├── server_1/
│   ├── Dockerfile
│   └── server.py        # Flask app for server_1
├── server_2/
│   ├── Dockerfile
│   └── server.py        # Flask app for server_2
├── server_3/
│   ├── Dockerfile
│   └── server.py        # Flask app for server_3
├── openresty/
│   ├── Dockerfile
│   └── nginx.conf       # Configuration for OpenResty
└── README.md

Creating Custom Flask App Images

The docker-compose.yml file references custom Flask application images: my-flask-app-1, my-flask-app-2, and my-flask-app-3. These images need to be built from the respective Dockerfiles in the server_1, server_2, and server_3 directories.
Steps to Create the Flask App Images:

    Navigate to each server directory:
        For server_1:

    cd server_1

Build the Docker image for server_1:

docker build -t my-flask-app-1 .

Repeat for server_2 and server_3:

    For server_2:

cd ../server_2
docker build -t my-flask-app-2 .

For server_3:

    cd ../server_3
    docker build -t my-flask-app-3 .

Verify the images: After building the images, you can confirm they exist by listing the Docker images:

    docker images

    You should see my-flask-app-1, my-flask-app-2, and my-flask-app-3 in the list.

Build and Start the Services

    Build the Docker images for all services (including the Flask apps, Prometheus, and Grafana):

docker compose build

Start all services:

docker compose up -d

Verify the running containers:

    docker ps

Access the Services

    Load Balancer:
    Open your browser and visit http://localhost to access the load balancer.

    Prometheus:
    Visit http://localhost:9090 for Prometheus UI.

    Grafana:
    Visit http://localhost:3000 for Grafana UI.
    Default credentials:
        Username: admin
        Password: admin

    Node Exporter:
    Metrics are exposed at http://localhost:9100/metrics.

Configuration Details
Prometheus Configuration

The prometheus.yml file defines scrape targets for:

    Prometheus itself (localhost:9090)
    Node Exporter (localhost:9100)

Grafana Dashboards

You can import JSON files into Grafana to set up dashboards for monitoring metrics.
Load Balancer (OpenResty)

The nginx.conf file under openresty/ configures the dynamic load balancer.
Stopping the Services

To stop and remove all services and volumes:

docker compose down --volumes

Troubleshooting

    Image Not Found: Ensure all custom services (server_1, server_2, server_3) are built locally or update docker-compose.yml with the correct build paths.
    Access Issues: Verify ports are not in use by other processes.
    Logs: Use docker compose logs -f to view logs for debugging.

Contributing

Feel free to submit issues and pull requests to improve this project.
License

This project is licensed under the MIT License.
