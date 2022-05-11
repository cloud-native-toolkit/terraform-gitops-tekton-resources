terraform {
  required_version = ">= 0.15.0"

  required_providers {
    gitops = {
      source = "cloud-native-toolkit/gitops"
    }
    hashicorp-local = {
      source  = "hashicorp/local"
      version = "= 2.2.2"
    }
    hashicorp-external = {
      source = "hashicorp/external"
      version = "2.2.2"
    }

    ibm = {
      source = "IBM-Cloud/ibm"
      version = "0.13"
    }
 }

}
