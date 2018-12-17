# Fargate Demo
1. Prepare for ECS by creating a very basic IAM Role for ECS
```bash
aws cloudformation create-stack --stack-name ecsIAMRole --template-body file://CloudFormation/ecs-role.yml --capabilities CAPABILITY_AUTO_EXPAND CAPABILITY_NAMED_IAM
```
2. Create the ECS Cluster. This is different from a traditional cluster which usually serves as a resource boundary. with Fargate, the cluster serves only as an administrative Boundary.
	1. An AWS best-practice is to actually have the Fargate Cluster assigned to it’s own VPC. This is because we want to make sure that services that scale massively don’t compete for resources required by other services.
		1. An alternative is to assign dedicated subnets to the Fargate cluster.
	2. Give the cluster a name, and ignore the networking section for now, and hit the "create" button.
3. Before we can create a Task Definition we have to have a repository. This could be an image in Docker Hub for example, or we can use ECR. For this project we will create a Docker Image on our local machine, and then push the image to ECR
	1. Build the docker container
```bash
docker build -t fargate-demo .
```

	2. Next authenticate with ECR.
```bash
aws ecr get-login --no-include-email
```

	3. Copy the whole output from the command and paste it into your terminal. We should receive a password warning, and if everything worked as expected, we should see the response `Login Succeeded`
```bash
docker login -u AWS -p eyJwYXlsb2FkIjoicUhBYVdYZEN1cWdkRDgvcHlTMW9TbnZ0ZU5MektTWjY0aC9JVHhhZSsyT3c5WXY3blRkMUVXR1p3ZHZ4dTFiVUhmcDJNZGowQ095Uzg3SkhOWGZTSzBDaTExMnlaYkxicml0RlZYRHpwc2hab1RTbVZQNTd2OTkyMTRtNlBZSzFtVGlVckhrWEVPcVJKLzNlb2FzWjNCZnViYUZnVkxMdUpqZnllaXJGM3p6VTlROTNwQVlDRWVyT09Ib3hwRHhMWEg1UFdkZGZDU255ckN5Ukg3SGpMTnhrek9lRjBQVFQ5Ymh4Mm9TblppTXNYUGh4c05uWW96QVJlNlRaTmM2ZmovZnEvYlI4TjlSbDdwMC8ySk9JSTRpUDcxenE2ejBLQzQ5dm1Ea0lLLytibGZPQ1diTXNmNkNCcHUrNXFGOGZZNEVLYUpTcW5iM083UkVZcmxZNXF2eUNRZFZ0MnB5TUJYVWJ2QU9pMTFQRktDTXFQQ2h2UGhNdjh0MlZQZ2FiMmV1Nk9wc3lGYzl1K1VFOWI0RTRIQWhuQ0t1Y0ZZQ1dORHpnaU5kWXlueTNnOEkyMVlCSk82THdiL254cXdaSjFJVmZBcXJ1dldVL3FjNUJSQmI2N3dnakpmWFVaWkw1ViszSDBCeW1YQis0OWZTRURUR1hOUUNkVTA0NG1YUEFBN2x0alRtaTVqV1FOMHFGeVloUXUwUHRoMG5sQzI5Z3NlMVBIOGFEeWE4QzJzd3BaDNXdGtYSEwwMzBIWXR4TW5jR09uOXlzSzJNMGNvb21OS2ZLY2VYTHk2MWlTdVVxS2ovQ3hlNjZVNUlvenBPanZSTnU3SldqOURvSUZvd3FNclJEaDBJOEZnb0pTZ2hOUzZJMUsxVG1oZGdxUHlUWFAyVnlvOUlTeHF5ZTFhaUNlOGNnQld6QjhIbE80aENacm8ya0phYi93aWJiZ3FGYkRZTm5FSFZQNDFtbnAwMHpsdW5IYVlGUGNRQUN6WjhXViswQlpkcHoxQ3RhNk5BQjhxaGFwRW5QdzVEUFFvaWFIYUZHNUkyMzB5c0pUeVBZVk9YSzFqU0NEaWphYUdhVHNpd3ZNQ2xjK0VjNlE3RVQ4MCthakZnU2c4bDVzVGFoYkVXcFAwNlpDRmZvK2NqUTQ0dmpzL0RCc2dpZXE5NXYzNm00dDNKWmlXYmkrQURMQ2c2anNsbklJSk5CemdVZ2g2ZUtlMW1iQ45Z3ozZERhd2J1RWRpQWRreDRFUDFpTnF6aXN4ZzNXZ2lMSk9TdTQ2enl0U2Joakxta3RYQU16MExieHV6b2Z0VlNmZzcxcFRpVndlMXhTclZrc09nUWRjVjdyNVA4NWhVSUdyQWVTMndsU0pwYkRBTTM1aU5GQWQyVU95Q3Z6bkk1TGJQcUhQazJ6V2ZXczErdXB1MmIzanJRUW9wWG5LWnMiLCJkYXRha2V5IjoiQVFFQkFIaHdtMFlhSVNKZVJ0Sm01bjFHNnVxZWVrWHVvWFhQZTVVRmNlOVJxOC8xNHdBQUFINHdmQVlKS29aSWh2Y05BUWNHb0c4d2JRSUJBREJvQmdrcWhraUc5dzBCQndFd0hnWUpZSVpJQVdVREJBRXVNQkVFREMvRndnbUUzUXUxdHhrWWZBSUJFSUE3V0RWcUhFNTRBUi81UzFSTzBaaDdNK1FXUUZwSEQ1TUtQZ3R5YXQ0TzI5RTFsOEN1Z1h0ckpUTmszRHJxN3NCOFNjMFloOFIreTIzMkk2Zz0iLCJ2ZXJzaW9uIjoiMiIsInR5cGUiOiJEQVRBX0tFWSIsImV4cGlyYXRpb24iOjE1NDUxMTM0NTh9 https://123456789012.dkr.ecr.us-east-1.amazonaws.com
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
$ 123456789012.dkr.ecr.us-east-1.amazonaws.com/fargate-demo
```
3. With the image pushed to ECR, we can now define a Task Definition
	1. From the ECR console page, click the "Task Definitions" link, and then click "Create new Task Definition"
	2. For the launch type compatibility, select the "FARGATE" option, and then click "Next step"
	3. Give the Task Definition a name.
