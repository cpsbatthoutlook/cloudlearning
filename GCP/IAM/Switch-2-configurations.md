## https://www.cloudskillsboost.google/course_templates/702/labs/461621

### gc config configurations list
                         activate default

gciamr list | grep "name:"
       describe roles/compute.instanceAdmin


##Grant acces to 2nd user to 2nd project
gccc activate user2
gc config set project $PR2
gccc activate default
gc config set project $PR2
gc projects add-iam-policy-binding $PR2 --member user:$user2 --role=roles/viewer

### https://www.cloudskillsboost.google/course_templates/702/labs/461621

   19  gc config list
   20  gc config set compute/zone us-east1-c
   21  cat ~/.config/gcloud/configurations/config_default 
   22  gcloud init --no-launch-browser
   23  gc config list
   24  echo $zone
   36  gcci lab-2 --zone $zone --machine-type=e2-standard-2
   37  gcci create  lab-2 --
   39  gccc activate user2
   40  echo "export PROJECTID2=qwiklabs-gcp-03-0c8fff8afda1" >> ~/.bashrc
   41  echo "export PR2=qwiklabs-gcp-03-0c8fff8afda1" >> ~/.bashrc
   42  echo "export USERID2=student-02-29b76b3157f4@qwiklabs.net" >> ~/.bashrc
   43  echo "export uid2=student-02-29b76b3157f4@qwiklabs.net" >> ~/.bashrc
   44  . ~/.bashrc
   45  gc projects add-iam-policy-binding $PR2 --member user:$uid2 --role=roles/viewer
   46  gc config list
   47  gccc activate default
   48  gc projects add-iam-policy-binding $PR2 --member user:$uid2 --role=roles/viewer
   49  gccc activate user2
   50  gc config list
   51  gc config set project $PR2
   52  gc config list
   53  gcci create lab-2 --zone $zone --machine-type=e2-standard-2
   54  gccc activate default
   55  gcci create lab-2 --zone $zone --machine-type=e2-standard-2
   56  gciamr create devops --project $PR2 --permissions "compute.instances.create,compute.instances.delete,compute.instances.start,compute.instances.stop,compute.instances.update,compute.disks.create,compute.subnetworks.use,compute.subnetworks.useExternalIp,compute.instances.setMetadata,compute.instances.setServiceAccount"
   59  gc projects add-iam-policy-binding $PR2 --member user:$uid2 --role=roles/iam.serviceAccountUser
   60  gc projects add-iam-policy-binding $PR2 --member user:$uid2 --role=projects/$PR2/roles/devops
   61  gccc activate user2
   62  gcci create lab-2 --zone $zone --machine-type=e2-standard-2
   63  gccc activate default
   64  gc config set project $PR2
   65  gciamsa create devops --display-name devops
   66  gciamsa list --filter "displayName=devops"
   69  gciamsa list --format="value(email)"  --filter "displayName=devops"
   70  SA=$(gcloud iam service-accounts list --format="value(email)"  --filter "displayName=devops")
   71  echo $SA
   72 gc projects add-iam-policy-binding $PR2 --member serviceAccount:$SA --role=roles/iam.serviceAccountUser
   73 gc projects add-iam-policy-binding $PR2 --member serviceAccount:$SA --role=roles/compute.instanceAdmin
   83  gcci create lab-3 --zone $zone --machine-type=e2-medium-2
   84  gcci create lab-3 --zone $zone --machine-type=e2-standard-2 --service-account $SA --scopes "https://www.googleapis.com/auth/compute"
   85  gcc ssh lab-3 --zone $zone
   86  gcci create lab-4 --zone $zone --machine-type=e2-standard-2 

