#!/bin/bash
terraform init
terraform plan -out terraform.tfplan
terraform apply terraform.tfplan
