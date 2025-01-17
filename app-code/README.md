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
