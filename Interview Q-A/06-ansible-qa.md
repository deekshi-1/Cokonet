# Ansible — 50 Q&A (25 Theory + 25 Scenario)

## Theory-Based

1. **Q: What is Ansible?**
   A: An open-source, agentless automation tool used for configuration management, application deployment, and orchestration, using YAML-based playbooks over SSH.

2. **Q: Why is Ansible called "agentless"?**
   A: It doesn't require any software installed on managed nodes — it connects via SSH (or WinRM for Windows) and executes modules using Python already present (or pushed temporarily).

3. **Q: What is a Playbook?**
   A: A YAML file defining a set of plays (ordered tasks) to be executed against specified hosts/groups to achieve a desired state.

4. **Q: What is an Inventory in Ansible?**
   A: A file (INI, YAML, or dynamic script) listing the managed hosts and groups Ansible can target, optionally with host/group variables.

5. **Q: What is a Module in Ansible?**
   A: A discrete unit of code (e.g., `apt`, `copy`, `service`) that Ansible executes on target hosts to perform a specific task idempotently.

6. **Q: What is idempotency in Ansible, and why does it matter?**
   A: Running a task repeatedly produces the same result without unintended side effects — modules check current state before making changes, ensuring safe, repeatable runs.

7. **Q: What is a Role in Ansible?**
   A: A structured, reusable way of organizing playbooks — bundling tasks, handlers, variables, templates, and files into a standard directory layout for reuse.

8. **Q: What is a Handler?**
   A: A special task triggered only when notified by another task (typically via `notify`), commonly used to restart services only when a config actually changed.

9. **Q: What is the difference between `ansible` (ad-hoc command) and `ansible-playbook`?**
   A: `ansible` runs a single module/command against hosts for quick one-off tasks; `ansible-playbook` executes a full YAML playbook with multiple ordered tasks.

10. **Q: What is a Fact in Ansible?**
    A: System information (OS, IP, memory, etc.) automatically gathered from managed nodes at the start of a play via the `setup` module, usable as variables.

11. **Q: What is Ansible Galaxy?**
    A: A public repository for sharing and downloading community-built Ansible roles and collections.

12. **Q: What is a Collection in Ansible?**
    A: A packaging format bundling playbooks, roles, modules, and plugins together for distribution, extending Ansible's built-in capabilities (e.g., `amazon.aws`).

13. **Q: What is the difference between `vars` and `vars_files`?**
    A: `vars` defines variables inline within a playbook; `vars_files` loads variables from external YAML files, useful for separating config from logic.

14. **Q: What is Ansible Vault?**
    A: A feature for encrypting sensitive data (passwords, keys) within YAML files so secrets can be safely stored in version control.

15. **Q: What is the difference between `when` and `failed_when` in Ansible?**
    A: `when` conditionally skips/runs a task based on a condition; `failed_when` overrides the default logic for determining whether a task's result counts as failed.

16. **Q: What are Ansible templates (Jinja2)?**
    A: Files with `.j2` extension using Jinja2 templating syntax to dynamically generate configuration files based on variables, deployed via the `template` module.

17. **Q: What is the difference between `copy` and `template` modules?**
    A: `copy` transfers a static file as-is; `template` renders a Jinja2 template with variable substitution before placing the file on the target.

