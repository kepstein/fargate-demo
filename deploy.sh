#!/bin/bash

aws cloudformation create-stack \
--stack-name $1 \
--template-body file://fargate_demo.cfn/templates/fargate-demo.yml \
--parameters \
ParameterKey=SubnetAZ1,ParameterValue=subnet-0f3de278 \
ParameterKey=SubnetAZ2,ParameterValue=subnet-638e773a \
ParameterKey=SubnetAZ3,ParameterValue=subnet-64dec74c \
ParameterKey=RepoName,ParameterValue=fargate-demo \
--capabilities CAPABILITY_AUTO_EXPAND CAPABILITY_NAMED_IAM
