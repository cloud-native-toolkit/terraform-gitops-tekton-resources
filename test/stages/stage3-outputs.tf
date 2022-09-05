
resource local_file write_outputs {
  filename = "gitops-output.json"

  content = jsonencode({
    name        = module.gitops_tekton_resources.name
    branch      = module.gitops_tekton_resources.branch
    namespace   = module.gitops_tekton_resources.namespace
    server_name = module.gitops_tekton_resources.server_name
    layer       = module.gitops_tekton_resources.layer
    layer_dir   = module.gitops_tekton_resources.layer == "infrastructure" ? "1-infrastructure" : (module.gitops_tekton_resources.layer == "services" ? "2-services" : "3-applications")
    type        = module.gitops_tekton_resources.type
  })
}
