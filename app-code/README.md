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
