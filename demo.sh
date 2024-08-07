#!/bin/bash
# Define some colors
ColorOff='\033[0m'        # Text Reset
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green



function waitForRS() {
  local namespace=$1
  local rs=$2
 
  timeout=60
  interval=2
  elapsed=0
  query=$(kubectl get -n $namespace $rs -o jsonpath='{.metadata.name}' 2>/dev/null)
  while [[ "${query}" == "" ]]; do
    if [[ $elapsed -ge $timeout ]]; then
      echo "Timeout waiting for ${rs} in ${namespace} to become available"
      return
    fi
    sleep $interval
    elapsed=$((elapsed + interval))
  done
}

echo -e "${Green}Removing quark operator from atom-quark namespace...${ColorOff}"
helm uninstall quark-operator -n atom-quark

echo -e "${Green}Deploy quark operator to quark-system...${ColorOff}"
# deploy operator to quark-system namespace
/Users/tli/hl/src/github.com/volume-controller/bin/newnvcclientcli reconcile operator \
		-N quark-system \
		-C /Users/tli/.kube/config \
		-v tli-88b95e9b \
		--override images.globalRegistry=us.gcr.io/netapp-hcl \
		--override images.quarkop.digest= \
		--override images.imagePullPolicy=Always \
		--override containerParameters.debug=true \
		--override containerParameters.enableBucket=true \
		--override gcov.enabled=false

echo -e "${Green}Waiting for quark operator to be available...${ColorOff}"
kubectl -n quark-system wait deploy/quark-operator --for condition=Available --timeout=120s

echo -e "${Green}Deploy quark to quark-system...${ColorOff}"
# deploy quark to quark-system namespace
/Users/tli/hl/src/github.com/volume-controller/bin/newnvcclientcli reconcile quarkCR \
	-N quark-system		\
	-C /Users/tli/.kube/config \
	--override images.quark.tag=3640b9ab \
	--override images.ontap.tag=3640b9ab \
	--override quarkVersion=dev-7222031-non-debug \
	--cloud gcp \
	--override project.tenantProjectNumber=1047111997442 \
	--variant internal \
	--regional true \
	--override debug=true \
    --override darkContent=false \
    --override featureFlags.enableMultiTenancy=true \
    --override featureFlags.enableGcp1p=true \
    --override featureFlags.disableDiskPacking=false \
    --override featureFlags.enableEtcdCostReduction=true \
    --override featureFlags.enableAzureTp=false \
    --override featureFlags.enableIntegratedBackup=false \
    --override featureFlags.enableGranularLiveness=true \
    --override featureFlags.enableThinProvisioningTuning=false \
    --override featureFlags.enableServiceMesh=false \
    --override featureFlags.rightSize=true \
    --override featureFlags.nodevol=true \
    --override featureFlags.enableSWIFTNetworking=false \
    --override devFeatureFlagsString="" \
    --override project.clusterName=tli-nvc-cluster \
    --override project.customerProjectNumber=tli \
    --override project.tenantProjectNumber="1047111997442" \
    --override controllerConfig.variant="internal" \
    --override controllerConfig.etcdClusterSize="3" \
    --override aksProject.azureCustomerSubscriptionId="" \
    --override aksProject.azureCustomerResourceGroup="tli-nvc" \
    --override logging.url=localhost \
    --override logging.output=stdout \
    --override volume.minPVCSize=1073741824 \
    --override volume.maxPVCSize=70368744177664 \
    --override volume.minDataPVCs=1 \
    --override featureFlags.nodevol=true \
    --override ilb.subnet=https://www.googleapis.com/compute/v1/projects/quark-dev-234914/regions/us-east1/subnetworks/quark-dev-producer-us-east1-ilb \
    --override ilb.protocol=BOTH \
    --override images.imagePullPolicy=Always \
    --override images.quark.registry=us.gcr.io/netapp-hcl \
    --override images.ontap.registry=us.gcr.io/netapp-hcl \
    --override images.external.registry=us.gcr.io/netapp-hcl \
    --override images.quark.tag= \
    --override images.quark.podrick.tag=tli-88b95e9b \
    --override images.quark.nvc.tag=tli-88b95e9b \
    --override images.quark.nsc.tag=tli-88b95e9b \
    --override images.quark.csc.tag=tli-88b95e9b \
    --override images.quark.nhc.tag=tli-88b95e9b \
    --override images.quark.nodeMonitor.tag=tli-88b95e9b \
    --override images.quark.nodevolWorker.tag=tli-88b95e9b \
    --override images.quark.nodevolController.tag=tli-88b95e9b \
    --override images.quark.svcmeshctrl.tag=tli-88b95e9b \
    --override images.ontap.tag= \
    --override images.ontap.dmap.tag=dev-7222031-non-debug \
    --override images.ontap.secd.tag=dev-7222031-non-debug \
    --override images.ontap.ccpd.tag=dev-7222031-non-debug \
    --override images.quark.snc.tag=tli-88b95e9b

