#!/bin/bash

aws cloudformation create-stack \
--stack-name $1 \
--template-body file://fargate_demo.cfn/templates/fargate-demo.yml \
--parameters ParameterKey=RepoName,ParameterValue=fargate-demo \
--capabilities CAPABILITY_AUTO_EXPAND CAPABILITY_NAMED_IAM
