## Installations

### AWS CLI Configure

### Install AWS-CLI in VM . Use any one of the commands below. 

```
sudo apt install awscli
sudo apt-get install awscli
sudo snap install aws-cli --classic
aws --version
```
#### Configure AWS-CLI 

```
aws configure       // Provide access key ID and secrect access key details
```


### Kubectl Installation

Follow this link -- https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/

```
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client
```


### Eksctl Installation

```
udo apt update
sudo apt install curl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
sudo chmod +x /usr/local/bin/eksctl
eksctl version
```

### EKS Cluster Installation

```
eksctl create cluster --name demo-cluster --region us-east-1 
```

## Create deployment, service and ingress 

* Clone the git repo to VM , navigate to project folder and create deployment, service and ingress

```
kubectl apply -f k8s/manifests/deployment.yml
kubectl get deploy     // lists all the deployments created
kubectl get pods        // lists the running pods/containers
kubectl apply -f service.yml
kubectl get svc
kubectl apply -f ingress.yml
kubectl get ing         // list the ingress created
```


* Initially after creating ingress, application cannot be accessed through ingress as the address is not assigned. We need Ingress Controller which assigns address to the Ingress resource. 
* To check if the service is working and application is accessible through the NodePort, expose the service to the NodePort mode. By default service is in "ClusterIP" mode. 
* Edit the service to change type from ClusterIP to NodePort

```
kubectl edit svc go-web-app          // to edit the service. "go-web-app" is the service name
```

* So now service is changed to type "NodePort" , it can be accessed at some port on node IP address. 

```
kubectl get nodes -o wide           // command to get the complete information of running nodes along with external IPs
```

Application can be accessed on the " nodeip address:nodeport/courses " . Node = EC2 instances

```
kubectl get endpoints           // shows end points of the nodes

kubectl describe pod <podname>         // shows complete info of a pod

kubectl logs <podname>           // to get pod logs
```

```
sudo iptables -n -L         // lists the firewall access to ports
sudo iptables -A INPUT -p tcp --dport <port number> -j ACCEPT       // Adds a specific port to firewall to allow its access    
```


### Create Ingress Controller

* IN AWS Nginx Ingress Controller creates Network LB

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.1/deploy/static/provider/aws/deploy.yaml
```
There are 3 parts in the Ingress
1. Ingress resource
2. Ingress Controller  (IC)
3. Load Balancer      (LB)

IC watches the Ingress resource and creates LB. We write a ingress resource to create LB. IC is a go program written by Load Balance company.
IC creates LB as per the ingress resource configuration.

```
kubectl get ing      // lists the ingress resources and ingress controller
kubectl get pods -n ingress-nginx          // lists the ingress nginx controller . -n <namespace>
``` 


```
 nslookup a6ff5cc00be4f44acbcbfff8a58b0684-7485465aa5063d9e.elb.us-east-1.amazonaws.com        // To find the IP address through the DNS name created by LB
```

* Now map the IP address with the host name specified in ingress resource (ingress.yml)

```
sudo vim /etc/hosts      // give NLB IP address with DNS name
```

## Helm Installation

Follow these steps

```
curl -O https://get.helm.sh/helm-v3.16.2-linux-amd64.tar.gz
tar xvf helm-v3.16.2-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin
rm helm-v3.16.2-linux-amd64.tar.gz
rm -rf linux-amd64
helm version
```

create a folder called 'helm' inside the project repo. Navigate to the folder helm and run below command to create helm chart

```
helm create go-web-app-chart
```

* The advantage of helm is, we can variabalize the yaml files inside helm , templates folder.
* In the values.yml , the tag value will be dynamically updated with latest image created in CI
* Using Argo CD , that latest image will be automatically deployed.

### Install helm chart 
```
helm install go-web-app ./go-web-app-chart
```
* This command is used to install a Helm chart, which is a package manager for Kubernetes.
Here's what each part of the command does:

**helm install**
* helm is the command-line tool for Helm. install is the subcommand that installs a new release from a chart.

**go-web-app**
* This is the name of the release that will be created. In Helm, a release is an instance of a chart that has been installed on a Kubernetes cluster.

**./go-web-app-chart**
* This is the path to the Helm chart that will be installed. The ./ indicates that the chart is located in the current working directory.
* go-web-app-chart is the name of the chart directory, which contains the chart's configuration files, templates, and other resources.

**What happens when you run the command?**
When you run **helm install go-web-app ./go-web-app-chart**, Helm will:

* **Validate the chart**: Helm will check the chart's configuration files and templates for errors.
* **Create a new release**: Helm will create a new release named go-web-app in the Kubernetes cluster.
* **Install the chart**: Helm will install the chart's resources, such as deployments, services, and pods, into the Kubernetes cluster.
* **Configure the release**: Helm will configure the release with the values specified in the chart's values.yaml file.

After the installation is complete, you can verify the status of the release using 
```
helm status go-web-app
```
Once helm chart created release "go-web-app" , then we can get the kubernetes resources created using the below commands

```
kubectl get all
kubectl get deploy
kubectl get svc
kubectl get pods
kubectl get ing
```

#### Delete Helm reosurces
```
helm uninstall go-web-app          // deletes the helm resources
```



## CI Part 
CI/CD -- When a developer commits a change/creates a PR, the CI/CD Pipeline is triggered. As part of CI, we will run multiple stages 
Now implementing CI using Github Actions
Its done in multiple stages 
1. Build & Test stage
2. Static Code analysis
3. Create Docker image and push docker image to Docker registry
4. Update Helm chart with docker image tag. In values.yaml file in Helm , image tag is automatically updated whenever new image is created

Before starting the CI pipeline in github actions, 
* Create a folder ".github/workflows" 
* Create a file - ci.yaml
Write work flow code

Use below github actions Marketplace documentation to write cicd.yaml file github actions
#### https://github.com/marketplace

**Steps to provide secrets of dockerhub in Github for login to dockerhub to push the image**
* github repo page -> Setting -> Secrets and Variables -> Actions -> New Repository secrets -> Add secret Name as 'DOCKERHUB_USERNAME' , give dockerhub username into the Secret .
* Give DOCKERHUB_TOKEN -> Copy the secret token from DockerHub

**To generate Dockerhub token **
* Login to Dockerhub -> Account Settings -> Personal Access Tokens -> Generate new Token -> Give token description -> Give Access permissions as 'Read&Write' ->Generate -> Copy and paste token in Github actions Secrets 

* Using these dockerhub username and token, the updated docker image is pushed to dockerhub

* Once the values.yaml file in helm chart is updated with the new image tag, then the updated helm chart is pushed back to github repository. For that we need github secrect token.
To generate github secret token --> go to github repo -> setting -> secrets and variable -> New repository secret -> Give name as 'TOKEN' , Give github Personal Access Token' 

To generate Github Personal Access Token  
--> github -> Setting -> Developer Setting -> Personal access tokens ->  Tokens(classic) -> Generate new token (classic) 




## CD Part
For CD part , I am using GitOps using Argo CD
1. Argo CD pulls Helm chart and deploys it to K8S Cluster (EKS) . If helm chart is already there, Argo CD updates the image with new tag created.



 



