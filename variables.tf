# Input Variables

variable "workload" {
  description = "Workload / Application"
  type        = string
}

variable "environment" {
  description = "Environment Name"
  type        = string
}

variable "azure_region" {
  description = "Azure Region"
  type        = string
}

variable "instance" {
  description = "Instance"
  type        = string
}


variable "onpremise_address_space" {
  description = "Onpremise Address Space"
  type        = string
}

variable "onpremise_gateway_address" {
  description = "Onpremise Gateway Address"
  type        = string
}

variable "ipsec_shared_key" {
  description = "IPsec shared key"
  type        = string
}

variable "admin_username" {
  description = "Admin User Name"
  type        = string
}

variable "owner" {
  description = "Name of Owner"
  type        = string
}

variable "source_change" {
  description = "Source of Change"
  type        = string
}

variable "criticality" {
  description = "Critiality of Resource"
  type        = string
}


