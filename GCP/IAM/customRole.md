# https://www.cloudskillsboost.google/course_templates/702/labs/461622

gciam list-testable-permissions //cloudresourcemanager.googleapis.com/projects/$PR  #list of permissions available to your project
gciam list-grantable-roles  //cloudresourcemanager.googleapis.com/projects/$PR  #list grantable roles for your project

# -- role-definition.yaml
title: "Role Editor"
description: "Edit access for App Versions"
stage: "ALPHA"
includedPermissions:
- appengine.versions.create
- appengine.versions.delete

gciamr create editor --project $PR --file roles-definition.yaml

#
gciamr create viewer --project $PR --title "Roles Viewer"  --description "Custom roles"  --permissions compute.instances.get,compute.instances.list --stage ALPHA
gciamr list --project $PR --format json
   # --show-deleted 
gciamr describe editor --project $PR > /tmp/test.json
append 
- storage.buckets.get
- storage.buckets.list

gciamr update editor --project $PR --file /tmp/test.json
gciamr update viewer --project $PR --add-permissions storage.buckets.get,storage.buckets.list
gciamr update viewer --project $PR --stage DISABLED
# Delete
gciamr delete viewer --project $PR
## Restore
gciamr undelete viewer -project $PR
gciamr update viewer --project $PR --stage GA