echo -e "${Green}Waiting for quark to be available...${ColorOff}"
waitForRS quark-system deployment/netapp-volume-controller
kubectl -n quark-system wait deployment/netapp-volume-controller --for condition=Available --timeout=120s

echo -e "${Green}Moving etcd-client-tls-cert from atom-quark to quark-system...${ColorOff}"
kubectl get secret etcd-client-tls-cert -n atom-quark -o yaml | sed 's/namespace: atom-quark/namespace: quark-system/g' | kubectl apply -f -

echo -e "${Green}Moving ha-heartbeat-server-tls-cert from atom-quark to quark-system...${ColorOff}"
kubectl get secret ha-heartbeat-server-tls-cert -n atom-quark -o yaml | sed 's/namespace: atom-quark/namespace: quark-system/g' | kubectl apply -f -

echo -e "${Green}Moving netapp-volume-controller-role from atom-quark to quark-system...${ColorOff}"
kubectl get role netapp-volume-controller-role -n atom-quark -o yaml | sed 's/namespace: atom-quark/namespace: quark-system/g' | kubectl apply -f -

echo -e "${Green}Moving netapp-volume-controller-binding from atom-quark to quark-system...${ColorOff}"
kubectl get rolebinding netapp-volume-controller-binding -n atom-quark -o yaml | sed 's/namespace: atom-quark/namespace: quark-system/g' | kubectl apply -f -


echo -e "${Green}Removing old quark from atom-quark namespace...${ColorOff}"
helm uninstall quark -n atom-quark
echo -e "${Green}Waiting for old quark to be removed...${ColorOff}"
kubectl wait --for=delete -n atom-quark pod -l app=netapp-volume-controller --timeout=60s


echo -e "${Green}Annotate service account netapp-volume-controller-account...${ColorOff}"
waitForRS quark-system serviceaccount/netapp-volume-controller-account
kubectl annotate serviceaccount netapp-volume-controller-account --namespace quark-system \
  iam.gke.io/gcp-service-account=nvc-service-account@quark-dev-234914.iam.gserviceaccount.com

echo -e "${Green}Copy configmaps from quark-system to atom-quark...${ColorOff}"
waitForRS quark-system configmaps/supportability-config
kubectl get configmap supportability-config -n quark-system -o yaml | sed 's/namespace: quark-system/namespace: atom-quark/g' | kubectl apply -f -

waitForRS quark-system configmaps/exporter-config
kubectl get configmap exporter-config -n quark-system -o yaml | sed 's/namespace: quark-system/namespace: atom-quark/g' | kubectl apply -f -

waitForRS quark-system configmaps/fluentbit-sidecar-config
kubectl get configmap fluentbit-sidecar-config -n quark-system -o yaml | sed 's/namespace: quark-system/namespace: atom-quark/g' | kubectl apply -f -

echo -e "${Green}Copy netapp-quark-role and its role bindings from quark-system to atom-quark...${ColorOff}"
kubectl -n atom-quark create serviceaccount netapp-quark-account
kubectl get role  netapp-quark-role -n quark-system -o yaml | sed 's/namespace: quark-system/namespace: atom-quark/g' | kubectl apply -f -
kubectl get rolebindings netapp-quark-role-binding -n quark-system -o yaml | sed 's/namespace: quark-system/namespace: atom-quark/g' | kubectl apply -f -


