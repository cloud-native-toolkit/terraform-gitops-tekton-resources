locals {
  name      = "tekton-resources"
  resource_dir = "${path.cwd}/.tmp/${local.name}"
  layer = "services"
  application_branch = "main"
  layer_config = var.gitops_config[local.layer]
}

resource null_resource setup_chart {
  provisioner "local-exec" {
    command = "${path.module}/scripts/create-yaml.sh '${local.name}' '${local.resource_dir}' '${var.task_release}'"
  }
}

resource null_resource setup_gitops {
  depends_on = [null_resource.setup_chart]

  provisioner "local-exec" {
    command = "${path.module}/scripts/setup-gitops.sh '${local.name}' '${local.resource_dir}' '${local.name}' '${local.application_branch}' '${var.namespace}'"

    environment = {
      GIT_CREDENTIALS = jsonencode(var.git_credentials)
      GITOPS_CONFIG = jsonencode(local.layer_config)
    }
  }
}
