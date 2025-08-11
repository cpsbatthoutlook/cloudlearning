echo apt install -y vim
alias gc=gcloud
alias gcaappdeflogin='gcloud auth application-default login' ## /root/.config/gcloud/application_default_credentials.json  
alias gcs='gcloud storage '
alias gccc='gcloud config configurations '
alias gcc='gcloud compute '
alias gcpaiampb='gcloud projects add-iam-policy-binding '
alias gcpgiamp='gcloud projects get-iam-policy '
alias gcci='gcloud compute instances '
alias gciam='gcloud iam '
alias gciamr='gcloud iam roles '
alias gciamsa='gcloud iam service-accounts '
export PR=$(gcloud config get-value project)
export zone=$(gcloud config get-value compute/zone)
export region=$(gcloud config get-value compute/region)
###
alias tf='terraform '
alias tfplan='terraform plan '
alias tfapply='terraform apply -auto-approve '
alias tfshow='terraform show '
# Function
function cpscleanup() { egrep -v "^\s*$|^\s*#" $1; }
