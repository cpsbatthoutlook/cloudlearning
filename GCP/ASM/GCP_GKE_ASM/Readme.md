ServiceMesh

https://www.cloudskillsboost.google/focuses/8459?parent=catalog
https://cloud.google.com/products/service-mesh?hl=en


### GKE cluster install
PR=""
gc auth list
gc config set project


export PROJECT_ID=$(gcloud config get-value project)
export PR=$(gcloud config get-value project)
export PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} \
    --format="value(projectNumber)")
export CLUSTER_NAME=central
export CLUSTER_ZONE=us-east1-c
export WORKLOAD_POOL=${PROJECT_ID}.svc.id.goog
export MESH_ID="proj-${PROJECT_NUMBER}"
#
alias kc='kubectl '


gcloud projects get-iam-policy $PROJECT_ID \
    --flatten="bindings[].members" \
    --filter="bindings.members:user:$(gcloud config get-value core/account 2>/dev/null)"

#### Give required access
for x in iam.serviceAccountAdmin iam.serviceAccountKeyAdmin container.admin resourcemanager.projectIamAdmin;do
echo gcpaiampb $PR --member='user:student-00-44005bb9e240@qwiklabs.net'  --role="roles/${x}"
done


gcloud config set compute/zone ${CLUSTER_ZONE}
gcloud container clusters create ${CLUSTER_NAME} \
 --machine-type=e2-standard-4  --num-nodes=3 --subnetwork=default \
 --release-channel=regular --labels mesh_id=${MESH_ID} --workload-pool=${WORKLOAD_POOL} --logging=SYSTEM,WORKLOAD




gc config set compute/zone 
kc create clusterrolebinding cluster-admin-binding   --clusterrole=cluster-admin   --user=$(whoami)@qwiklabs.net 
gc container clusters get-credentials $CLUSTER_NAME --zone $CLUSTER_ZONE  --project $PR



### ASM { Cloud Service Mesh }

curl https://storage.googleapis.com/csm-artifacts/asm/asmcli_1.20 > asmcli
chmod +x asmcli
gc services enable mesh.googleapis.com

#### Validate ASM

./asmcli validate   --project_id $PR --cluster_name $CLUSTER_NAME \
  --cluster_location $CLUSTER_ZONE  --fleet_id $PROJECT_ID  --output_dir ./asm_output

#### Instatll ASM
./asmcli install --project_id $PR --cluster_name $CLUSTER_NAME \
  --cluster_location $CLUSTER_ZONE  --fleet_id $PROJECT_ID  --output_dir ./asm_output \
  --enable_all  --option legacy-default-ingressgateway  --ca mesh_ca  --enable_gcp_components

#### Install an Ingress Gateway

GATEWAY_NS=istio-gateway
kc create namespace $GATEWAY_NS

##### Enable auto-injection

kc get deploy -n istio-system -l app=istiod -o \
jsonpath={.items[*].metadata.labels.'istio\.io\/rev'}'{"\n"}'

REVISION=$(kubectl get deploy -n istio-system -l app=istiod -o \
jsonpath={.items[*].metadata.labels.'istio\.io\/rev'}'{"\n"}')

kc label namespace $GATEWAY_NS istio.io/rev=$REVISION --overwrite
kc label namespace default istio-injection=enabled
kc label namespace $GATEWAY_NS  istio-injection=enabled

cd ~/asm_output
kc apply -n $GATEWAY_NS \
  -f samples/gateways/istio-ingressgateway

kc label namespace default istio-injection-istio.io/rev=$REVISION --overwrite

### Deploy Bookinfo 
https://istio.io/latest/docs/examples/bookinfo/

istio_dir=$(ls -d istio-* | tail -n 1)
cd $istio_dir
cat samples/bookinfo/platform/kube/bookinfo.yaml

kc apply -f samples/bookinfo/platform/kube/bookinfo.yaml

### Enable external access using an Istio Ingress Gateway

cat samples/bookinfo/networking/bookinfo-gateway.yaml
kc apply -f samples/bookinfo/networking/bookinfo-gateway.yaml

kc get services
kc get pods
kc exec -it $(kubectl get pod -l app=ratings \
    -o jsonpath='{.items[0].metadata.name}') \
    -c ratings -- curl productpage:9080/productpage | grep -o "<title>.*</title>"


kc get gateway
kc get svc istio-ingressgateway -n istio-system
export GATEWAY_URL=34.26
curl -I http://${GATEWAY_URL}/productpage


### Use the Bookinfo app
sudo apt install siege
siege http://${GATEWAY_URL}/productpage


### Monitor service performance with the Cloud Service Mesh 
### Dashboard

