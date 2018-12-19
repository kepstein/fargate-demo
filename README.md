# Fargate Demo
This project is intended as a simple demonstration of AWS Fargate, and not intended for any type of production use. 

This project is organized as follows:
```
├── Dockerfile
├── README.md
├── build
│   ├── index.html
│   └── woohoo.jpg
├── deploy.sh
├── fargate_demo.cfn
│   ├── fargate.yml
│   ├── prod-us-east-1.env
│   └── templates
│       └── fargate-demo.yml
└── runway.yml
```
## Notes
- The Dockerfile is used to create the image for the container. 
- runway.yml is the configuration file for [Onica's Runway.](https://github.com/onicagroup/runway)  
- Runway, is not required. You can deploy the template either using the deploy.sh script, or manually from the AWS CloudFormation Console

## Installation Notes 
1. Prepare by deploying a CloudFormation stack
    ```bash
    $ ./deploy.sh fargate-demo   # change fargate-demo for any value you would like to name your CloudFormation Stack
    ```
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
