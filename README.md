# Netflix Clone Deployment with Azure, Bicep, Jenkins, Docker, and Kubernetes

## Table of Contents
1. [Overview](#overview)
2. [Key Technologies and Tools](#key-technologies-and-tools)
3. [Getting Started](#getting-started)
4. [Installation](#installation)
5. [Usage](#usage)
6. [Contributing](#contributing)
7. [License](#license)
8. [Contact](#contact)

## Overview

This project aims to deploy a Netflix clone application using modern DevOps practices and tools. I will utilise Azure for cloud infrastructure, Bicep for infrastructure as code, Jenkins for continuous integration and continuous deployment (CI/CD), Docker for containerisation, and Kubernetes for container orchestration. Additionally, I will monitor Jenkins and Kubernetes metrics using Grafana, Prometheus, and Node exporter.

### Key Technologies and Tools

- Azure
- Bicep
- Powershell
- Jenkins
- Docker
- Kubernetes
- Grafana
- Prometheus
- Node Exporter

## Getting Started

To get started with deploying the Netflix clone application, follow these steps:

### Prerequisites

1. Install Azure CLI: [Azure CLI Installation Guide](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
2. Install Bicep CLI: [Bicep Installation Guide](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/install)
3. Set up a Kubernetes cluster on Azure: [Azure Kubernetes Service (AKS) Documentation](https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough)

### Installation

1. Clone this repository:

    ```bash
    git clone https://github.com/yourusername/netflix-clone.git
    cd netflix-clone
    ```

2. Initialize Bicep and deploy infrastructure:

    ```bash
    az bicep build -f main.bicep
    az deployment sub create -f main.bicep
    ```

    This command will build the Bicep template and deploy the infrastructure to Azure. The deployment process may take some time to complete.

3. Set up Jenkins:

    - Install Jenkins on Azure VM or Kubernetes cluster.
    - Configure Jenkins pipeline to build and deploy Netflix clone application.
    - For detailed instructions on setting up Jenkins, refer to the [Jenkins Installation Guide](https://jenkins.io/doc/book/installing/) and [Jenkins Pipeline Tutorial](https://jenkins.io/doc/pipeline/tour/).

4. Build and deploy Docker container:

    - Set up Dockerfile to build Netflix clone application.
    - Build Docker image and push to Docker Hub or Azure Container Registry.
    - Deploy Docker container to Kubernetes cluster.
    - For detailed instructions on building and deploying Docker containers, refer to the [Docker Documentation](https://docs.docker.com/) and [Kubernetes Deployment Guide](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/).

5. Set up monitoring with Grafana and Prometheus:

    - Deploy Prometheus server on Kubernetes.
    - Deploy Node Exporter for collecting host-level metrics.
    - Configure Grafana dashboards for monitoring Jenkins and Kubernetes metrics.
    - For detailed instructions on setting up monitoring, refer to the [Prometheus Documentation](https://prometheus.io/docs/) and [Grafana Documentation](https://grafana.com/docs/).

## Usage

- Once the deployment is completed, access the Netflix clone application through the provided URL.
- Monitor Jenkins and Kubernetes metrics using Grafana dashboards.

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature`).
3. Make your changes.
4. Commit your changes (`git commit -am 'Add feature'`).
5. Push to the branch (`git push origin feature`).
6. Create a new Pull Request.

## License

This project is licensed under the [MIT License](LICENSE).
