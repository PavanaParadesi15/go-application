## Go Web Application

This is a simple website written in Golang. It uses the net/http package to serve HTTP requests.
### Running the server on a EC2 instance

Clone the repository 
To build the binary 
```
go build -o main .
```
To run the server, execute the following command:
```
go run main.go 
```
OR 
```
./main
```
The server will start on port 8080. You can access it by navigating to http://ec2instanceip:8080/courses in your web browser.
Looks like this

![image](https://github.com/user-attachments/assets/943ed58b-cd3f-4126-ac9c-39431f22b180)

Next containarize the application using Docker


### Initial Steps we have to do for a project to implement DevOps 
#### 1. Containerize the Project  
* Write a multi-stage Docker , with images with less size and improved security
#### 2. Create K8s Manifests
* Create manifests like Service, Deployment and Ingress
#### 3. Set up CI 
* Use Github Actions for CI
#### 4. Set up CD
* Using GitOps - ArgoCD for Continuous Deployment
#### 5. Set target K8S platform
* CI/CD has to deploy application on a target K8s Cluster, we are using EKS Cluster .
* Create EKS cluster through terminal
#### 6. Setup HELM chart
* Helm charts are one time solution if we need to deploy application onto multiple environments in future like Pre-Prod , PROD
* We can use same Helm charts and just change values through values.yml
* Setup Ingress Controller , which creates Load Balancer depending on the Ingress configuration and make application exposed to public
* Map Load balancer IP address to local DNS, to check if application is accessible from outside world

###############################################################################################




## Docker File

### Multi-stage Docker File
* In stage 1 , we build docker image using a base image, download dependencies and application is built
* In stage 2 or final stage, use Distroless image as base image. Distroless image reduced image and adds security
* Copy the binary built in stage 1 and expose port and rum application


## Deployment file

* deployment.yml file defines a Kubernetes deployment that will create a multiple replicas of a pod running a container based on the go-web-app Docker image.
* In Kubernetes, a deployment.yml file is a YAML file that defines a Deployment resource. A Deployment is a Kubernetes object that manages the rollout of new versions of an application.

Here's a breakdown of what a deployment.yml file typically contains:

#### Key Components

**API Version and Kind:** Specifies the version of the Kubernetes API and the type of resource being defined (in this case, a Deployment).

**Metadata:** Provides metadata about the Deployment, such as its name, labels, and annotations.

**Spec:** Defines the desired state of the Deployment, including the container(s) to run, the number of replicas, and the strategy for rolling out updates.

**Selector:** Specifies the label selector that identifies the pods managed by this Deployment.

### Why Use a Deployment?

#### A Deployment provides several benefits, including:

**Rolling Updates:** Deployments allow you to roll out new versions of your application incrementally, reducing downtime and risk.

**Self-Healing:** If a pod managed by a Deployment crashes or becomes unresponsive, the Deployment will automatically replace it with a new pod.

**Scalability:** Deployments make it easy to scale your application horizontally by adding or removing replicas.

**Version Management:** Deployments provide a way to manage different versions of your application, making it easier to roll back to a previous version if needed. 

