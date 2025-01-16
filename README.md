## Go Web Application

This is a simple website written in Golang. It uses the net/http package to serve HTTP requests.
### Running the server

To run the server, execute the following command:
```
go run main.go
```
The server will start on port 8080. You can access it by navigating to http://localhost:8080/courses in your web browser.
Looks like this





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
* CI/CD has to deploy application on a target K8s Cluster, EKS Cluster
#### 6. Setup HELM chart
* Helm charts are one time solution if we need to deploy application onto multiple environments in future like Pre-Prod , PROD
* We can use same Helm charts and just change values through values.yml
* Setup Ingress Controller , which creates Load Balancer depending on the Ingress configuration and make application exposed to public
* Map Load balancer IP address to local DNS, to check if application is accessible from outside world


