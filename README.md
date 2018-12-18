# Fargate Demo
This project is intended as a simple demonstration of AWS Fargate, and not intended for any type of production use. 
1. Prepare for ECS by creating a very basic IAM Role for ECS
    ```bash
    $ aws cloudformation create-stack --stack-name ecsIAMRole --template-body file://CloudFormation/ecs-role.yml --capabilities CAPABILITY_AUTO_EXPAND CAPABILITY_NAMED_IAM
    ```
2. Create the ECS Cluster. This is different from a traditional cluster which usually serves as a resource boundary. with Fargate, the cluster serves only as an administrative Boundary.
	1. An AWS best-practice is to actually have the Fargate Cluster assigned to it’s own VPC. This is because we want to make sure that services that scale massively don’t compete for resources required by other services.
		1. An alternative is to assign dedicated subnets to the Fargate cluster.
	2. Give the cluster a name, and ignore the networking section for now, and hit the "create" button.
3. Before we can create a Task Definition we have to have a repository. This could be an image in Docker Hub for example, or we can use ECR. For this project we will create a Docker Image on our local machine, and then push the image to ECR
	1. Build the docker container
    ```bash
    $ docker build -t fargate-demo .
    ```
	2. Next authenticate with ECR.
    ```bash
    $ aws ecr get-login --no-include-email
    ```
	3. Copy the whole output from the command and paste it into your terminal. We should receive a password warning, and if everything worked as expected, we should see the response `Login Succeeded`
    ```bash
    $ docker login -u AWS -p eyJwYXlsb2FkIjoicUhBXXXXXXXXXXXXXXX https://123456789012.dkr.ecr.us-east-1.amazonaws.com
    ```
	4. Next we need to tag the instance we created, and push it to ECR.
    ```bash
    $ docker image ls
    
    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    fargate-demo        latest              84e1db626213        43 seconds ago      132MB
    httpd               latest              2a51bb06dc8b        4 weeks ago         132MB
    
    $ docker tag 84e1db626213 123456789012.dkr.ecr.us-east-1.amazonaws.com/fargate-demo
    
    $ docker image ls
    
    REPOSITORY                                                  TAG                 IMAGE ID            CREATED             SIZE
    123456789012.dkr.ecr.us-east-1.amazonaws.com/fargate-demo   latest              84e1db626213        2 minutes ago       132MB
    fargate-demo                                                latest              84e1db626213        2 minutes ago       132MB
    httpd                                                       latest              2a51bb06dc8b        4 weeks ago         132MB
    
    $ docker push 123456789012.dkr.ecr.us-east-1.amazonaws.com/fargate-demo
    ```
3. With the image pushed to ECR, we can now define a Task Definition
	1. From the ECR console page, click the "Task Definitions" link, and then click "Create new Task Definition"
	2. For the launch type compatibility, select the "FARGATE" option, and then click "Next step"
	3. Give the Task Definition a name.
