https://www.cloudskillsboost.google/course_templates/725/labs/461638


gcs mb gs://$PR

## Set retention period to 10sec on Bucket
gsutil retention set 10s gs://$PR
       retention get  gs://$PR
       cp something gs://$PR
       ls -L gs://$PR/something

## Lock the retention policy
gsutil retention lock gs://$PR
                 get gs://$PR
                 

## Temp Hold
gsutil retention temp set gs://$PR/something
                 rm  ## Won't work
                 temp release gs://$PR/something
                 rm  ## Won't work

## Event based holds
gsutil retention event-default set gs://$PR
                 event release gs://$PR


## How to remove Retention policy
gsutil rb gs://$PR


