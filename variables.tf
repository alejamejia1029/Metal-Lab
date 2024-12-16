variable "plan" {
  type        = string
  description = "device type/size"
  default     = "c3.small.x86"
}
variable "os" {
  type        = string
  description = "Operating system"
  default     = "ubuntu_20_04"
}
variable "Metal-Project" {
  type        = string
  description = "Metal-Project"
  default     = "d0418d98-86af-417a-a50a-331c989ffe63"
}
variable "Fabric-Project" {
  type        = string
  description = "Metal-Project"
  default     = "f1a596ed-d24a-497c-92a8-44e0923cee62"
}
variable "metro1" {
  type        = string
  description = "Equinix metro code"
  default     = "NY"
}
variable "vlan1" {
  type        = string
  description = "Equinix metro code"
  default     = "29"
}
variable "metro2" {
  type        = string
  description = "Vlan Metro1"
  default     = "DC"
}
variable "vlan2" {
  type        = string
  description = "Vlan Metro2"
  default     = "29"
}
variable "Fabric-P-UUID" {
  type        = string
  description = "Fabric Port UUID"
  default     = "b69e3c91-9264-2641-19e0-320a5c00ada5"
}
variable "Metal-P-ID" {
  type        = string
  description = "Metal Port ID"
  default     = "2a2dfbf5-7ee6-4c3d-8cb4-870357da6266"
}
variable "Metal-Con-ID" {
  type        = string
  description = "Metal Connection ID"
  default     = "3f768ff0-c795-4380-a5f2-a4a07b7f6711"
}

