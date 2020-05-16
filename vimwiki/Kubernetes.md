# Kubernetes Notes

## Sources:

* [Interactive Tutorial — Creating a Cluster](https://kubernetes.io/docs/tutorials/kubernetes-basics/create-cluster/cluster-interactive/)
* [Interactive Tutorial — Deploying an App](https://kubernetes.io/docs/tutorials/kubernetes-basics/deploy-app/deploy-interactive/)
* [Interactive Tutorial — Exploring Your App](https://kubernetes.io/docs/tutorials/kubernetes-basics/explore/explore-interactive/)
* [Interactive Tutorial — Scaling Your App](https://kubernetes.io/docs/tutorials/kubernetes-basics/scale/scale-interactive/)
* [Interactive Tutorial — Updating Your App](https://kubernetes.io/docs/tutorials/kubernetes-basics/update/update-interactive/)

## Glossary

*Config Map*

A Kubernetes object that is used to provide configuration information for workloads. This can either
be fine-grained information (a short string) or a composite vlaue in the form of a file. A ConfigMap
is combined with a Pod right before the Pod is run. It can either create files within the container
filesystem (one for each key, containing the value), set environment variables within the container,
or specify command-line arguments for the main process.

*Daemon Set*

A tool for ensuring a copy of a Pod is running across a set of nodes in a Kubernetes cluster.
Usually, this is desirable when the Pod contains some sort of agent or daemon, hence the name.

*Kubernetes Object*

A RESTful resource contained within Kubernetes. Each Kubernetes object exists at a unique HTTP path;
for example, `https://your-k8s.com/api/v1/namespaces/default/pods/my-pod`. The `kubectl` command
makes HTTP requests to these URLs to access the Kubernetes objects that reside at these paths.

Represented as JSON or YAML files. These files are either returned by the server in response to a
query or posted to the server as part of an API request.

*Deployment* ([source](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/))

An abstraction representing declarative updates for Pods and ReplicaSets. Scaling is accomplished by
changing the number of replicas in a deployment.

*Job*

A Kubernetes object intended for servicing short-lived, one-off tasks rather than long-running
processes. It creates Pods that run until successful termination (i.e., exit with 0). Useful for
database migrations or batch jobs.

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

### Stop the cluster

```sh
minikube stop
```

### Remove the cluster

```sh
minikube delete
```

## Kubectl

Kubectl is the command line interface for Kubernetes.

### Common operations

Any of these can be appended with `--help` to get more information on potential targets and other
options.

```sh
kubectl help     # Show documentation
kubectl get      # List resources
kubectl describe # Show detailed information about a resource
kubectl logs     # Print the logs from a container in a pod
kubectl exec     # Execute a command on a container in a pod
```

### Verify installation

```sh
kubectl version
```

### Get cluster diagnostic

```sh
kubectl get componentstatuses
```

### View cluster details

```sh
kubectl cluster-info
```

### View cluster nodes

```sh
kubectl get nodes
```

### View node details

The following gets a detailed description for node `node-1`

```sh
kubectl describe nodes node-1
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

To overwrite an existing label, use the `--overwrite` flag. Labels can also be deleted by added a
dash suffix (for example, `app-`)

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

### Create a context

This creates a new context called `my-context` with a default namespace of `mystuff`. It will get
recorded in a `kubectl` configuration file, usually located at `$HOME/.kube/config`.

```sh
kubectl config set-context my-context --namespace=mystuff
```

### Use a previously created context

Assuming the `my-context` context has previously been created, you can activate it by running:

```sh
kubectl config use-context my-context
```

### Create/update a Kubernetes object from a file

Assuming the configuration [for](for) the object is contained in `obj.yaml`

```sh
kubectl apply -f obj.yaml
```

### Delete a Kubernetes object

```sh
kubectl delete -f obj.yaml
```

### Imperatively run a pod

This creates a pod called `kuard` using the image `kuard-amd64:1`.

```sh
kubectl run kuard --image=kuard-amd64:1
```

### Set up port forwarding

Port-forwarding can be used to access a pod for debugging. Here, we forward port 8080 on our host to
port 8080 within the `kuard` pod:

```sh
kubectl port-forward kuard 8080:8080
```

### Copy files to and from containers

This copies a file from a pod with a single container to the local file system (in this case,
`capture3.txt`)

```sh
kubectl cp <pod-name>:/captures/capture3.txt ./capture3.txt
```

This copies a file from the local filesystem into a pod with a single container (note that this is
generally an anti-pattern):

```sh
kubectl cp $HOME/config.txt <pod-name>:/config.txt
```

### Using label selectors

These examples are for pods but the same thing applies to deployments and other Kubernetes objects

```sh
kubectl get pods --selector="app=bandicoot,ver=2"
```

```sh
kubectl get pods --selector="app in (alpaca,bandicoot)"
```

### Delete all objects of a particular type

The `--selector` flag can also come in useful

```sh
kubectl delete deployments --all
```

### Create a config map

Assuming a file called `my-config` exists on the filesystem:

```sh
kubectl create configmap my-config \
  --from-file=my-config.txt \
  --from-literal=extra-param=extra-value \
  --from-literal=another-param=another-value
```

### Create a secret

Assuming files called `kuard.crt` and `kuard.key` exist on the filesystem:

```sh
kubectl create secret generic kuard-tls \
  --from-file=kuard.crt \
  --from-file=kuard.key
```

---

## Sample manifest files

### Basic manifest file

```yaml
# kuard-pod.yaml

apiVersion: v1
kind: Pod
metadata:
  name: kuard
spec:
  containers:
    image: kuard-amd64:1
    name: kuard
    ports:
      - containerPort: 8080
        name: http
        protocol: TCP
```

### Manifest file with a liveness probe

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: kuard
spec:
  containers:
    - image: kuard-amd64:1
      name: kuard
      livenessProbe:
        httpGet:
          path: /healthy
          port: 8080
        initialDelaySeconds: 5
        timeoutSeconds: 1
        periodSeconds: 10
        failureThreshold: 3
      ports:
        - containerPort: 8080
          name: http
          protocol: TCP
```

### Manifest file with resource requests and limits

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: kuard
spec:
  containers:
    - image: kuard-amd64:1
      name: kuard
      resources:
        requests:
          cpu: "500m"
          memory: "128Mi"
        limits:
          cpu: "1000m"
          memory: "256Mi"
      ports:
        - containerPort: 8080
          name: http
          protocol: TCP
```

### Manifest file with a volume (persisted storage)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: kuard
spec:
  volumes:
    - name: "kuard-data"
      hostPath:
        path: "/var/lib/kuard"
  containers:
    - image: kuard-amd64:1
      name: kuard
      volumeMounts:
        - mountPath: "/data"
          name: "kuard-data"
      ports:
        - containerPort: 8080
          name: http
          protocol: TCP
```

### Full manifest file for pod

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: kuard
spec:
  volumes:
    - name: "kuard-data"
      nfs:
        server: my.nfs.server.local
        path: "/exports"
  containers:
    - image: kuard-amd64:1
      name: kuard
      ports:
        - containerPort: 8080
          name: http
          protocol: TCP
      resources:
        requests:
          cpu: "500m"
          memory: "128Mi"
        limits:
          cpu: "1000m"
          memory: "256Mi"
      volumeMounts:
        - mountPath: "/data"
          name: "kuard-data"
      livenessProbe:
        httpGet:
          path: /healthy
          port: 8080
        initialDelaySeconds: 5
        timeoutSeconds: 1
        periodSeconds: 10
        failureThreshold: 3
      readinessProbe:
        httpGet:
          path: /ready
          port: 8080
        initialDelaySeconds: 30
        timeoutSeconds: 1
        periodSeconds: 10
        failureThreshold: 3
```

### Minimal ReplicaSet definition

```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: kuard
spec:
  replicas: 1
  selector:
    matchLabels:
      app: kuard
      version: "2"
  template:
    metadata:
      labels:
        app: kuard
        version: "2"
    spec:
      containers:
        - name: kuard
          image: "kuard-amd64:1"
```

### Using a config map

This assumes one has previously been created using the `Create a config map` command.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: kuard-config
spec:
  containers:
    - name: test-container
      image: kuard-amd64:1
      command:
        - "/kuard"
        - "$(EXTRA_PARAM)"
      env:
        - name: ANOTHER_PARAM
          valueFrom:
            configMapKeyRef:
              name: my-config
              key: another-param
        - name: EXTRA_PARAM
          valueFrom:
            configMapKeyRef:
              name: my-config
              key: extra-param
      volumeMounts:
        - name: config-volume
          mountPath:  /config
  volumes:
    - name: config-volume
      configMap:
        name: my-config
  restartPolicy: Never
```

### Manifest file with secrets

This assumes the secret has already been created

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: kuard-tls
spec:
  containers:
    - name: kuard-tls
      image: kuard-amd64:1
      volumeMounts:
        - name: tls-certs
          mountPath: "/tls"
          readOnly: true
  volumes:
    - name: tls-certs
      secret:
        secretName: kuard-tls
```
