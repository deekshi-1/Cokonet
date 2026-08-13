# Jenkins — 50 Q&A (25 Theory + 25 Scenario)

## Theory-Based

1. **Q: What is Jenkins?**
   A: An open-source automation server used to build, test, and deploy software through CI/CD pipelines, extensible via plugins.

2. **Q: What is the difference between Freestyle and Pipeline jobs?**
   A: Freestyle jobs are configured through the UI with limited flexibility; Pipeline jobs are defined as code (Jenkinsfile) using Groovy DSL, enabling version control and complex logic.

3. **Q: What is a Jenkinsfile?**
   A: A text file (checked into source control) that defines a Jenkins Pipeline using Declarative or Scripted syntax.

4. **Q: Difference between Declarative and Scripted Pipeline?**
   A: Declarative uses a structured, opinionated syntax (easier to read/validate) with a defined `pipeline {}` block; Scripted uses full Groovy for maximum flexibility but more complexity.

5. **Q: What are Jenkins agents/nodes?**
   A: Machines (physical, VM, or containers) that execute build jobs; the "master/controller" schedules and dispatches work to them.

6. **Q: What is a Jenkins plugin?**
   A: An extension that adds functionality to Jenkins — SCM integrations, build tools, notifications, UI enhancements, etc.

7. **Q: What is the purpose of the Jenkins Master/Controller?**
   A: It manages job scheduling, dispatches builds to agents, serves the web UI, and stores configuration and build history.

8. **Q: What are build triggers in Jenkins?**
   A: Mechanisms that start a job automatically — SCM polling, webhooks, scheduled (cron), upstream job completion, or manual triggers.

9. **Q: What is a stage in a Jenkins Pipeline?**
   A: A logically distinct segment of a pipeline (e.g., Build, Test, Deploy) shown as a discrete step in the Pipeline visualization.

10. **Q: What is Blue Ocean?**
    A: A Jenkins plugin providing a modern, visual UI for creating and viewing pipelines.

11. **Q: How does Jenkins integrate with version control systems?**
    A: Via SCM plugins (Git, SVN) that clone repos, poll or receive webhooks for changes, and trigger builds automatically.

12. **Q: What are Jenkins credentials and the Credentials plugin?**
    A: A secure store for secrets (passwords, tokens, SSH keys) that pipelines reference by ID instead of hardcoding sensitive values.

13. **Q: What is a post section in a Declarative Pipeline?**
    A: A block defining actions to run after pipeline/stage completion, based on status (`always`, `success`, `failure`, `unstable`, `changed`).

14. **Q: What is parallel execution in Jenkins pipelines?**
    A: Running multiple stages/steps concurrently using the `parallel` directive to speed up pipeline execution.

15. **Q: What's the difference between a shared library and a global function in Jenkins?**
    A: A shared library is a versioned, reusable set of Groovy scripts/steps imported across multiple Jenkinsfiles, promoting DRY pipeline code.

16. **Q: What is the purpose of `agent` in a Jenkinsfile?**
    A: It specifies where the pipeline or stage executes — `any`, a specific label, a Docker container, or `none` for stage-level agents.

17. **Q: What is Jenkins' role in a CI/CD pipeline?**
    A: It automates building, testing, and deploying code changes, providing fast feedback and enabling continuous delivery.

18. **Q: What is the difference between CI and CD?**
    A: CI (Continuous Integration) is frequently merging and testing code; CD is Continuous Delivery/Deployment — automatically preparing (or releasing) validated builds to production-like or production environments.

19. **Q: How does Jenkins handle build artifacts?**
    A: Via `archiveArtifacts` to store build outputs on the controller, or by publishing to external repositories (Nexus, Artifactory, S3).

20. **Q: What is a webhook and how is it used with Jenkins?**
    A: An HTTP callback from a source (like GitHub) that notifies Jenkins instantly when a code event occurs, triggering a build without polling delay.

21. **Q: What is the Jenkinsfile `environment` block used for?**
    A: To define environment variables (including secrets via `credentials()`) available throughout the pipeline or a specific stage.

22. **Q: What is a matrix build in Jenkins?**
    A: A build configuration that runs the same job across multiple combinations of variables (e.g., OS x language version) in parallel.

23. **Q: How can Jenkins be scaled for large teams?**
    A: By adding distributed build agents (static or dynamic via Kubernetes/cloud plugins), load-balancing jobs across them.

24. **Q: What is the purpose of the `input` step in Jenkins Pipeline?**
    A: It pauses the pipeline to require manual approval/input before proceeding, commonly used for production deployment gates.

25. **Q: What is Jenkins X?**
    A: A Kubernetes-native CI/CD platform built on Jenkins pipeline concepts, designed for cloud-native automation with GitOps.

## Scenario-Based

26. **Q: Your Jenkinsfile has hardcoded API keys committed to Git. How do you fix this securely?**
    A: Remove the secrets from code/history, store them in Jenkins Credentials Manager, and reference them via `credentials()` binding in the pipeline.

27. **Q: Your pipeline works locally but fails on Jenkins with "command not found." What's likely wrong and how do you fix it?**
    A: The agent's PATH/environment differs from your local shell — install/verify the required tool on the agent, use a tool installer, or run inside a Docker agent with the tool pre-installed.

