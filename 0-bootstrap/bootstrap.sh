#!/bin/bash

# This script creates the root folder, iac project, enables apis, and bucket for proctor level tf state
# It also calls the initial tf apply on cicd tf via gcb submitted locally with state saved in bucket 

# set these
export RESOURCE_PREFIX=tmp-wf
export ORG_ID=305658411957
export REPO_NAME=m2m-wayfair
export _TF_REPO_OWNER="66degrees"
export BILLING_ACCOUNT="01A26E-F5A54C-83E700"

#  customize these if needed but they can be used as-is
export ROOT_FOLDER_NAME=$RESOURCE_PREFIX
export IAC_PROJECT=$RESOURCE_PREFIX-iac
export _TF_REPO_NAME_INFRA=$REPO_NAME
export _TF_REPO_NAME_FRONTEND=$REPO_NAME
export _TF_REPO_NAME_BACKEND=$REPO_NAME
export _TF_PREFIX="bootstrap"
export _TF_BUCKET="${IAC_PROJECT}-tfstate"


create_folder () {
    ###################
    # create root folder and save the id for creating the project
    # https://stackoverflow.com/questions/918886/how-do-i-split-a-string-on-a-delimiter-in-bash
    export FOLDER_NAME=$(gcloud resource-manager folders create --display-name=$ROOT_FOLDER_NAME --organization=$ORG_ID --format='value(name)')
    export DELIMITOR="/"
    export FOLDER_PARTS=(${FOLDER_NAME//$DELIMITOR/ })
    export FOLDER_ID=${FOLDER_PARTS[1]}
    
}

create_folder_perm () {
    
    export USER=$(gcloud auth list --filter=status:ACTIVE --format="value(account)")
    echo "Adding folder role for USER: $USER"
    gcloud resource-manager folders add-iam-policy-binding $FOLDER_ID --member="user:$USER" --role='roles/resourcemanager.projectCreator'
    
}

create_project() {
    ###################
    # create the iac project
    echo "creating project in folder ${FOLDER_ID}"
    gcloud projects create "${IAC_PROJECT}" --folder="${FOLDER_ID}"
    gcloud beta billing projects link "${IAC_PROJECT}" --billing-account="${BILLING_ACCOUNT}"

    ###################################
    # Enable services in the iac project
    services=(
      logging.googleapis.com
      bigquery.googleapis.com
      bigquerystorage.googleapis.com
      bigquerydatatransfer.googleapis.com
      cloudapis.googleapis.com
      cloudbilling.googleapis.com
      clouddebugger.googleapis.com
      cloudresourcemanager.googleapis.com
      cloudtrace.googleapis.com
      datastore.googleapis.com
      monitoring.googleapis.com
      servicemanagement.googleapis.com
      serviceusage.googleapis.com
      sql-component.googleapis.com
      sqladmin.googleapis.com      
      storage-api.googleapis.com
      storage-component.googleapis.com
      iam.googleapis.com
      cloudbuild.googleapis.com
      sourcerepo.googleapis.com
    )
    
    for service in "${services[@]}"; do
      echo "enabling service: ${service}"
      gcloud services enable "${service}" --project="${IAC_PROJECT}"
    done


}

create_gcb_sa_perms() {
    # GCB SA IAM
    export IAC_PROJECT_NUMBER=$(gcloud projects describe "${IAC_PROJECT}" --format='value(projectNumber)')
    export GCB_SA=$IAC_PROJECT_NUMBER@cloudbuild.gserviceaccount.com
    echo "Adding folder role for GCB SA: $GCB_SA"
    gcloud resource-manager folders add-iam-policy-binding $FOLDER_ID --member="serviceAccount:$GCB_SA" --role='roles/resourcemanager.projectCreator'
    gcloud resource-manager folders add-iam-policy-binding $FOLDER_ID --member="serviceAccount:$GCB_SA" --role='roles/resourcemanager.folderCreator'
    gcloud resource-manager folders add-iam-policy-binding $FOLDER_ID --member="serviceAccount:$GCB_SA" --role='roles/resourcemanager.projectIamAdmin'

}

create_gcb_sa_billing_account_user() {
    # GCB SA IAM
    export IAC_PROJECT_NUMBER=$(gcloud projects describe "${IAC_PROJECT}" --format='value(projectNumber)')
    export GCB_SA=$IAC_PROJECT_NUMBER@cloudbuild.gserviceaccount.com
    echo "Adding billing user role for GCB SA: $GCB_SA"

    gcloud beta billing accounts add-iam-policy-binding $BILLING_ACCOUNT --member="serviceAccount:$GCB_SA" --role='roles/billing.user'

}

create_bucket() {
    ###################
    # make state bucket

    
    # create the bucket and set versioning and a label
    gsutil mb -c standard -l us-central1 -p "${IAC_PROJECT}" gs://"${_TF_BUCKET}"
    gsutil label ch -l iac:true gs://"${_TF_BUCKET}"
    gsutil versioning set on gs://"${_TF_BUCKET}"
    
}

create_trigger() {
    ###################
    # make the manual trigger to run cicd triggers
    gcloud builds submit --config ./bootstrap_gcb.yaml --project $IAC_PROJECT --substitutions _TF_BUCKET=$_TF_BUCKET,_TF_PREFIX=$_TF_PREFIX,_TF_REPO_OWNER=$_TF_REPO_OWNER,_TF_REPO_NAME_INFRA=$_TF_REPO_NAME_INFRA

}

cleanups(){
    echo "deleting..."
}

# Run the process
# for testing only - set a folder id to use instead of creating a new one:
# export FOLDER_ID=809756197106

create_folder
echo "FOLDER_ID: ${FOLDER_ID}"
create_folder_perm
create_project
create_gcb_sa_perms
create_gcb_sa_billing_account_user
create_bucket
create_trigger

# cleanups
