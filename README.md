# Deploying an application with GKE using ArgoCD and Helm Charts

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
### create a cluster (autopilot)
The cluster name and project are 'demo-cluster' and 'agrocd-gke-demo' respectively.
```sh
 $ gcloud container clusters create-auto demo-cluster \
    --region us-west1 \
    --project=agrocd-gke-demo
```

[Read more on creating an autopilot GKE cluster](https://cloud.google.com/kubernetes-engine/docs/how-to/creating-an-autopilot-cluster)



## Deploy ArgoCD to the cluster and expose the service 

### 

### 

### 

#### 


```sh
$ 
``` 
alternatively

```sh
$ 
``` 

## Connect to the Github Repo