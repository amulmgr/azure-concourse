///////////////////////////////////////////////
//////// Pivotal Customer[0] //////////////////
//////// ALB for MySQL ////////////////////////
///////////////////////////////////////////////

resource "azurerm_lb" "mysql" {
  name                = "${var.env_name}-mysql-lb"
  location            = "${var.location}"
  resource_group_name = "${var.env_name}"

  frontend_ip_configuration = {
    name      = "frontendip"
    subnet_id = "${var.ert_subnet_id}"
  }
}

resource "azurerm_lb_backend_address_pool" "mysql-backend-pool" {
  name                = "mysql-backend-pool"
  location            = "${var.location}"
  resource_group_name = "${var.env_name}"
  loadbalancer_id     = "${azurerm_lb.mysql.id}"
}

resource "azurerm_lb_probe" "mysql-probe" {
  name                = "mysql-probe"
  location            = "${var.location}"
  resource_group_name = "${var.env_name}"
  loadbalancer_id     = "${azurerm_lb.mysql.id}"
  protocol            = "TCP"
  port                = 1936
}

resource "azurerm_lb_rule" "mysql-rule" {
  name                = "mysql-rule"
  location            = "${var.location}"
  resource_group_name = "${var.env_name}"
  loadbalancer_id     = "${azurerm_lb.mysql.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 3306
  backend_port                   = 3306
}