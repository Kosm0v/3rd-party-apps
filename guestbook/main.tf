resource "kubernetes_manifest" "my_app" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "my-ado-app"
      namespace = "argocd"
    }
    spec = {
      project = "default"

      source = {
  
        repoURL        = "https://DIVINT@dev.azure.com/DIVINT/ArgoCDK8s/_git/ArgoCDK8srepo"
        
        targetRevision = "main"
      
        path           = "guestbook" 
      }

      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "default"
      }

      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
        syncOptions = [
          "CreateNamespace=true"
        ]
      }
    }
  }
}

resource "kubernetes_secret" "argocd_repo_creds" {
  metadata {
    name      = "private-repo-creds"
    namespace = "argocd"
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  data = {
    type          = "git"
    url           = "https://DIVINT@dev.azure.com/DIVINT/ArgoCDK8s/_git/ArgoCDK8srepo"
    username      = "git" # Usually 'git' or your username
    password      = data.azurerm_key_vault_secret.ado_pat.value

  }
}