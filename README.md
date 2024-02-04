# Deploying an NGINX application with GKE using ArgoCD and Helm Charts

## Introduction 
Deploying an application with Google Kubernetes Engine (GKE) using ArgoCD and Helm Charts involves utilizing Kubernetes for container orchestration, ArgoCD for GitOps-based deployment, and Helm Charts for packaging and managing Kubernetes applications. 

To achieve this, we will be going through the following steps:


## Create a Kubernetes cluster using GKE

### Login & Configure Project Info
```sh
$ gcloud auth login 
$ gcloud config set project <PROJECT_ID>
$ gcloud config set compute/region <COMPUTE_REGION>
```
### create a cluster and get cluster credntials  (autopilot)
The cluster name and project are 'demo-cluster' and 'agrocd-gke-demo' respectively.
```sh
 $ gcloud container clusters create-auto demo-cluster \
    --region us-west1 \
    --project=agrocd-gke-demo
 $ gcloud container clusters get-credentials demo-cluster --region us-west1 --project=agrocd-gke-demo
```
![alt text](http://url/to/img.png)

[Read more on creating an autopilot GKE cluster](https://cloud.google.com/kubernetes-engine/docs/how-to/creating-an-autopilot-cluster)



## Deploy ArgoCD to the cluster and expose the service 

### Add Argo CD Helm repository
To add the Argo CD Helm repository to your local Helm configuration, you can use the following commands: 
```sh
 $ helm repo add argo-cd https://argoproj.github.io/argo-helm
 $ helm repo update
```
This adds the Argo CD Helm repository with the name argo-cd and points it to the official Argo CD Helm charts repository.

After running these commands, you can search for Argo CD charts and install them using Helm. For example, to search for available Argo CD charts, you can use:
```sh
helm search repo argo-cd
```
### Deploy ArgoCD using its Helm Chart
To install Argo CD, you can use a command like this:
```sh
helm install argo-cd argo-cd/argo-cd
```
### Expose the service
making it accessible from outside the cluster, allowing external users or systems to interact with the application or service. 
```sh
$ kubectl patch svc argocd-server -p '{"spec": {"type": "LoadBalancer"}}'
```

### Login to Argo CD
Argo CD web UI using the external IP or domain assigned to the Argo CD service and log in with the default username (admin) and initial password obtained from the server logs with this command :
```sh
 kubectl get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```
```sh
$ 
``` 
alternatively

```sh
$ 
``` 

## Connect to the Github Repo


### Setting up github repo
To integrate a GitHub repository with Argo CD via the web UI, navigate to the Settings tab. Within the Repositories section, choose Connect Repo using HTTPS or SSH. Here, we used HTTPS.
Input the GitHub repository URL and provide the necessary authentication details.



### Syncing Argo CD to your repo
A directory/folder in this repo will be created to point our Argo CD configuration. Argo CD will listen and sync any changes to the manifest files created here.

## Deploying Applications (In our Case NGINX )

## Setting up Argo CD App on it's GUI
Argo CD manages and synchronizes applications with their Git definitions. Customize them based on your deployment and maintenance requirements. 
- Application Name:
Choose a unique name for your application. In this example, 'argo' is used suggested as a convention for the root or main application.

- Project Name:
Specify the Argo CD project name. By default, it's 'default', but you can customize projects to organize and control activities.

- Sync Policy:
Determine the synchronization policy, whether it should sync automatically ('Automatic') or manually ('Manual') from its source. It's set to 'Manual' by default.

- Prune Resources:
Check this option if you want Argo CD to delete resources on the cluster that are no longer defined in Git. By default, it's unchecked.

- Self Heal:
Check this option if you want Argo CD to force the state defined in Git to the cluster, even when the cluster state is different. It ensures alignment.

- Set Deletion Finalizer:
Check this option if you want to add a deletion finalizer to the app. This finalizer deletes both the app and associated resources on the cluster when they are no longer defined in Git.

- Repository URL:
Set the Git repository URL previously configured for your application's manifests.

- Revision:
Specify the Git branch or tag that represents the desired version of your application. Different apps can be set up for different branches or tags based on specific requirements.

- Path:
Define the path within the Git repository where Argo CD should watch for manifest files. This is the directory structure where your Kubernetes manifests are stored. If you've organized manifests into a specific folder, point Argo CD to that path.

- Cluster URL:
Specify the URL of the destination Kubernetes cluster. Typically, this is set to the default cluster, and you would use the Kubernetes API server URL.

- Namespace:
Set the destination namespace in the cluster where you want the application to be deployed. Define the Kubernetes namespace where your application resources should be created.


### Deploying NGINX 
- Locating an NGINX Helm chart. Here we used [artifact hub](https://artifacthub.io/.) to search for the NGINX Helm chart used [nginx](https://artifacthub.io/packages/helm/bitnami/nginx)
use this command to install:
```sh
helm install my-release oci://registry-1.docker.io/bitnamicharts/nginx
```

- Prepare a manifest file and push to the folder you pointed to in the Argo CD cofiguration.
-- This YAML file is a Kubernetes manifest for an Argo CD Application. It defines how Argo CD should manage the deployment of an application named "nginx" in the Kubernetes cluster. Let's break down the key values:
-- apiVersion and kind: These fields specify the Kubernetes API version and kind of the resource, indicating that it's an Argo CD Application.

-- metadata: Metadata about the application, including its name, namespace, and finalizers.

```sh
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: nginx
  namespace: default
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  destination:
    namespace: nginx
    server: https://kubernetes.default.svc
  project: default
  source:
    chart: nginx
    repoURL: https://charts.bitnami.com/bitnami
    targetRevision: 15.10.2
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - CreateNamespace=true
```
