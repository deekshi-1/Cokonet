# Kubernetes (K8s) — 50 Q&A (25 Theory + 25 Scenario)

## Theory-Based

1. **Q: What is Kubernetes?**
   A: An open-source container orchestration platform that automates deployment, scaling, networking, and management of containerized applications.

2. **Q: What is a Pod?**
   A: The smallest deployable unit in Kubernetes — one or more tightly coupled containers sharing network namespace and storage.

3. **Q: What is the difference between a Deployment and a StatefulSet?**
   A: Deployments manage stateless, interchangeable replica Pods; StatefulSets manage Pods needing stable identities, persistent storage, and ordered deployment/scaling — for stateful apps like databases.

4. **Q: What is a Service in Kubernetes?**
   A: An abstraction that provides a stable IP/DNS name and load-balances traffic to a dynamic set of Pods, decoupling clients from Pod churn.

5. **Q: What are the types of Kubernetes Services?**
   A: ClusterIP (internal only, default), NodePort (exposes a port on each node), LoadBalancer (provisions an external cloud LB), and ExternalName (DNS alias).

6. **Q: What is a Namespace?**
   A: A virtual cluster partition used to logically isolate and organize resources (e.g., by team or environment) within a single physical cluster.

7. **Q: What is the role of the kube-apiserver?**
   A: The central control plane component that exposes the Kubernetes API, validating and processing all REST requests, acting as the front door to the cluster.

8. **Q: What is etcd?**
   A: A distributed, consistent key-value store that holds all cluster state and configuration data.

9. **Q: What does the kube-scheduler do?**
   A: It assigns newly created Pods to suitable Nodes based on resource requirements, constraints, and policies.

10. **Q: What is the kubelet?**
    A: An agent running on each Node that ensures containers described in PodSpecs are running and healthy, communicating with the control plane.

11. **Q: What is a ReplicaSet?**
    A: A controller that ensures a specified number of identical Pod replicas are running at all times; typically managed indirectly via Deployments.

12. **Q: What is a ConfigMap?**
    A: An object for storing non-sensitive configuration data as key-value pairs, injectable into Pods as environment variables or files.

13. **Q: What is a Secret?**
    A: Similar to a ConfigMap but intended for sensitive data (passwords, tokens, keys), base64-encoded by default (not encrypted unless configured with encryption at rest).

14. **Q: What is a PersistentVolume (PV) and PersistentVolumeClaim (PVC)?**
    A: A PV is a cluster-level piece of storage provisioned by an admin or dynamically; a PVC is a user's request for storage that binds to a matching PV.

15. **Q: What is an Ingress?**
    A: An API object managing external HTTP/HTTPS access to Services within a cluster, typically providing routing rules, TLS termination, and virtual hosting.

16. **Q: What is a DaemonSet?**
    A: A controller ensuring a copy of a Pod runs on every (or selected) Node — commonly used for log collectors, monitoring agents, or network plugins.

17. **Q: What are readiness and liveness probes?**
    A: Liveness probes detect if a container needs to be restarted (unhealthy); readiness probes detect if a container is ready to receive traffic — both configurable via HTTP, TCP, or exec checks.

18. **Q: What is a Kubernetes Job vs CronJob?**
    A: A Job runs a Pod to completion for a one-off task; a CronJob schedules Jobs to run repeatedly on a cron schedule.

19. **Q: What is Horizontal Pod Autoscaling (HPA)?**
    A: A controller that automatically scales the number of Pod replicas based on observed metrics like CPU/memory utilization or custom metrics.

20. **Q: What is the difference between a Node and a Cluster?**
    A: A Node is a single worker machine (VM or physical) running Pods; a Cluster is the full set of Nodes plus the control plane managing them.

21. **Q: What is a Helm chart?**
    A: A packaged collection of Kubernetes manifest templates with configurable values, used by Helm (a package manager) to install/upgrade applications.

22. **Q: What is RBAC in Kubernetes?**
    A: Role-Based Access Control — a mechanism to define what actions (verbs) users/service accounts can perform on which resources, via Roles/ClusterRoles and RoleBindings/ClusterRoleBindings.

23. **Q: What is a Taint and Toleration?**
    A: Taints are applied to Nodes to repel Pods unless the Pod has a matching Toleration, used to control which Pods can be scheduled onto certain Nodes.

24. **Q: What is the difference between a Rolling Update and a Recreate deployment strategy?**
    A: Rolling Update gradually replaces old Pods with new ones with no downtime; Recreate terminates all old Pods before creating new ones, causing brief downtime.

25. **Q: What is a Sidecar container pattern?**
    A: Running a helper container alongside the main application container in the same Pod (e.g., for logging, proxying, or service mesh injection) sharing network/storage.

## Scenario-Based

26. **Q: A Pod is stuck in `Pending` state. How do you diagnose it?**
    A: Run `kubectl describe pod <name>` to check Events — common causes are insufficient node resources, unschedulable due to taints/affinity rules, or unbound PVCs.

27. **Q: A Pod is in `CrashLoopBackOff`. How do you troubleshoot?**
    A: Check `kubectl logs <pod> --previous` for the crash reason, verify the container's command/entrypoint, and confirm required config/secrets/env vars are present.

28. **Q: Your application needs zero-downtime deployments. How do you configure this in Kubernetes?**
    A: Use a Deployment with RollingUpdate strategy, proper readiness probes, and `maxUnavailable`/`maxSurge` settings so traffic only shifts to healthy new Pods.

