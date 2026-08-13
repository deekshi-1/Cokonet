# AWS — 50 Q&A (25 Theory + 25 Scenario)

## Theory-Based

1. **Q: What is AWS and what are its core service categories?**
   A: AWS (Amazon Web Services) is a cloud platform offering on-demand compute, storage, networking, database, and application services. Core categories include EC2 (compute), S3 (storage), RDS (database), VPC (networking), and IAM (identity).

2. **Q: What is the difference between EC2 and Lambda?**
   A: EC2 provides persistent virtual servers you manage and pay for continuously, while Lambda is serverless — code runs on-demand in response to events and you pay only for execution time.

3. **Q: What is an AMI?**
   A: An Amazon Machine Image is a template containing an OS, application server, and applications used to launch EC2 instances.

4. **Q: What is the difference between Security Groups and NACLs?**
   A: Security Groups are stateful, instance-level firewalls (return traffic auto-allowed); NACLs are stateless, subnet-level firewalls requiring explicit inbound and outbound rules.

5. **Q: What is a VPC?**
   A: A Virtual Private Cloud is a logically isolated section of AWS where you launch resources in a custom-defined virtual network with control over IP ranges, subnets, route tables, and gateways.

6. **Q: Explain the difference between S3 storage classes.**
   A: Standard is for frequently accessed data; Standard-IA/One Zone-IA for infrequent access; Glacier and Glacier Deep Archive for long-term archival with retrieval delays; Intelligent-Tiering auto-moves data based on access patterns.

7. **Q: What is IAM and why is least privilege important?**
   A: IAM (Identity and Access Management) controls authentication and authorization to AWS resources. Least privilege minimizes the attack surface by granting only the permissions necessary for a task.

8. **Q: Difference between IAM roles and IAM users?**
   A: Users are permanent identities with long-term credentials for people/apps; roles are temporary identities assumed by trusted entities (services, users, accounts) without long-term credentials.

9. **Q: What is Auto Scaling?**
   A: A service that automatically adjusts the number of EC2 instances in a group based on demand, defined by scaling policies and health checks.

10. **Q: What is an Elastic Load Balancer (ELB)?**
    A: A service that distributes incoming traffic across multiple targets (EC2, containers, IPs) to improve availability and fault tolerance. Types include ALB, NLB, and the legacy CLB.

11. **Q: What's the difference between RDS and DynamoDB?**
    A: RDS is a managed relational (SQL) database service; DynamoDB is a managed NoSQL key-value/document database designed for high scalability and low-latency access.

12. **Q: What is CloudFormation?**
    A: An Infrastructure-as-Code service that lets you define AWS resources in JSON/YAML templates and provisions/updates them as a "stack."

13. **Q: What is the AWS shared responsibility model?**
    A: AWS is responsible for security "of" the cloud (infrastructure, hardware, global network); the customer is responsible for security "in" the cloud (data, IAM, OS patching, configs).

14. **Q: What is Route 53?**
    A: AWS's scalable DNS and domain registration service, also supporting health checks and routing policies (weighted, latency-based, geolocation, failover).

15. **Q: What is CloudWatch used for?**
    A: Monitoring AWS resources and applications — collecting metrics, logs, setting alarms, and triggering automated actions.

16. **Q: What is CloudTrail?**
    A: A service that logs API calls and account activity across AWS for auditing, compliance, and security analysis.

17. **Q: What is the difference between a public and private subnet?**
    A: A public subnet has a route to an Internet Gateway allowing direct internet access; a private subnet has no such direct route and typically uses a NAT gateway for outbound access.

18. **Q: What is an Elastic IP?**
    A: A static, public IPv4 address you can allocate and associate with an EC2 instance, persisting even through stop/start cycles.

19. **Q: What is the difference between S3 and EBS?**
    A: S3 is object storage accessible over HTTP(S) for any data type at scale; EBS is block storage attached to a single EC2 instance like a virtual hard disk.

20. **Q: What is AWS Organizations?**
    A: A service for centrally managing multiple AWS accounts, applying policies (SCPs), and consolidating billing.

21. **Q: What is a NAT Gateway used for?**
    A: It allows instances in a private subnet to initiate outbound internet traffic while preventing unsolicited inbound connections.

22. **Q: What is the difference between horizontal and vertical scaling in AWS?**
    A: Horizontal scaling adds/removes instances (scale out/in); vertical scaling changes instance size/type (scale up/down).

23. **Q: What is AWS KMS?**
    A: Key Management Service — a managed service to create and control encryption keys used to protect data across AWS services.

24. **Q: What is the difference between ECS and EKS?**
    A: ECS is AWS's proprietary container orchestration service; EKS is a managed Kubernetes service, giving you the standard Kubernetes API and ecosystem.

25. **Q: What is a Bastion Host?**
    A: A hardened EC2 instance placed in a public subnet used as a secure gateway to access instances in private subnets via SSH/RDP.

## Scenario-Based

26. **Q: Your web app in a private subnet needs to download OS updates but must not be reachable from the internet. How do you enable this?**
    A: Place a NAT Gateway in a public subnet and route the private subnet's outbound traffic through it — this allows outbound-only internet access.

27. **Q: An application experiences sudden traffic spikes causing downtime. How would you architect for this?**
    A: Use an Auto Scaling Group behind an ALB with target-tracking scaling policies, and consider CloudFront caching to absorb read-heavy spikes.

