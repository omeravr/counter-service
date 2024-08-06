# Counter Service Deployment

This repository contains the necessary configurations to deploy the Counter Service application using Helm and GitHub Actions. The Helm chart for the application is hosted on GitHub Pages and is set up to be deployed to an Amazon EKS cluster.


### Prerequisites
1. Running on a Local Runner
To deploy the Counter Service using this setup, you need to have a local runner that is connected to your AWS account. The local runner can either run "on-the-fly" using the ./run.sh script or be managed as a service using sudo ./svc.sh start.

Running "On-the-Fly"
To start the runner immediately without setting it up as a service:
sudo ./run.sh

Running as a Service
To set up and start the runner as a service:
sudo ./svc.sh install
sudo ./svc.sh start


2. Configuring Secrets
Ensure that the following secrets are set up in your GitHub repository. These secrets are necessary for the GitHub Actions workflow to authenticate and deploy the application.

**DOCKER_PASSWORD**: The password for your Docker Hub account.

**DOCKER_REGISTRY**: The Docker registry URL (usually registry-1.docker.io/omerav10 for Docker Hub).

**DOCKER_USERNAME**: Your Docker Hub username.

**EKS_CLUSTER_NAME**: The name of your Amazon EKS cluster.


To add these secrets in GitHub:
Go to your repository on GitHub.
Click on Settings.
Navigate to Secrets > Actions.
Click on New repository secret.
Add each secret with its corresponding value.



## GitHub Actions Workflow

The GitHub Actions workflow is defined in the `.github/workflows/deploy.yml` file. The workflow performs the following steps:

1. **Checkout Code**: Checks out the repository code.
2. **Log in to Docker Hub**: Logs in to Docker Hub using the provided secrets.
3. **Build and Push Docker Image**: Builds the Docker image and pushes it to Docker Hub.
4. **Configure kubectl**: Configures `kubectl` to connect to the EKS cluster.
5. **Deploy using Helm**: Deploys the Counter Service Helm chart to the EKS cluster.
6. **Retrieve VPC ID**: Retrieves the VPC ID of the EKS cluster.
7. **Retrieve LoadBalancer Name**: Retrieves the name and ARN of the load balancer associated with the EKS cluster.
8. **Retrieve Service Port**: Retrieves the service port of the Counter Service application.
9. **Create Target Group**: Creates a target group for the load balancer.
10. **Create Listener**: Creates a listener for the load balancer.
11. **Update TargetGroupBinding**: Updates the TargetGroupBinding configuration with the ARN of the target group.
12. **Apply TargetGroupBinding**: Applies the TargetGroupBinding configuration to the EKS cluster.
13. **Validate Counter Service**: Validates the deployment by sending a request to the load balancer and checking the response.

## GitHub Pages

The Helm chart for the Counter Service is hosted on GitHub Pages. The `gh-pages` branch is used to serve the Helm chart. The structure of the `gh-pages` branch is as follows:

gh-pages/
└── docs/
├── counter-service-chart-0.1.0.tgz
└── index.yaml


### Setting Up GitHub Pages

To set up GitHub Pages for the repository:

1. **Create the `gh-pages` Branch** (if it doesn't exist):
   git checkout gh-pages
   echo "Helm Chart Repository" > index.html
   git add index.html
   git commit -m "Initialize GitHub Pages"
   git push origin gh-pages

2. Switch to the gh-pages Branch:
   git checkout gh-pages




### Uploading or Updating the Helm Chart
To upload or update the Helm chart:

1. Navigate to the docs Directory:
cd gh-pages/docs

2. Copy the Packaged Helm Chart:
Ensure that the packaged Helm chart (.tgz file) is in the docs directory.

3. Update the Helm Repository Index:
Run the following command to update the Helm repository index:
helm repo index . --url https://omeravr.github.io/counter-service

4. Commit and Push Changes:
Commit and push the updated index.yaml file and the packaged Helm chart:
git add .
git commit -m "Update Helm chart and index.yaml"
git push origin gh-pages




### Accessing the Helm Chart
Once the Helm chart is uploaded and the index is updated, you can add the repository and fetch the chart using the following commands:

helm repo add my-repo https://omeravr.github.io/counter-service
helm repo update
helm fetch my-repo/counter-service-chart

This setup ensures that the Helm chart for the Counter Service application is easily accessible and deployable using GitHub Actions and Helm.





### Reverting Changes
If you need to revert the deployment, follow these steps to clean up the Helm deployment and associated AWS resources.

### Using Cleanup Workflow
Using the Cleanup Workflow
A dedicated GitHub Actions workflow has been created to handle the cleanup of resources. You can trigger this workflow manually.

1. Navigate to the Actions Tab:
     Go to the Actions tab in your GitHub repository.

2. Select the Cleanup Workflow:
     Select the "Cleanup Resources" workflow from the list of workflows.

3. Run Workflow:
     Click on the "Run workflow" button and provide any required inputs if prompted. This will manually trigger the cleanup workflow.


### Manual 
1. Delete the Helm Deployment
To uninstall the Helm release:
helm uninstall counter-service -n counter-service

2. Delete the TargetGroupBinding
To delete the TargetGroupBinding resource from your Kubernetes cluster:
kubectl delete TargetGroupBinding counter-service -n counter-service

3. Delete the Listener and Target Group on AWS
To clean up the listener and target group on AWS, follow these steps:

Delete the Listener:

Go to the AWS Management Console.
Navigate to the EC2 Dashboard.
Select Load Balancers under the Load Balancing section.
Choose the load balancer associated with your EKS cluster.
Select the Listeners tab.
Find the listener you want to delete and click on the Actions dropdown, then select Delete.
Delete the Target Group:

In the EC2 Dashboard, select Target Groups under the Load Balancing section.
Find the target group associated with your Listener.
Select the target group and click on Actions, then select Delete.
By following these steps, you can ensure that all resources associated with the deployment are properly cleaned up.

