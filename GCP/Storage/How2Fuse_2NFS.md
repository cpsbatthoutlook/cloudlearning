## How to GCSFuse
### https://cloud.google.com/storage/docs/cloud-storage-fuse/install
export GCSFUSE_REPO=gcsfuse-`lsb_release -c -s`
echo "deb [signed-by=/usr/share/keyrings/cloud.google.asc] https://packages.cloud.google.com/apt $GCSFUSE_REPO main" | sudo tee /etc/apt/sources.list.d/gcsfuse.list

curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo tee /usr/share/keyrings/cloud.google.asc
sudo apt-get update -y 
sudo apt-get install -y gcsfuse tmux 


## Create a compute

gc config list
gc compute zones list # check under ~/.config/gcloud/configurations/config_default
gciamr list
gcci create lab-1 --zone $zone --machine-type=e2-standard-2


## Configure ADC, gc init, gc auth application-default login
bquid='bigquery-qwiklab'
gciamsa create $bquid --display-name "something else"
gc projects add-iam-policy-binding $PR --member serviceAccount:${bquid}@${PR}.iam.gserviceaccount.com --role  roles/storage.objectAdmin
gc projects add-iam-policy-binding  $PR --member serviceAccount:my-test-account@${PR}.iam.gserviceaccount.com --role roles/compute.admin
##Assign the SA acccount to compute
gcci stop lab-1
gcci set-service-account lab-1 --zone=$zone --service-account=my-test-account
gcci start lab-1
#### Create the key to assign to GOOGLE_APPLICATION_CREDENTIALS for gcsfuse access
gciamsa keys create $bquid.key  --iam-account=${bquid}@${PR}.iam.gserviceaccount.com

## Create a bucket
gcs buckets create gs://mb1-$PR

## Mount
gcloud auth application-default login
### OR creat the JSON key and define the varible
mkdir "$HOME/mount-folder"
gsutil ls
gcsfuse mb1-$PR "$HOME/mount-folder"


## How to NFS  server in ubuntu
apt install nfs-kernel-server -y
sudo systemctl start nfs-kernel-server.service
echo "/mnt1 *(rw,async,no_subtree_check,no_root_squash,fsid=0)" > /etc/exports

## NFS Client
sudo apt install nfs-common
sudo mkdir /opt/example
sudo mount example.hostname.com:/srv /opt/example
