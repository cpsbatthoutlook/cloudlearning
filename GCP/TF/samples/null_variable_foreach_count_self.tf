variable "num" {
   type = number
   default = 10
}

variable "str" {
   type = string
   default = "10"
}

variable "strlist" {
  type = list(string)
  default = ["A","B","C"  ]
}

variable "numlist" {
  type=list(number)
  default=[99, 88 ]
}

variable "obj" {
  type=object({type = string
               location = string})

  default = {type="development", location="test1"}
}

variable "objmap" {
  type=map(object({type = string
               location = string}))

  default = {"dev" = {type="development", location="test1"}
             "uat" = {type="uat", location="uattest1"}}
}

## main.tf 

resource "null_resource" "testobjmap" {
  for_each = var.objmap
  triggers = { name = each.value.type
                loc = each.value.location
                tit = each.key  }
  provisioner "local-exec" {
    command = "echo ' local-provision running ${self.triggers.tit}  >> ${self.triggers.loc}:  ${self.triggers.name} '"
  }
  provisioner "local-exec" {
    command = "echo ' local-provision without trigger  running ${each.key} ${each.value.type}:  ${each.value.location} '"
  }
}


resource "null_resource" "testobj" {
  for_each = var.obj
  triggers = { name = var.obj.type
                loc = var.obj.location  }
  provisioner "local-exec" {
    command = "echo ' local-provision running ${self.triggers.loc}:  ${self.triggers.name} '"
  }
  provisioner "local-exec" {
    command = "echo ' local-provision without trigger  running ${var.obj.type}:  ${var.obj.location} '"
  }
}

resource "null_resource" "teststrlist" {
  count = length(var.strlist)   #for_each = var.strlist
  triggers = { name = var.strlist[count.index] }
  provisioner "local-exec" {
    command = "echo ' local-provision running ${count.index}:  ${self.triggers.name} '"
  }
}


resource "null_resource" "testnum" {
  triggers = { name = var.num }
  provisioner "local-exec" {
    command = "echo ' local-provision running ${self.triggers.name} '"
  }
}

resource "null_resource" "teststr" {
  triggers = { name = var.name }
  provisioner "local-exec" {
    command = "echo 'local-provision running ${self.teiggers.name} "
  }
}

## output.tf
output "op_num" {
  value = null_resource.testnum.*.triggers.name
}
output "op_str" {
  description=""
  value = null_resource.teststr.*.triggers.name
}
output "op_strlist" {
  description=""
  value = null_resource.teststrlist.*.triggers.name
}

output "op_numlist" {
  description=""
  value = null_resource.testnumlist.*.triggers.name
}
output "op_objmap" { 
  description=""
  value       = { for k, v in null_resource.testobjmap : k => v.triggers }
}

