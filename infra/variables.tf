variable "ec2_instance_type"{
    default = "t2.micro"
    type = string
}

variable "ec2_instance_volume"{
    default = 8
    type = number
}

variable "ec2_instance_image"{
    default = "ami-02d26659fd82cf299"
    type = string
}

variable "ec2_instance_volume_type" {
    default = "gp3"
    type = string
}

variable "region" {
    default = "ap-south-1"
    type = string
}
