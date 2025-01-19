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





