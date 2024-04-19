

### Directory Structure 

```
├── 0-bootstrap
│   ├── bootstrap.sh
│   ├── bootstrap_cicd.tf
│   ├── bootstrap_gcb.yaml 
│   
└── 1-cicd <----------- all Cloud-build Trigger manifests. 
│   ├──triggers.tf
│   ├──cloudbuild.cicd.yaml
│   ├──cloudbuild.vending.plan.yaml
│   ├──cloudbuild.vending.apply.yaml
│   ├──cloudbuild.migration.pubsub.yaml
│   ├──cloudbuild.migration.pubsub.destroy.yaml
│   
└── 2-vending-machine <----------- terraform to create the vending machine
|   ├── 
│   
└── 3-migration-framework <----------- terraform and scripts for migraton framework 
|   ├── 
│   
└── demo-aworks <----------- all terraform and scripts to setup demo database
    ├── 
    ├──
    ├──    
    ├──
```