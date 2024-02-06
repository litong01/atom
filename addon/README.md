# To register a cluster to ACS or ACC

1. Use the ACS/ACC api token to create a secret
```
  kubectl create secret generic astra-token -n astra-connector
      --from-literal=apiToken=${APITOKEN} 
```
2. If astra connector images are secured, create an image pull secret
```
  kubectl create secret docker-registry regcred
    --docker-username=tli --docker-password=${REG_TOKEN} 
    --docker-server=netappdownloads.jfrog.io -n astra-connector
```
3. Create astra connector CR, name it myac.yaml
```
apiVersion: astra.netapp.io/v1
kind: AstraConnector
metadata:
  name: astra-connector
  namespace: astra-connector
spec:
  astra:
    accountId: 5049e083-9b48-43d0-9227-09e7f6a8474e
    cloudId: ""
    clusterId: ""
    clusterName: tong-test-cluster
    skipTLSValidation: true
    tokenRef: astra-token
  astraConnect:
    image: latest
  autoSupport:
    enrolled: true
    url: https://stagesupport.netapp.com/put/AsupPut
  imageRegistry:
    name: netappdownloads.jfrog.io/docker-astra-control-staging/arch30/neptune
    secret: regcred
  nats:
    image: nats:2.8.4-alpine3.15
  natsSyncClient:
    cloudBridgeURL: https://integration.astra.netapp.io
    hostAliasIP: 136.54.54.62
    image: natssync-client:2.1.202309262120
  neptune:
    image: latest
  skipPreCheck: true
```
4. Apply the astra connector CR to astra-connector namespace
```
  kubectl -n astra-connector apply -f myac.yaml
```