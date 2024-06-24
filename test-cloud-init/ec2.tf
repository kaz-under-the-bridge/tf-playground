resource "aws_vpc" "example" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "tf-example"
  }
}

resource "aws_subnet" "example" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "tf-example"
  }
}

data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.amzn-linux-2023-ami.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.example.id

  #cpu_options {
  #  core_count       = 2
  #  threads_per_core = 2
  #}

  tags = {
    Name = "tf-example"
  }

  user_data = templatefile(
    "./scripts/user_data.yaml",
    {
      run-script = trimspace(indent(2, file("./scripts/run-script.sh")))
    }
  )
}
