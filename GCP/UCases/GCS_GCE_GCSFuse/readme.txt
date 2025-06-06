
"Create a Terraform script that provisions the following Google Cloud resources:

A GCE Ubuntu instance with the e2-standard-2 machine type, located in the default VPC.
SSH access to the instance should be enabled via public SSH keys provided from an external file.
The instance should be provisioned using a remote-exec provisioner to install the gcsfuse package.
HTTPS access (port 443) should be pre-configured by opening the necessary firewall rule in the VPC.
A Google Cloud Storage (GCS) bucket with a globally unique name.
A Service Account with the roles/storage.objectAdmin role specifically granted to the newly created GCS bucket.
The Terraform script should output the instructions on how to securely generate the JSON key for the created Service Account using the gcloud CLI, rather than directly exposing the key."
