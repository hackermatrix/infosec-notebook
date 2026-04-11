## What are Network Policies, and how do you enforce them in Kubernetes?

**Answer:** 
- Network Policies control traffic between Pods in a Kubernetes cluster. You define them by specifying allowed traffic and Pod selectors. Enforce policies by using a network policy controller, such as Calico or Cilium, and regularly reviewing and updating policies.

etcd stores all cluster data, including secrets. Its compromise risks the entire cluster. Best **Practices for Securing etcd:**

1. **Enable TLS:** Ensure all communications are encrypted:

### How do you detect and mitigate vulnerabilities in container images?

**Answer:**
- **Image Scanning:** Use tools like Trivy or Aqua Security in CI/CD pipelines:

Explain the concept of Kubernetes Service Accounts and their role in cluster security. How can you configure RBAC to grant specific permissions to Service Accounts?