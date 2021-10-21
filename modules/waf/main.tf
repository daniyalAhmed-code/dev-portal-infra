## WAF with F5 Group Rules
module "waf" {
  source  = "trussworks/wafv2/aws"
  version = "2.4.0"

  name  = var.name
  scope = var.is_regional ? "REGIONAL" : "CLOUDFRONT"

  managed_rules = [
    {
      excluded_rules : [],
      name : "API_Managed",
      override_action : "none",
      priority : 10
    },
    {
      excluded_rules : [],
      name : "Bots_Managed",
      override_action : "none",
      priority : 20
    },
    {
      excluded_rules : [],
      name : "OWASP_Managed",
      override_action : "none",
      priority : 30
    },
  ]
}
