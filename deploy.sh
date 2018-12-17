#!/bin/bash

aws cloudformation create-stack \
--stack-name $1 \
--template-body file://CloudFormation/fargate-demo.yml \
--capabilities CAPABILITY_AUTO_EXPAND CAPABILITY_NAMED_IAM
