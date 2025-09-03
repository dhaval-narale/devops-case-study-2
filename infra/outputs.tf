output "ec2_pub_ip"{
    value = aws_eip.my_eip.public_ip
}

output "ec2_pub_dns"{
    value = aws_instance.my_instance.public_dns
}

output "ec2_private_ip" {
    value = aws_instance.my_instance.private_ip
}
