# Terraform — 50 Q&A (25 Theory + 25 Scenario)

## Theory-Based

1. **Q: What is Terraform?**
   A: An open-source Infrastructure-as-Code tool by HashiCorp that lets you define, provision, and manage infrastructure across cloud providers using declarative configuration files (HCL).

2. **Q: What is the Terraform state file?**
   A: A JSON file (`terraform.tfstate`) that maps your configuration to real-world resources, tracking metadata and enabling Terraform to plan changes accurately.

3. **Q: Why is remote state important?**
   A: It enables team collaboration by storing state centrally (e.g., S3, Terraform Cloud) with locking, preventing conflicts and keeping local machines from holding the only copy.

4. **Q: What is a Terraform provider?**
   A: A plugin that lets Terraform interact with a specific platform's API (AWS, Azure, GCP, Kubernetes, etc.) to manage its resources.

5. **Q: What is the difference between `terraform plan` and `terraform apply`?**
   A: `plan` shows a preview of changes Terraform would make without applying them; `apply` executes those changes against real infrastructure.

6. **Q: What is a Terraform module?**
   A: A reusable, self-contained package of Terraform configuration (resources, variables, outputs) that can be called multiple times with different inputs.

7. **Q: What is state locking?**
   A: A mechanism (e.g., via DynamoDB with S3 backend) that prevents concurrent Terraform runs from corrupting the state file by acquiring an exclusive lock during operations.

8. **Q: What is the difference between `variables.tf` and `terraform.tfvars`?**
   A: `variables.tf` declares variable names, types, and defaults; `terraform.tfvars` supplies actual values for those variables.