28. **Q: You accidentally deleted an S3 object needed for compliance. How could you have prevented data loss?**
    A: Enable S3 Versioning (and optionally MFA Delete) so deleted/overwritten objects can be restored from previous versions.

29. **Q: Your EC2 instance can't connect to the internet despite being in a subnet with an IGW attached. What do you check?**
    A: Verify the subnet's route table has a route to the IGW, the instance has a public IP/Elastic IP, and Security Group/NACL rules allow the traffic.

30. **Q: You need zero-downtime deployments for an app on EC2. What approach would you use?**
    A: Use an Auto Scaling Group with an ALB and a Blue/Green or rolling deployment strategy (e.g., via CodeDeploy) to shift traffic gradually.

31. **Q: Your company needs to run the same infrastructure in dev, staging, and prod reliably. How do you achieve this?**
    A: Define infrastructure with CloudFormation or Terraform templates parameterized per environment, version-controlled, and deployed via CI/CD.

32. **Q: A database is experiencing high read load and slowing down the app. How do you mitigate this on RDS?**
    A: Add Read Replicas to offload read traffic, and/or enable ElastiCache for frequently accessed query results.

33. **Q: You need to give a third-party auditor temporary, limited access to specific S3 buckets. How?**
    A: Create an IAM role with a scoped policy (or generate a pre-signed URL/temporary STS credentials) restricted to those buckets and a limited time window.

34. **Q: Your team wants to reduce EC2 costs for a workload that can tolerate interruptions. What do you use?**
    A: Use Spot Instances, which offer significant discounts for interruptible workloads, combined with Auto Scaling for resilience.

35. **Q: An application in one AZ went down, taking your service offline. How should the architecture change?**
    A: Deploy across multiple Availability Zones with an ALB distributing traffic and Auto Scaling replacing failed instances in healthy AZs.

36. **Q: You need to trace who deleted a critical security group last week. What service helps?**
    A: CloudTrail logs API calls including who performed the action, when, and from where — search event history for the DeleteSecurityGroup event.

37. **Q: Your Lambda function times out processing large files from S3. How do you redesign this?**
    A: Increase timeout/memory within limits, or better, use S3 event triggers with Step Functions to orchestrate multi-stage processing, or offload heavy work to ECS/Batch.

38. **Q: You must ensure data stored in S3 is encrypted at rest and in transit. How do you enforce this?**
    A: Enable default S3 bucket encryption (SSE-S3 or SSE-KMS), enforce HTTPS via a bucket policy denying non-SSL requests, and use TLS for transit.

39. **Q: A newly launched EC2 instance can't be reached via SSH. What's your troubleshooting order?**
    A: Check the Security Group allows port 22 from your IP, the NACL allows the traffic, the instance has a public IP, the route table has an IGW route, and the correct key pair is used.

40. **Q: Your organization wants centralized billing and policy control across 20 AWS accounts. What do you set up?**
    A: AWS Organizations with a management account, consolidated billing, and Service Control Policies (SCPs) to enforce guardrails across member accounts.

41. **Q: You need a CI/CD pipeline fully within AWS for a containerized app. What services would you chain together?**
    A: CodeCommit/GitHub → CodeBuild (build/test) → CodePipeline (orchestration) → ECR (image registry) → ECS/EKS (deployment).

42. **Q: Your app needs low-latency global content delivery. What do you use?**
    A: CloudFront (CDN) with S3 or an origin server as the backend, caching content at edge locations worldwide.

43. **Q: How would you recover an application in another region during a full regional outage?**
    A: Use a multi-region DR strategy (pilot light, warm standby, or active-active) with data replicated via S3 Cross-Region Replication or RDS cross-region read replicas, and Route 53 failover routing.

44. **Q: A developer accidentally committed AWS credentials to a public GitHub repo. What's your immediate response?**
    A: Immediately deactivate/rotate the exposed IAM credentials, review CloudTrail for unauthorized use, remove the secret from git history, and enable a secrets scanning tool going forward.

45. **Q: Your batch job needs to process thousands of files nightly at minimal cost. What service fits?**
    A: AWS Batch (or Lambda for smaller files) combined with Spot Instances for cost-efficient compute.

46. **Q: You need to enforce that no S3 bucket in your org is ever made public. How?**
    A: Enable S3 Block Public Access at the account or Organization level via an SCP, and use AWS Config rules to detect/remediate drift.

47. **Q: Your microservices need to communicate asynchronously and reliably even if a consumer is down. What do you use?**
    A: Amazon SQS for decoupled message queuing (or SNS for pub/sub fan-out), ensuring messages persist until processed.

48. **Q: How would you migrate an on-prem 10TB database to AWS with minimal downtime?**
    A: Use AWS DMS (Database Migration Service) for continuous replication during migration, then cut over during a short maintenance window.

49. **Q: Your team needs infrastructure changes reviewed before applying, with a full audit trail. How do you implement this in AWS?**
    A: Use Terraform/CloudFormation with a CI/CD pipeline requiring PR approval, a `plan`/change-set review stage, and CloudTrail logging all applied changes.

50. **Q: An EC2 instance's root volume is running low on space in production. How do you fix it with minimal downtime?**
    A: Modify the EBS volume size via the console/CLI (no downtime needed for gp2/gp3), then extend the filesystem/partition on the OS without rebooting.
