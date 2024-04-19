# Below commands will be used for Deploying the code base to the Cloud Run Environment.

1. gcloud config set project m2m-wayfair-dev
2. gcloud builds submit --tag gcr.io/m2m-wayfair-dev/dvt-wrapper:latest .
3. gcloud run deploy dvt-wrapper --image gcr.io/m2m-wayfair-dev/dvt-wrapper:latest --platform managed --region us-east1
    --allow-unauthenticated --service-account workload-sa@m2m-wayfair-dev.iam.gserviceaccount.com