9. **Q: What is an output value in Terraform?**
   A: A way to expose specific values from your configuration (e.g., a resource's IP address) for use by other modules, CLI output, or automation.

10. **Q: What is the purpose of `terraform init`?**
    A: It initializes a working directory — downloading providers/modules and configuring the backend.

11. **Q: What is a data source in Terraform?**
    A: A read-only query for information about existing infrastructure not managed by the current configuration (e.g., looking up an existing VPC ID).

12. **Q: What is the difference between `count` and `for_each`?**
    A: `count` creates multiple resource instances indexed numerically; `for_each` creates instances keyed by map/set values, offering more stable identity when the collection changes.

13. **Q: What is a Terraform workspace?**
    A: A mechanism to manage multiple distinct state files within the same configuration (e.g., dev/staging/prod), switchable via `terraform workspace select`.

14. **Q: What is drift in Terraform, and how do you detect it?**
    A: Drift occurs when real infrastructure changes outside of Terraform (manual edits); `terraform plan` (or `refresh`) detects the difference between state and actual resources.

15. **Q: What is the purpose of the `lifecycle` block?**
    A: It customizes resource behavior, e.g., `create_before_destroy`, `prevent_destroy`, or `ignore_changes` for specific attributes.

16. **Q: What is `terraform import` used for?**
    A: Bringing existing, manually-created infrastructure under Terraform management by mapping it to a resource in state without recreating it.

17. **Q: What is HCL?**
    A: HashiCorp Configuration Language — the declarative, human-readable syntax used to write Terraform configuration files.

18. **Q: What's the difference between a resource and a module block?**
    A: A resource defines a single infrastructure object; a module block invokes a reusable set of resources (a module) as a unit.

19. **Q: What is the Terraform dependency graph?**
    A: An internal DAG (directed acyclic graph) Terraform builds from resource references to determine the correct order of creation, update, and destruction.

20. **Q: What is `terraform destroy`?**
    A: A command that removes all resources managed by the current Terraform configuration/state.

21. **Q: What is the difference between implicit and explicit dependencies in Terraform?**
    A: Implicit dependencies are inferred automatically from resource attribute references; explicit dependencies are declared manually via `depends_on` when no direct reference exists.

22. **Q: What is Terraform Cloud/Enterprise used for?**
    A: A managed service providing remote state storage, remote plan/apply execution, policy enforcement (Sentinel), and collaboration features for teams.

23. **Q: What is a provisioner in Terraform, and why should it be used sparingly?**
    A: A provisioner (e.g., `remote-exec`, `local-exec`) runs scripts on a resource during creation/destruction; it's discouraged as a primary tool since it breaks declarative idempotency and isn't tracked like resource state.

24. **Q: What is the purpose of `.terraform.lock.hcl`?**
    A: It records the exact provider versions used, ensuring consistent provider versions across team members and CI runs.

25. **Q: What is idempotency in the context of Terraform?**
    A: Running the same configuration multiple times produces the same end state — Terraform only applies the diff needed to reconcile actual infrastructure with the desired configuration.

## Scenario-Based

26. **Q: Two engineers ran `terraform apply` at the same time and corrupted the state. How do you prevent this?**
    A: Use a remote backend with state locking (e.g., S3 + DynamoDB lock table, or Terraform Cloud), which blocks concurrent applies until the lock is released.

27. **Q: You need to rename a resource in code without destroying and recreating the actual infrastructure. How?**
    A: Use `terraform state mv` to update the resource's address in state to match the new name, preserving the existing infrastructure.

28. **Q: Your `terraform plan` shows unexpected changes to a resource you didn't modify. What's likely happening and how do you investigate?**
    A: Likely configuration drift (manual changes outside Terraform) or a provider default change — run `terraform plan` with `-refresh-only` or inspect via `terraform state show` to compare.

29. **Q: You need the same infrastructure deployed identically across dev, staging, and prod with different sizing. How do you structure this?**
    A: Create a reusable module for the core infrastructure, and separate `.tfvars` files (or workspaces) per environment supplying different variable values (instance sizes, counts).

30. **Q: A `terraform apply` partially failed midway, creating some resources but not others. What do you do?**
    A: Investigate the error, fix the underlying issue (e.g., quota, naming conflict), then re-run `terraform apply` — Terraform reconciles state and only creates/fixes what's still needed since applied resources are already tracked in state.

31. **Q: You accidentally ran `terraform destroy` against the wrong workspace/environment. How do you prevent this in the future?**
    A: Use separate state files/backends per environment (not just workspaces), enforce `prevent_destroy` lifecycle rules on critical resources, and require manual approval gates in CI/CD for destroy operations.

32. **Q: Your state file contains sensitive data (like DB passwords) in plaintext. How do you secure it?**
    A: Store state in a backend with encryption at rest (e.g., S3 with SSE-KMS), restrict access via IAM policies, and mark sensitive outputs/variables with `sensitive = true` to prevent them showing in CLI output.

33. **Q: You need to import 50 manually-created S3 buckets into Terraform management efficiently. How?**
    A: Write the resource blocks matching each bucket's config, then use `terraform import` per resource (or generate import blocks/use a tool like `terraformer` to bulk-generate configuration and import statements).

34. **Q: A module you depend on was updated with breaking changes upstream. How do you protect your environment?**
    A: Pin the module to a specific version/tag (`source = "...?ref=v1.2.0"`) instead of tracking `main`/latest, and test upgrades in a non-prod environment first.

35. **Q: You need to change an EC2 instance's AMI, but Terraform wants to destroy and recreate it, causing downtime. How do you avoid downtime?**
    A: Use `lifecycle { create_before_destroy = true }` so the new instance is created and healthy before the old one is destroyed (combined with a load balancer for traffic shifting).

36. **Q: Your team wants to enforce that no one can create an unencrypted S3 bucket via Terraform. How?**
    A: Use policy-as-code (Sentinel in Terraform Enterprise/Cloud, or Open Policy Agent/Checkov in CI) to validate plans against compliance rules before allowing apply.

37. **Q: You need to reference an existing VPC that was created manually (not by Terraform) in your configuration. How?**
    A: Use a `data` source (e.g., `data "aws_vpc"`) to query the existing VPC by tag/ID, referencing its attributes without managing its lifecycle.

38. **Q: Your CI/CD pipeline needs to run `terraform apply` automatically but safely. How do you design this?**
    A: Run `terraform plan` and require manual/PR approval of the plan output before an automated `apply` stage, using remote state locking and least-privilege CI credentials.

39. **Q: You have 100+ nearly identical resources (e.g., IAM users) to create. How do you avoid writing 100 resource blocks?**
    A: Use `for_each` over a map/set of names/configs to dynamically generate all resource instances from one resource block.

40. **Q: A resource was deleted manually in the cloud console, but Terraform still thinks it exists. What happens on the next apply, and how do you handle it?**
    A: `terraform plan` will show it needs to be recreated (since it detects it's missing); confirm that's intended, or if it should just be removed from state, use `terraform state rm`.

41. **Q: You need zero-downtime blue-green infrastructure switching using Terraform. How would you approach it?**
    A: Provision the new (green) environment fully via Terraform alongside the existing (blue), then update DNS/load balancer target via a Terraform-managed resource to cut over, keeping blue available for rollback.

42. **Q: Your Terraform runs are slow because of a huge monolithic configuration managing hundreds of resources. How do you improve this?**
    A: Split the configuration into smaller, independently-stated components (e.g., per service/environment) using separate state files, and use `terraform_remote_state` or data sources to reference outputs across them.

43. **Q: How do you handle secrets (like API keys) needed as Terraform input variables without hardcoding them in `.tfvars` committed to Git?**
    A: Pull secrets at runtime from a secrets manager (AWS Secrets Manager, Vault) via a data source, or inject them as environment variables (`TF_VAR_...`) in CI, never committing them to version control.

44. **Q: A colleague's `terraform apply` is going to destroy a critical production database due to a config change. How do you prevent accidental destruction?**
    A: Add `lifecycle { prevent_destroy = true }` to the resource, and always review `terraform plan` output carefully in CI before approving apply.

45. **Q: You need to test infrastructure changes without affecting real cloud resources. How?**
    A: Use `terraform plan` to preview changes, or tools like `terraform validate`/`checkov` for static analysis, and consider a separate sandbox account/workspace for safe experimentation.

46. **Q: Your organization manages 10 AWS accounts with Terraform. How do you structure this cleanly?**
    A: Use separate state files per account/environment, assume-role provider configurations per account, and shared modules in a central repo referenced by version, often orchestrated via Terragrunt or a CI pipeline per environment.

47. **Q: A `terraform apply` is going to replace a resource because of a change to an immutable attribute, but you need to preserve the resource's data. How do you handle it?**
    A: Check if there's an alternative (like an in-place update workaround), or plan for data migration/backup before the replace, and consider `create_before_destroy` with a data migration step if applicable.

48. **Q: You want to know exactly what changed between two Terraform applies for audit purposes. How?**
    A: Save `terraform plan -out=plan.tfplan` output files with timestamps in CI artifacts, or use Terraform Cloud's run history, which logs every plan/apply with diffs.

49. **Q: Your `terraform.tfstate` file was accidentally deleted. How do you recover?**
    A: Restore from backend versioning (e.g., S3 versioning) if enabled; otherwise, rebuild state using `terraform import` for each existing resource, which is time-consuming — reinforcing the need for versioned remote state.

50. **Q: You need to enforce consistent tagging (e.g., cost-center, owner) across all resources company-wide. How do you implement this in Terraform?**
    A: Use a `default_tags` block at the provider level (for supported providers like AWS) and/or a shared module wrapper, combined with policy-as-code checks (Sentinel/OPA) to reject untagged resources.
