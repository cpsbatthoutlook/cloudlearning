from google.auth import compute_engine
from google.cloud import bigquery
credentials = compute_engine.Credentials(service_account_email='YOUR_SERVICE_ACCOUNT')
query = ''' SELECT year, COUNT(1) as num_babies FROM publicdata.samples.natality WHERE year > 2000 GROUP BY year '''
client = bigquery.Client( project='Your Project ID', credentials=credentials)
print(client.query(query).to_dataframe())
