output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "subnet_public1"{
    value = aws_subnet.public1.id
}

output "subnet_public2"{
    value = aws_subnet.public2.id
}

output "subnet_public3"{
    value = aws_subnet.public3.id
}

output "subnet_private1"{
    value = aws_subnet.private1.id
}

output "subnet_private2"{
    value = aws_subnet.private2.id
}

output "subnet_private3"{
    value = aws_subnet.private3.id
}
