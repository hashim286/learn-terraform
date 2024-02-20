variable "bucket_name" {
    type = string
    description = "name of bucket to deploy" 
}


variable "index_file" {
    type = string
    description = "index html file"
}

variable "error_file" {
  type = string
  description = "error html file"
}