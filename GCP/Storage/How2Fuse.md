## How to GCSFuse
### https://cloud.google.com/storage/docs/cloud-storage-fuse/install
export GCSFUSE_REPO=gcsfuse-`lsb_release -c -s`
echo "deb [signed-by=/usr/share/keyrings/cloud.google.asc] https://packages.cloud.google.com/apt $GCSFUSE_REPO main" | sudo tee /etc/apt/sources.list.d/gcsfuse.list

curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo tee /usr/share/keyrings/cloud.google.asc
sudo apt-get update -y 
sudo apt-get install -y gcsfuse

## Configure ADC, gc init, gc auth application-default login
bquid='bigquery-qwiklab'
gciamsa create $bquid --display-name "something else"
gc projects add-iam-policy-binding $PR --member serviceAccount:${bquid}@${PR}.iam.gserviceaccount.com --role  roles/storage.objectAdmin
#### Create the key to assign to GOOGLE_APPLICATION_CREDENTIALS for gcsfuse access
gciamsa keys create $bquid.key  --iam-account=${bquid}@${PR}.iam.gserviceaccount.com