18. **Q: What is idempotent vs non-idempotent module behavior — give an example.**
    A: The `apt` module with `state: present` is idempotent (won't reinstall if already present); using `command`/`shell` to run arbitrary commands is often non-idempotent unless carefully guarded with conditionals.

19. **Q: What is a dynamic inventory?**
    A: An inventory sourced dynamically from an external system (e.g., AWS EC2 API, Azure) rather than a static file, keeping host lists automatically up to date.

20. **Q: What is the purpose of `ansible.cfg`?**
    A: A configuration file setting Ansible's default behavior (inventory path, SSH settings, parallelism/forks, retry behavior, etc.).

21. **Q: What is `become` used for in Ansible?**
    A: It enables privilege escalation (e.g., `sudo`) so tasks run with elevated permissions on the target host when needed.

22. **Q: What is the difference between a Play and a Task?**
    A: A Play maps a group of hosts to a set of roles/tasks; a Task is a single action (module invocation) within a play.

23. **Q: What is `ansible-lint`?**
    A: A static analysis tool that checks playbooks/roles for best practices, style issues, and potential errors before execution.

24. **Q: What are tags in Ansible, and why use them?**
    A: Labels applied to tasks/roles/plays allowing selective execution (`--tags`) or exclusion (`--skip-tags`) of parts of a playbook without running everything.

25. **Q: What is the difference between push-based (Ansible) and pull-based (e.g., Puppet agent) configuration management?**
    A: Push-based tools like Ansible initiate connections from a control node to targets on demand; pull-based tools have agents on targets periodically checking in and applying config themselves.

## Scenario-Based

26. **Q: You need to configure 200 servers identically but want to avoid re-running unnecessary changes each time. How does Ansible help?**
    A: Ansible modules are idempotent by design — running the same playbook repeatedly only applies changes where the actual state differs from the desired state, skipping no-op tasks.

27. **Q: A playbook run partially fails on some hosts. How do you re-run it only against the failed hosts?**
    A: Use the auto-generated `.retry` file (or `--limit @retry-file.retry`) to target only hosts that failed in the previous run.

28. **Q: You need to store a database password in a playbook that will be committed to Git. How do you do this securely?**
    A: Encrypt the variable/file using Ansible Vault (`ansible-vault encrypt`), so the committed file is encrypted and only decryptable with the vault password/key at runtime.

29. **Q: A task should restart a service only if a config file actually changed, not on every run. How do you implement this?**
    A: Use a `notify` on the config-deploying task pointing to a `handler` that restarts the service — handlers only run when notified by a changed task, and only once at the end of the play.

30. **Q: Your playbook needs different variable values for web servers vs database servers. How do you organize this?**
    A: Use group_vars (`group_vars/webservers.yml`, `group_vars/dbservers.yml`) tied to inventory groups, so variables are automatically applied based on group membership.

31. **Q: You need to run a playbook against newly launched AWS EC2 instances without manually updating an inventory file. How?**
    A: Use a dynamic inventory plugin (e.g., `amazon.aws.aws_ec2`) that queries AWS in real time and builds the inventory automatically based on tags/filters.

32. **Q: A critical task should stop the entire playbook run immediately if it fails, across all hosts, not just skip that host. How?**
    A: Use `any_errors_fatal: true` at the play level, which aborts the whole run for all hosts if any host encounters a failure.

33. **Q: You need to deploy an application with zero downtime across a load-balanced pool of servers. How would you structure the playbook?**
    A: Use a rolling update pattern — set `serial: 1` (or a small batch), remove the host from the load balancer, deploy/update, run health checks, re-add to the LB, then proceed to the next host/batch.

34. **Q: Your playbook works in testing but fails in production due to different OS versions across hosts. How do you handle OS-specific differences?**
    A: Use `when` conditionals with gathered facts (e.g., `ansible_facts['os_family']`) or OS-specific variable files (`vars/RedHat.yml`, `vars/Debian.yml`) included conditionally.

35. **Q: You need to ensure a specific package version is installed, not just "any" version, across environments. How do you enforce this?**
    A: Specify the exact version in the module parameters, e.g., `apt: name=nginx=1.18.0-0ubuntu1 state=present`, pinning to that version explicitly.

36. **Q: A playbook needs to run some tasks only in production, skipping them in staging. How do you implement this?**
    A: Use a `when: env == "production"` condition referencing an inventory or extra-var (`-e env=production`) that defines the environment.

37. **Q: Your team has duplicated the same 15 tasks across 6 different playbooks. How do you reduce duplication?**
    A: Extract the shared tasks into a reusable Role (or an `include_tasks`/`import_tasks` file) and reference it from each playbook.

38. **Q: You need to verify a deployed application is actually healthy before marking the deployment successful. How do you implement this in Ansible?**
    A: Add a task using the `uri` module (or a custom health-check script) with `retries`/`until` to poll a health endpoint, failing the play if it doesn't return healthy within the retry window.

39. **Q: A sensitive production run must require explicit confirmation before executing. How do you add a safety gate?**
    A: Use `--check` (dry-run) mode first to preview changes, and/or add a `pause` task or a CI/CD manual approval step before the actual `ansible-playbook` run against production.

40. **Q: Your inventory has hundreds of hosts, and running tasks sequentially is too slow. How do you speed this up?**
    A: Increase parallelism using `forks` in `ansible.cfg` (or `-f` flag) so Ansible executes tasks against more hosts simultaneously.

41. **Q: You need to pull secrets from HashiCorp Vault (not Ansible Vault) at runtime instead of storing them anywhere in playbooks. How?**
    A: Use the `community.hashi_vault` collection's lookup plugin to fetch secrets dynamically from Vault during playbook execution.

42. **Q: A task needs to run on the Ansible control node itself, not the remote targets (e.g., generating a local report). How?**
    A: Set `delegate_to: localhost` (or use `local_action`) on that specific task.

43. **Q: You've made a typo in a playbook that could break production if run directly. How do you catch this before it causes damage?**
    A: Run `ansible-playbook --check --diff` for a dry run showing what would change, use `ansible-lint` for static validation, and test in a staging environment first.

44. **Q: Your organization wants centralized visibility, RBAC, and scheduling for Ansible runs across teams. What would you use?**
    A: Ansible Automation Platform (AWX/Ansible Tower) provides a web UI, RBAC, job scheduling, credential management, and centralized logging on top of core Ansible.

45. **Q: You need to configure servers differently based on custom tags/metadata (e.g., `role=web`, `role=db`) from a cloud provider. How?**
    A: Use a dynamic inventory plugin that maps cloud tags to Ansible groups (e.g., via `keyed_groups` in the inventory plugin config), then apply group_vars/roles accordingly.

46. **Q: A long-running playbook needs to be resumable if it's interrupted partway through a large host list. How?**
    A: Use `--start-at-task` to resume from a specific task, or design idempotent playbooks so simply re-running from the start safely skips already-completed changes.

47. **Q: You need to orchestrate a multi-tier deployment (DB migration, then app servers, then cache warm-up) in the correct order across different host groups. How do you structure this?**
    A: Define multiple plays within one playbook, each targeting a different host group in sequence (DB group first, then app group, then cache group), since plays execute top-to-bottom.

48. **Q: Your playbook needs to behave differently the first time it runs (initial setup) versus subsequent runs (updates only). How do you handle this?**
    A: Use `creates`/`removes` arguments on relevant modules (like `command`) to make tasks conditional on file existence, or check facts/state and use `when` conditions to skip already-completed setup steps.

49. **Q: You want to test playbook changes safely without affecting real infrastructure. How?**
    A: Use `--check` mode combined with `--diff` for a dry run, and/or spin up disposable test environments (e.g., Vagrant, Molecule testing framework) to validate roles before production use.

50. **Q: How would you implement a blue-green deployment strategy using Ansible?**
    A: Provision a parallel "green" environment via playbooks/roles, run deployment and health-check tasks against it, then use a task to update the load balancer/DNS to point to green once verified, keeping blue as instant rollback.
