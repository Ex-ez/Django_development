terraform {
  required_providers {
    ncloud = {
      source = "NaverCloudPlatform/ncloud"
    }
  }
  required_version = ">= 0.13"
}

provider "ncloud" {
  region      = "KR"
  site = "PUBLIC"
  support_vpc = true
}

resource "ncloud_login_key" "loginkey" {
  key_name = "test-key"
}

resource "ncloud_vpc" "test" {
  ipv4_cidr_block = "10.1.0.0/16"
  name = "lion-tf"
}

resource "ncloud_subnet" "test" {
  vpc_no         = ncloud_vpc.test.vpc_no
  subnet         = cidrsubnet(ncloud_vpc.test.ipv4_cidr_block, 8, 1)
  zone           = "KR-2"
  network_acl_no = ncloud_vpc.test.default_network_acl_no
  subnet_type    = "PUBLIC"
  usage_type     = "GEN"
  name = "lion-tf-sub"
}

resource "ncloud_server" "server" {
  subnet_no                 = ncloud_subnet.test.id
  name                      = "my-tf-server"
  server_image_product_code = "SW.VSVR.OS.LNX64.UBNTU.SVR2004.B050"
  server_product_code = data.ncloud_server_products.spec.server_products[0].product_code
  login_key_name            = ncloud_login_key.loginkey.key_name
  init_script_no = ncloud_init_script.init.init_script_no
}

resource "ncloud_init_script" "init" {
  name    = "set-docker-tf"
  content = <<EOT
#!/bin/bash

USERNAME="lion"
PASSWORD="1212"
REMOTE_DIRECTORY="/home/$USERNAME/"

echo "Add user"
useradd -s /bin/bash -d $REMOTE_DIRECTORY -m $USERNAME

echo "Set password"
echo "$USERNAME:$PASSWORD" | chpasswd

echo "Set sudo"
usermod -aG sudo $USERNAME
echo "$USERNAME ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers.d/$USERNAME

echo "Update apt and Install docker & docker-compose"
sudo apt-get update
sudo apt install -y docker.io docker-compose

echo "Start docker"
sudo service docker start && sudo service docker enable

echo "Add user to 'docker' group"
sudo usermod -aG docker $USERNAME

echo "done"
EOT
}

resource "ncloud_public_ip" "test" {
    server_instance_no = ncloud_server.server.instance_no
}

data "ncloud_server_products" "spec" {
  server_image_product_code = "SW.VSVR.OS.LNX64.UBNTU.SVR2004.B050" 

  filter {
    name   = "product_code"
    values = ["SSD"]
    regex  = true
  }

  filter {
    name   = "cpu_count"
    values = ["2"]
  }

  filter {
    name   = "memory_size"
    values = ["4GB"]
  }

  filter {
    name   = "base_block_storage_size"
    values = ["50GB"]
  }

  filter {
    name   = "product_type"
    values = ["HICPU"]
  }

  output_file = "product.json"
}

output "products" {
  value = {
    for product in data.ncloud_server_products.spec.server_products:
    product.id => product.product_name
  }
}

output "server_ip" {
  value = ncloud_server.server.public_ip
}

output "public_ip" {
  value = ncloud_public_ip.test.public_ip
}

# db