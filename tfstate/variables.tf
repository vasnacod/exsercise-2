variable "dynamotfstate" {
    description = "dynomodb for tfstate locking state"
    type = string 
}

variable "s3tfstate" {
    description = "s3 bucket for tfstate locking"
    type = string  
}