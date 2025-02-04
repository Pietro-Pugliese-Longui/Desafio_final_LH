terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
      version = "0.4.3"  
    }
  }
}

provider "databricks" {
  host  = var.databricks_host
  token = var.databricks_token
}

variable "databricks_host" {
  description = "Host for Databricks"
  type        = string
}

variable "databricks_token" {
  description = "Databricks Token"
  type        = string
  sensitive   = true
}

resource "databricks_catalog" "raw" {
  name          = "pietro_longui_raw"
  comment       = "Catalog raw for desafio final"
}


resource "databricks_catalog" "stg" {
  name          = "pietro_longui_stg"
  comment       = "Catalog stg for desafio final"
}

