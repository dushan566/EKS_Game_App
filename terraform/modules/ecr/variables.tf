# VAriable for your application name
variable "application" {
  type = string
  default = "myapp"
  description = "Name of the application"
}

# Variable for Map of all common tags
variable "tags" {
  type = map
  default = {}
}





