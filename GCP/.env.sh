alias gc=gcloud
alias gcs='gcloud storage '
alias gcc='gcloud compute '
alias gcci='gcloud compute instances '
alias gciam='gcloud iam '
alias gciamr='gcloud iam roles '
alias gciamsa='gcloud iam service-accounts '
export PR=$(gcloud config get-value project)
export region=$(gcloud config get-value compute/region)
export zone=$(gcloud config get-value compute/zone)
echo apt install -y vim
echo $region  $zone  $PR
