/*
    Using data from state file for EKS Cluster
*/
data "terraform_remote_state" "eks" {
  backend = "local"
  config = {
    path = "C:/Users/rober/Desktop/Cloud Projects/Cloud Project 2 - Deployment Tracker/Terraform/terraform.tfstate.backup"
  }
}
