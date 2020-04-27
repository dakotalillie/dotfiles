# Kubernetes Notes

## Sources:

* [Interactive Tutorial — Creating a Cluster](https://kubernetes.io/docs/tutorials/kubernetes-basics/create-cluster/cluster-interactive/)
* [Interactive Tutorial — Deploying an App](https://kubernetes.io/docs/tutorials/kubernetes-basics/deploy-app/deploy-interactive/)
* [Interactive Tutorial — Exploring Your App](https://kubernetes.io/docs/tutorials/kubernetes-basics/explore/explore-interactive/)
* [Interactive Tutorial — Scaling Your App](https://kubernetes.io/docs/tutorials/kubernetes-basics/scale/scale-interactive/)
* [Interactive Tutorial — Updating Your App](https://kubernetes.io/docs/tutorials/kubernetes-basics/update/update-interactive/)

## Glossary

*Deployment* ([source](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/))

An abstraction representing declarative updates for Pods and ReplicaSets. Scaling is accomplished by
changing the number of replicas in a deployment.

*Replica Set* ([source](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/))

Something which maintains a stable set of replica Pods running at any given time. Used to guarantee
the availability of a specific number of identical Pods.

*Service* ([source](https://kubernetes.io/docs/concepts/services-networking/service/))

An abstraction that defines a logical set of Pods and a policy by which to address them. Allows
applications to receive traffic, and enables loose coupling between dependent pods. Defined
using YAML or JSON (YAML is preferred). There are various kinds of services:

* ClusterIP (default) - Exposes the Service on an internal IP in the cluster. This type makes
  the Service only reachable from within the cluster.
* NodePort - Exposes the Service on the same port of each selected Node in the cluster using
  NAT. Makes a Service accessible from outside the cluster using <NodeIP>:<NodePort>. Superset
  of ClusterIP.
* LoadBalancer - Creates an external load balancer in the current cloud (if supported) and
  assigns a fixed, external IP to the Service. Superset of NodePort.
* ExternalName - Exposes the Service using an arbitrary name (specified by externalName in the
  spec) by returning a CNAME record with the name. No proxy is used. This type requires v1.7 or
  higher of kube-dns.

Services have an integrated load-balancer that will distribute network traffic to all Pods of an
exposed Deployment.

More information can be found [here](https://kubernetes.io/docs/tutorials/services/source-ip/) and [here](https://kubernetes.io/docs/concepts/services-networking/connect-applications-service).

## Minikube

Minikube is a basic kubernetes setup with a single node.

### Verify installation

```sh
minikube version
```

### Start the cluster

```sh
minikube start
```

## Kubectl

Kubectl is the command line interface for Kubernetes.

### Common operations

Any of these can be appended with `--help` to get more information on potential targets and other
options.

```sh
kubectl get      # list resources
kubectl describe # Show detailed information about a resource
kubectl logs     # Print the logs from a container in a pod
kubectl exec     # Execute a command on a container in a pod
```

### Verify installation

```sh
kubectl version
```

### View cluster details

```sh
kubectl cluster-info
```

### View cluster nodes

```sh
kubectl get nodes
```

### Create a deployment

Here we are creating a deployment with the name `kubernetes-bootcamp` and pointing to a particular
container image. The full repository url is necessary here because it is hosted outside of Docker
hub:

```sh
kubectl create deployment kubernetes-bootcamp --image=gcr.io/google-samples/kubernetes-bootcamp:v1
```

This does a few things:

* Search for a suitable node where an instance of the application could be run
* Schedule the application to run on that Node
* Configure the cluster to reschedule the instance on a new Node when needed

### List deployments

```sh
kubectl get deployments
```

### View ReplicaSet created by the Deployment

```sh
kubectl get rs
```

### Start a proxy

Pods that are running inside Kubernetes are running on a private, isolated network. By default they
are visible from other pods and services within the same kubernetes cluster, but not outside that
network. By running this command, we can create a proxy that will forward communications into the
cluster-wide, private network:

```sh
kubectl proxy
```

### Get a pod name and make a request to it

This requires that the proxy be running

```sh
export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
curl http://localhost:8001/api/v1/namespaces/default/pods/$POD_NAME/proxy/
```

### Create a new service and expose to external traffic

This creates a new service called `kubernetes-bootcamp` which references a deployment (also called
`kubernetes-bootcamp`), sets the type to `NodePort`, and specifies the open port as 8080. After
doing this, you'll no longer need to run a proxy to access the Pods.

```sh
kubectl expose deployment/kubernetes-bootcamp --type="NodePort" --port 8080
```

### Apply a label to a Pod

```sh
kubectl label pod $POD_NAME app=v1
```

### Scale a Deployment

```sh
kubectl scale deployments/kubernetes-bootcamp --replicas=4
```

### Update Pod images

```sh
kubectl set image deployments/kubernetes-bootcamp kubernetes-bootcamp=jocatalin/kubernetes-bootcamp:v2
```

### Check rolling update status

```sh
kubectl rollout status deployments/kubernetes-bootcamp
```

### Rollback an update

```sh
kubectl rollout undo deployments/kubernetes-bootcamp
```