28. **Q: Builds are queued for a long time waiting for executors. How do you resolve this?**
    A: Add more build agents/executors, use a cloud-based dynamic agent provisioner (e.g., Kubernetes plugin), or distribute jobs across a node pool.

29. **Q: You need different deployment behavior for `main` vs feature branches. How do you implement this in a Jenkinsfile?**
    A: Use `when { branch 'main' }` conditions on stages, or `BRANCH_NAME` env variable checks to gate deploy steps.

30. **Q: A flaky test occasionally fails builds. How do you handle it without ignoring test failures generally?**
    A: Mark the specific test as retried/quarantined (e.g., `retry()` step or a separate quarantine stage), fix root cause, and avoid globally disabling test failures.

31. **Q: Your team wants every PR to run tests before merging. How do you configure this?**
    A: Set up a Multibranch Pipeline job with GitHub/GitLab webhook integration and branch protection rules requiring the Jenkins status check to pass.

32. **Q: Production deployment should require manual approval after tests pass. How do you implement this?**
    A: Add an `input` step (with a timeout) in the pipeline before the deploy stage, restricted to authorized approvers via RBAC.

33. **Q: A shared library update broke pipelines across many repos. How could you have prevented this?**
    A: Version-pin the shared library (`@Library('my-lib@v1.2')`) instead of always using the latest, and test library changes in a staging pipeline first.

34. **Q: You need to build Docker images and push them to a private registry from Jenkins. How do you set this up?**
    A: Use the Docker Pipeline plugin, authenticate to the registry using stored credentials, then `docker build` and `docker push` within pipeline steps, ideally on a Docker-enabled agent.

35. **Q: Your Jenkins controller crashed and lost job history. How do you prevent this going forward?**
    A: Regularly back up `JENKINS_HOME`, use Configuration-as-Code (JCasC) for reproducible setup, and consider running Jenkins in HA or on persistent storage.

36. **Q: A pipeline stage needs to run only if a specific file changed. How do you implement that?**
    A: Use a `when { changeset "path/**" }` condition, or a script step that checks git diff output before executing the stage.

37. **Q: Multiple teams share one Jenkins instance and need isolated permissions. How do you configure this?**
    A: Use Role-Based Access Control (RBAC) plugin with folder-based permissions, giving each team access scoped to their own job folders.

38. **Q: Your build takes 40 minutes and slows delivery. How would you speed it up?**
    A: Parallelize independent stages/tests, cache dependencies between builds, use incremental builds, and add more powerful/parallel agents.

39. **Q: You need to trigger a downstream pipeline only if the upstream one succeeds. How?**
    A: Use the `build job: 'downstream-job'` step within a `post { success {} }` block, or configure a pipeline trigger on upstream job completion.

40. **Q: How do you migrate Jenkins configuration to a new server reliably?**
    A: Use Jenkins Configuration as Code (JCasC) to define config declaratively, and copy `JENKINS_HOME` (jobs, plugins, credentials) or use the plugin installation manager tool.

41. **Q: A secret was accidentally printed in build console logs. What do you do?**
    A: Rotate the exposed credential immediately, mask it going forward using the `maskPasswords` plugin/credential binding (which auto-masks), and audit who had console log access.

42. **Q: You need consistent, ephemeral build environments to avoid "works on one agent but not another." What approach do you use?**
    A: Run builds inside Docker containers as agents (`agent { docker { image '...' } }`) so each build gets a clean, consistent environment.

43. **Q: Your Jenkins server needs to scale up during peak hours and down at night to save cost. How?**
    A: Use a cloud dynamic agent plugin (EC2, Kubernetes) that provisions agents on demand and terminates them when idle.

44. **Q: A critical pipeline step failed midway, leaving resources in a bad state (e.g., partially deployed). How do you handle this safely?**
    A: Add a `post { failure {} }` block with cleanup/rollback logic, and design deployment steps to be idempotent or use a proper rollback mechanism (e.g., blue/green switch-back).

45. **Q: How would you test a change to a Jenkinsfile itself before merging?**
    A: Use the "Replay" feature or a separate test branch/Multibranch Pipeline job to validate the Jenkinsfile changes without affecting main.

46. **Q: Your organization needs compliance auditing of who triggered which deployment. How do you achieve this in Jenkins?**
    A: Enable the Audit Trail plugin to log job triggers/config changes with user attribution, and integrate with centralized logging (e.g., ELK).

47. **Q: A Jenkins pipeline needs to notify Slack on failure only. How do you implement this?**
    A: Use the Slack Notification plugin inside a `post { failure { slackSend(...) } }` block.

48. **Q: You want to avoid duplicating pipeline logic across 50 microservice repos. What's the best approach?**
    A: Create a Jenkins Shared Library with common pipeline steps/templates, and have each repo's Jenkinsfile simply call the shared function with parameters.

49. **Q: Jenkins agents intermittently lose connection to the controller during long builds. How do you troubleshoot?**
    A: Check network stability/firewall rules between controller and agent, agent JVM resource limits, and consider increasing the agent's keep-alive/timeout settings.

50. **Q: How would you implement a canary deployment strategy using Jenkins?**
    A: Add pipeline stages that deploy to a small subset of infrastructure/traffic first, run automated health checks/metrics validation, then proceed to full rollout only if the canary passes (often integrating with Kubernetes or a service mesh).
