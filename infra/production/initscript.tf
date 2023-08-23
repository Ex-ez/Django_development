## init script setup start
# be_init
resource "ncloud_init_script" "be-prod" {
  name = "set-be-prod-tf"
  content = templatefile("${path.module}/be_init_script.tftpl", {
    password               = var.password
    db                     = var.db
    db_user                = var.db_user
    db_password            = var.db_password
    db_port                = var.db_port
    db_host                = ncloud_public_ip.db-prod.public_ip
    NCP_ACCESS_KEY         = var.NCP_ACCESS_KEY
    NCP_SECRET_KEY         = var.NCP_SECRET_KEY
    django_secret_key      = var.django_secret_key
    django_settings_module = var.django_settings_module
  })
}

# db_init
resource "ncloud_init_script" "db-prod" {
  name = "set-db-prod-tf"
  content = templatefile("${path.module}/db_init_script.tftpl", {
    password    = var.password
    db          = var.db
    db_user     = var.db_user
    db_password = var.db_password
    db_port     = var.db_port
  })
}
## init script setup end
