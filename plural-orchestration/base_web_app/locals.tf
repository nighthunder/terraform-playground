###############################################################################
# LOCALS #
###############################################################################

locals {
  common_tags = {
    company      = var.company
    project      = "${var.company} - ${var.project}"
    billing_code = var.billing_code
  }
}

resource "random_integer" "s3"{
  min = 1000
  max = 9999
}