29. **Q: Traffic to your Service isn't reaching any Pods despite them running. What do you check?**
    A: Verify the Service's selector labels match the Pod labels exactly, confirm Pods are in `Ready` state, and check Endpoints (`kubectl get endpoints`) are populated.

30. **Q: Your app needs to scale automatically under load. How do you implement this?**
    A: Configure an HPA targeting the Deployment based on CPU/memory or custom metrics, ensuring resource requests/limits are set so utilization can be calculated.

31. **Q: A Node goes down unexpectedly. What happens to the Pods running on it, and how does Kubernetes recover?**
    A: The control plane detects the Node as `NotReady` after a timeout, and if the Pods belong to a controller (Deployment/ReplicaSet), it reschedules replacement Pods onto healthy Nodes.

32. **Q: You need to store a database password securely and inject it into a Pod. How?**
    A: Create a Kubernetes Secret (ideally with encryption at rest enabled, or via an external secrets manager/CSI driver), and mount it as an env var or volume in the Pod spec.

33. **Q: Multiple teams share a cluster and you need to prevent one team's workload from starving others of resources. How?**
    A: Use Namespaces per team with ResourceQuotas and LimitRanges to cap CPU/memory consumption, plus RBAC to restrict access.

34. **Q: You need to route external traffic to multiple services under different URL paths with a single load balancer. How?**
    A: Deploy an Ingress Controller (e.g., NGINX, ALB Ingress) and define Ingress rules mapping paths/hosts to different backend Services.

35. **Q: A rolling update deployed a buggy version to production. How do you roll back quickly?**
    A: Run `kubectl rollout undo deployment/<name>` to revert to the previous ReplicaSet revision.

36. **Q: Your stateful application (e.g., a database) needs stable network identity and storage across restarts. What resource do you use?**
    A: A StatefulSet with a headless Service, giving each Pod a stable hostname and a bound PersistentVolumeClaim that persists across rescheduling.

37. **Q: You want certain workloads to run only on GPU-enabled nodes. How do you enforce this?**
    A: Label/taint the GPU nodes, then use nodeSelector/nodeAffinity (matching the label) and tolerations on the Pod spec to schedule only there.

38. **Q: Your cluster is running out of resources during peak hours. How do you address this?**
    A: Enable Cluster Autoscaler to add Nodes automatically based on pending unschedulable Pods, alongside HPA for Pod-level scaling.

39. **Q: You need to test a new version of a service on a small percentage of live traffic before full rollout. How?**
    A: Implement a canary deployment — run a small ReplicaSet of the new version alongside the stable one, controlling traffic split via Service weighting or a service mesh (e.g., Istio).

40. **Q: A developer's Pod can access resources it shouldn't (e.g., other namespaces' secrets). How do you lock this down?**
    A: Apply RBAC Roles/RoleBindings scoped to the Namespace, ensure least-privilege ServiceAccounts, and consider NetworkPolicies restricting cross-namespace traffic.

41. **Q: Your app's config changes require a full redeploy currently. How do you make config updates without rebuilding images?**
    A: Externalize config into a ConfigMap/Secret mounted as a volume or env vars, and use a tool (or manual rollout restart) to pick up changes without rebuilding.

42. **Q: You need to debug a live issue in production without disrupting the running Pod. What do you do?**
    A: Use `kubectl exec -it <pod> -- sh` to get a shell inside the container, or `kubectl debug` to attach an ephemeral debug container without restarting the Pod.

43. **Q: How would you prevent a misconfigured Pod from consuming all Node memory and crashing other Pods?**
    A: Set resource `requests` and `limits` on the container spec so the scheduler places it appropriately and the kubelet enforces memory limits (OOM-killing only that Pod if exceeded).

44. **Q: Your services need encrypted communication between each other inside the cluster. How do you achieve this without changing app code?**
    A: Deploy a service mesh (e.g., Istio, Linkerd) that injects sidecar proxies to automatically handle mutual TLS between services.

45. **Q: You accidentally deleted a Deployment in production. How do you recover quickly?**
    A: If using GitOps (e.g., ArgoCD/Flux), the deployment self-heals by reapplying the last committed manifest; otherwise, reapply the YAML from version control/backup immediately.

46. **Q: A batch job needs to run every night and shouldn't overlap if the previous run is still going. How do you configure this?**
    A: Use a CronJob with `concurrencyPolicy: Forbid` to prevent overlapping executions.

47. **Q: Your application logs need centralized collection across all Pods in the cluster. How do you set this up?**
    A: Deploy a logging agent (e.g., Fluentd/Fluent Bit) as a DaemonSet on every Node to collect container logs and forward them to a central store like Elasticsearch or a cloud logging service.

48. **Q: You need to migrate a running application to a new cluster with zero downtime. How would you approach this?**
    A: Set up the new cluster, deploy the app there, use DNS/load balancer weighted cutover (or a shared external LB) to gradually shift traffic, then decommission the old cluster once validated.

49. **Q: A Pod needs to talk to an external database only, and you want to enforce that it can't reach other internal services. How?**
    A: Apply a NetworkPolicy that denies all egress by default and explicitly allows egress only to the external database's IP/port.

50. **Q: How would you implement blue-green deployment in Kubernetes?**
    A: Deploy the new version as a separate Deployment (green) alongside the current one (blue), then switch the Service selector to point to the green Deployment once validated, allowing instant rollback by switching back.
