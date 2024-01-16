Secure Azure Infrastructure with Passwordless MySQL Access



Project Overview


This project, meticulously crafted with Terraform, establishes a highly secure, automated infrastructure in Azure, focusing on passwordless access to a MySQL Flexible database. It showcases an advanced security model utilizing Azure's native features like Managed Identities and Azure Bastion, ensuring that all interactions within the infrastructure are secure and compliant with Azure's best security practices.




Key Features


Passwordless Database Access: Leverages Azure Entra ID for secure, passwordless authentication to the MySQL Flexible database.


Isolated Network Design: All network traffic is contained within the infrastructure, with no external access, ensuring maximum security.


Azure Bastion Configuration: Provides secure, remote desktop protocol (RDP) access to the virtual machine, which is used as a secure gateway to connect to the database server.


Subnet Segregation: The database, Key Vault, and virtual machines are placed in separate subnets, enhancing security through network isolation.


Service and Private Endpoints: Implements both service and private endpoints for the MySQL database and Key Vault. This configuration eliminates the need for public access, fortifying the infrastructure against external threats.


Network Security Groups (NSGs): Separate NSGs for the VM and database subnets, finely controlling and securing network traffic.



Managed Identity with Role Assignments: Utilizes Azure Managed Identity with specific role assignments—'Contributor' for database access and 'Key Vault Officer' for Key Vault access, thereby adhering to the principle of least privilege.



Graph Permissions for Managed Identity: Executes an aadrole.ps1 script to assign necessary Graph permissions to the Managed Identity post-creation, ensuring the Managed Identity has the appropriate access rights.



Security-First Approach

No Public Access: The architecture is designed with no public endpoints, fully encapsulating the infrastructure from external access and threats.



Automated with Terraform: The use of Terraform for automation not only streamlines the deployment process but also ensures that the infrastructure is consistently deployed with the exact security configurations specified in the code.
Azure Best Practices: This project aligns with Azure's best security practices, ensuring a robust, reliable, and secure environment.



Usage and Deployment

Prerequisites: Ensure you have Terraform installed and Azure CLI configured with appropriate permissions.



Clone and Initialize: Clone the repository and run terraform init to initialize Terraform and download required providers.



Plan and Apply: Execute terraform plan to preview changes and terraform apply to deploy the infrastructure.



Post-Deployment: After the Managed Identity is created, run the aadrole.ps1 script to assign the necessary Graph permissions.



Contributing

Your contributions are welcome to enhance the project's features or security. Please follow the contributing guidelines outlined in the repository for submitting changes.



Support and Maintenance

For support requests or to report an issue, please use the repository's issue tracker.



Regular updates will be rolled out to align with Azure's evolving best practices and to incorporate improvements based on user feedback.



Security Best Practices and Recommendations

Regular Audits: Periodic audits of the infrastructure WILL be ongoing to ensure compliance with security standards and to identify any potential vulnerabilities.




Monitoring and Logging: Azure Monitor and Azure Log Analytics for continuous monitoring and to gain insights into the security posture of the infrastructure will be consider in this project.



