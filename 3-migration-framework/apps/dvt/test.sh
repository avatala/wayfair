export PROJECT_ID="m2m-wayfair-dev"
export SOURCE_SECRET_NAME="mssql-csql-aworks-pwd"
export DEST_SECRET_NAME="pg-csql-aworks-pwd"
export WORKLOADS_SA_SECRET_NAME="workload-sa"

export PROJECT_NUMBER=$(gcloud projects describe "${PROJECT_ID}" --format='value(projectNumber)')
gcloud secrets versions access latest --project $PROJECT_ID --secret=$WORKLOADS_SA_SECRET_NAME --format='get(payload.data)' | tr '_-' '/+' | base64 -d >> tmp.json
export GOOGLE_APPLICATION_CREDENTIALS=tmp.json

# export SOURCE_PWD=$(gcloud secrets versions access latest --project $PROJECT_ID --secret=$SOURCE_SECRET_NAME --format='get(payload.data)' | tr '_-' '/+' | base64 -d)
export SOURCE_PWD="4=dYjTJ*0C;*)FES"
export DEST_PWD=$(gcloud secrets versions access latest --project $PROJECT_ID --secret=$DEST_SECRET_NAME --format='get(payload.data)' | tr '_-' '/+' | base64 -d)

echo $SOURCE_PWD
echo $DEST_PWD

python test1.py

rm tmp.json