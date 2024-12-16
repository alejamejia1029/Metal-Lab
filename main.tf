terraform {
  required_providers {
    equinix = {
      source = "equinix/equinix"
      #version = "2.11.0"
    }
  }
}


resource "equinix_metal_device" "web1" {
  hostname         = "amejia-lab1"
  plan             = var.plan
  metro            = var.metro1
  operating_system = var.os
  billing_cycle    = "hourly"
  project_id       = var.Metal-Project
  user_data           = data.template_file.this-ny.rendered
  behavior {
    allow_changes = [
      "custom_data",
      "user_data"
    ]
  }
  
}
locals {
  bond0_id = [for p in equinix_metal_device.web1.ports: p.id if p.name == "bond0"][0]
   eth1_id = [for p in equinix_metal_device.web1.ports: p.id if p.name == "eth1"][0]
}

resource "equinix_metal_port" "bond0-ny" {
  port_id = local.bond0_id
  layer2 = false
  bonded = true
  vlan_ids = [equinix_metal_vlan.vlan29NY.id]
}


data "template_file" "this-ny" {
  template = file("C:/Users/mmejia/Documents/TAM/Github-files/.git/METAL-LAB/data-ny.sh")
}

resource "equinix_metal_device" "web2" {
  hostname         = "amejia-lab2"
  plan             = var.plan
  metro            = var.metro2
  operating_system = var.os
  billing_cycle    = "hourly"
  project_id       = var.Metal-Project
  user_data           = data.template_file.this-dc.rendered
  behavior {
    allow_changes = [
      "custom_data",
      "user_data"
   
    ]
  }
}
locals {
  bond0_id2 = [for p in equinix_metal_device.web2.ports: p.id if p.name == "bond0"][0]
   eth1_id2 = [for p in equinix_metal_device.web2.ports: p.id if p.name == "eth1"][0]
}
resource "equinix_metal_port" "bond0-dc" {
  port_id = local.bond0_id2
  layer2 = false
  bonded = true
  vlan_ids = [equinix_metal_vlan.vlan29DC.id]
}



data "template_file" "this-dc" {
  template = file("C:/Users/mmejia/Documents/TAM/Github-files/.git/METAL-LAB/data-dc.sh")
}

# Create a new VLAN in metro "NY"
resource "equinix_metal_vlan" "vlan29NY" {
  description = "VLAN in NY"
  metro       = var.metro1
  project_id  = var.Metal-Project
  vxlan       = var.vlan1
}
# Create a new VLAN in metro "DC"
resource "equinix_metal_vlan" "vlan29DC" {
  description = "VLAN in DC"
  metro       = var.metro2
  project_id  = var.Metal-Project
  vxlan       = var.vlan2
}


resource "equinix_metal_connection" "ITX-Metal-side" {
  name               = "amejia-metal-tf-lab"
  project_id         = var.Metal-Project
  type               = "shared"
  redundancy         = "primary"
  metro              = var.metro1
  speed              = "10Gbps"
  service_token_type = "z_side"
  contact_email      = "mariaalejandra.mejia@eu.equinix.com"
  vlans              = [equinix_metal_vlan.vlan29NY.vxlan]
}


resource "equinix_fabric_connection" "amejia-test-tf" {
  name      = "amejia-tf-metal-port"
  type      = "EVPL_VC"
  bandwidth = "50"
  notifications {
    type   = "ALL"
    emails = ["mariaalejandra.mejia@eu.equinix.com"]
  }
  #order { purchase_order_number = "" }
  project {
     project_id = var.Fabric-Project
     }
  a_side {
    access_point {
      type = "COLO"
      port {
        uuid = var.Fabric-P-UUID
      }
      link_protocol {
        type     = "DOT1Q"
        vlan_tag = equinix_metal_vlan.vlan29NY.vxlan
      }
    }
  }
  z_side {
    service_token {
      uuid = equinix_metal_connection.ITX-Metal-side.service_tokens.0.id
    }
  }
}


resource "equinix_metal_virtual_circuit" "amejia-DC-vc" {
  name = "amejia-DC-vc"
  connection_id = var.Metal-Con-ID
  project_id = var.Metal-Project
  port_id = var.Metal-P-ID
  vlan_id = equinix_metal_vlan.vlan29DC.vxlan
  nni_vlan = equinix_metal_vlan.vlan29DC.vxlan
}