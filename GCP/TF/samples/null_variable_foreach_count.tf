## Prompt: Write a terraform script which takes 3 variables, use count for_each to loop the variable , and shows output. No infrastructure component need to be installed.

# variables.tf
variable "names" {
  description = "A list of names to process."
  type        = list(string)
  default     = ["Alice", "Bob", "Charlie"]
}

variable "environments" {
  description = "A map of environments and their characteristics."
  type        = map(object({
    type     = string
    location = string
  }))
  default = {
    "dev"  = { type = "development", location = "eastus" }
    "prod" = { type = "production", location = "westus2" }
  }
}

variable "numbers" {
  description = "A list of numbers."
  type        = list(number)
  default     = [10, 20, 30]
}

# main.tf
resource "null_resource" "name_processor" {
  count = length(var.names)
  triggers = {
    name = var.names[count.index]
  }

  provisioner "local-exec" {
    command = "echo 'Processing name: ${self.triggers.name} (Index: ${count.index})'"
  }
}

resource "null_resource" "environment_processor" {
  for_each = var.environments
  triggers = {
    env_name = each.key
    env_type = each.value.type
    env_loc  = each.value.location
  }

  provisioner "local-exec" {
    command = "echo 'Processing environment: ${each.key} (Type: ${each.value.type}, Location: ${each.value.location})'"
  }
}

resource "null_resource" "number_processor" {
  for_each = toset(var.numbers) # Convert list to set for for_each on simple types
  triggers = {
    number_value = each.value
  }

  provisioner "local-exec" {
    command = "echo 'Processing number: ${each.value}'"
  }
}


# outputs.tf
output "processed_names" {
  description = "Shows the names that were processed."
  value       = null_resource.name_processor.*.triggers.name
}

output "processed_environments" {
  description = "Shows the environments that were processed."
  value       = { for k, v in null_resource.environment_processor : k => v.triggers }
}

output "processed_numbers" {
  description = "Shows the numbers that were processed."
  value       = [for r in null_resource.number_processor : r.triggers.number_value]
}

