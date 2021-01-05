variable "project" {
	default = "ca-seno-test"
}

variable "cluster_name" {
  default = "tf-cluster"
}

variable "location" {
  default = "asia-northeast1-c"
}

variable "network" {
  default = "default"
}

variable "primary_node_count" {
  default = "2"
}

variable "machine_type" {
  default = "e2-small"
  // default = "n1-standard-1"
}

variable "min_master_version" {
  default = "1.15.2-gke.2"
}

variable "node_version" {
  default = "1.15.2-gke.2"
}
