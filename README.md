# terraform-openmetadata-aws-assets

This repository provides Terraform modules to deploy an ECS-based OpenMetadata service with an Aurora database. Terragrunt configuration is centralized with `infra/terragrunt/root.hcl`, and the environment directories (`dns`, `aws`, `backend`, `cicd`) simply include this root file for remote state and provider settings. Please note the following when using this module:

## Key Notes

- Separate the creation of ACM (AWS Certificate Manager) and Route 53 resources into a different Terraform state file to avoid coupling them tightly with the main infrastructure.
- A dedicated `dns` module provisions Route 53 hosted zones, query logging, and ACM certificates before the main AWS stack.
- Based on my experience, keeping modules as granular as possible is recommended, especially for disaster recovery (DR) scenarios.
- **Warning**: This module does not implement non-functional requirements such as comprehensive operational support or robust security measures. Therefore, **it is not suitable for production environments without significant modifications**.

## Future Improvements (You Should Consider Adding)

The following points are currently under consideration for implementation:

1. **Enhanced Security**:
   - Implement IAM policies with the principle of least privilege.
   - Add network security features, such as fine-grained VPC configurations.

2. **Scalability and Resilience**:
   - Automate scaling rules for ECS tasks.
   - Implement failover mechanisms for the Aurora database.

3. **ECS-Specific Enhancements**:
   - Monitor the number of running ECS tasks to ensure proper scaling and performance.
   - Track the status of ingestion jobs to detect and resolve failures quickly.
   - Implement scheduling mechanisms to control ECS task runtime, reducing costs during low-demand periods.

4. **ECR Repository Policies**:
   - Implement lifecycle policies to automatically clean up unused images.
   - Enforce strict access control to limit who can push or pull images.
   - Enable image scanning to identify vulnerabilities before deployment.

5. **Documentation**:
   - Provide examples for different environments, such as development, staging, and production.
   - Add step-by-step setup guides to ensure ease of use.
   - Utilize **[Terraform Docs](https://terraform-docs.io/)** to generate module documentation automatically. Ensure that module inputs, outputs, and examples are up-to-date and clearly described.

## Contribute

For any issues or questions, feel free to open an issue in this repository.
