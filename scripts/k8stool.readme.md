# k8stools

1. Set up k8s cluster using k8stool tool.

```
    k8stool clusters
    k8stool image
    k8stool image --source-tag astra-py-k8s:v0.0.6 
    k8stool cert --namespace "neptune-system" --cluster-name astra
```
Note #1: this step creates k8s cluser, load up necessary images, and create traefik tls cert.

Note #2: If you are running Astra using free docker account, you may need to load the
following images to each cluster due to the pull limits of free docker account before
deploying ACS after your cluster got created.

```
k8stool image --load-or-push true --source-tag zcube/bitnami-compat-mongodb:5.0.14
k8stool image --load-or-push true --source-tag theotw/httpproxy-server:0.9.202202170408
k8stool image --load-or-push true --source-tag nats:2.8.4-alpine3.15
k8stool image --load-or-push true --source-tag traefik:2.9.1
```

2. Set up environment variables

```
export DEPLOY_TYPE=dev
export VAULT_ADDR="http://vault.openenglab.netapp.com"

export GITHUB_USERNAME="First Last"
export GITHUB_TOKEN=<****************>
export GITHUB_ID=<id>

export CREDS_AUTH_CLIENT_ID=<*******>
export CREDS_AUTH_DOMAIN=staging-netapp-cloud-account.auth0.com
export CREDS_ISSUER_URL=https://staging-netapp-cloud-account.auth0.com/

```

3. Install ACS by running the following command

```
  KUBE_CONTEXT=kind-astra SKIP_KUBE_CONTEXT_CHECK=true IMAGE_HOST=localhost:5001 \
  make helminstall DEPLOY_TARGET=cicd \
  CLUSTER_ENDPOINT=integration.astra.netapp.io \
  TRAEFIK_ENDPOINT=integration.astra.netapp.io \
  HELMOVERRIDE='--set mongodb.image.repository=zcube/bitnami-compat-mongodb --set mongodb.image.tag=5.0.14'
```
4. Install traefik by running the following command

```
KUBE_CONTEXT=kind-astra SKIP_KUBE_CONTEXT_CHECK=true \
  make traefikinstall DEPLOY_TARGET=local \
  CLUSTER_ENDPOINT=integration.astra.netapp.io \
  TRAEFIK_ENDPOINT=integration.astra.netapp.io NAMESPACE="neptune-system"
```
5. Run post install script, make sure scripts/beta/auth2.json file match your credential
from BlueXP. Also make sure that your env is on intranet.
```
   scripts/post_install.sh
```

6. Run oproxy to expose port 80 and 443
```
   k8stool proxy --targetports "traefik 80 443"
```

7. Access ACS at the following url
```
   https://integration.astra.netapp.io/
```

8. Cleanup everything

```
   k8stool proxy -d
   k8stool clusters -d
```
Notes: If you like to reuse image repository, you can just remove the cluster
and leave the image repo intact by using the following command:
```
   k8stool cluster -d
```
