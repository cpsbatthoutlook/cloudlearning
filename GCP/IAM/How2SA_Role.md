## Create a SA and assign the Roles/Editor
#### https://www.cloudskillsboost.google/course_templates/702/labs/461620

uid='my-sa-123'
DEVSHELL_PROJECT_ID=$PR
gciamsa create $uid --display-name "something"
gc projects add-iam-policy-binding $PR --member serviceAccount:${uid}@${PR}.iam.gserviceaccount.com --role roles/editor

## Create a SA and get the BigQ and StorageAdmin access 
### Create the key to assign to GOOGLE_APPLICATION_CREDENTIALS for gcsfuse access
bquid='bigquery-qwiklab'
gciamsa create $bquid --display-name "something else"
gc projects add-iam-policy-binding $PR --member serviceAccount:${bquid}@${PR}.iam.gserviceaccount.com --role roles/bigquery.user
gc projects add-iam-policy-binding $PR --member serviceAccount:${bquid}@${PR}.iam.gserviceaccount.com --role roles/bigquery.dataViewer
gc projects add-iam-policy-binding $PR --member serviceAccount:${bquid}@${PR}.iam.gserviceaccount.com --role  roles/storage.objectAdmin
gciamsa keys create $bquid.key  --iam-account=${bquid}@${PR}.iam.gserviceaccount.com

##Create VM with SA $bquid per API
apt-get update -y
sudo apt-get install -y git python3-pip tmux  python3.11-venv
python3 -m venv testing
source testing/bin/active

pip3 install --upgrade pip
pip3 install google-cloud-bigquery pyarrow pandas  db-dtypes

echo "
from google.auth import compute_engine
from google.cloud import bigquery

credentials = compute_engine.Credentials(
    service_account_email='bigquery-qwiklab@qwiklabs-gcp-02-d07f9e0ca4ad.iam.gserviceaccount.com')

query = '''
SELECT   year,  COUNT(1) as num_babies FROM    publicdata.samples.natality WHERE   year > 2000 GROUP BY   year
'''

client = bigquery.Client(    project='qwiklabs-gcp-02-d07f9e0ca4ad',    credentials=credentials)
print(client.query(query).to_dataframe())
" > query.py

python3 query.py
