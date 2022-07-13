# AWS Cost Consumption
AWS Control Cosnumption uses terraform to provisioning infrastructure in customer AWS accounts. You'll create an *tfvars* Terraform file, which provides the necessary input that triggers the workflow for cost consumption provisioning and reporting.

For more information on the solution, see [**https://docs.aws.amazon.com/controltower/latest/userguide/aft-overview.html**]

## Getting started

This guide is intended for administrators of AWS Cost Consumption tool who wish to set up the infrastructure in customer environment. 

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| region | Client AWS primary region | `string` | - | yes |
| client_name | Name of the customer | `string` | - | yes |
| project_name | Name of the Client Project | `string` | - | yes |
| schedule | Report Schedule Frequency | `string` | quarterly | yes |
| project_description | Brief description | `string` | - | yes |
| client_env | Environment where the tool is provisioned | `string` | - | yes |
| total_client_env | Total AWS accounts | `number` | - | yes |
| install_date | Today's date | `string` | - | no |
| cross_account_role | Role permission | `string` | "arn:aws:iam::798680644831:role/cross-account-lambda-sqs-role"  | yes |