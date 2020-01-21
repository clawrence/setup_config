#!/bin/bash

# below with AWS Simple System Manager (SSM) 
# can avoid having public ip bastion
#
# .ssh/config
# Host i-*
#User ec2-user
#ForwardAgent yes
#IdentityFile ~/.ssh/bla-bastion
#ProxyCommand sh -c "aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"
#
#aws ec2 describe-instances --query  'Reservations[].Instances[].[InstanceId,State.Name,Tags[?Key==`Name`] | [0].Value]'
#alias fndbastion='aws ec2 describe-instances --query  '"'"'Reservations[].Instances[].[InstanceId,State.Name,Tags[?Key==`Name`] | [0].Value]'"'"''
#

if [[ $# -ne 1 ]] ; then
  echo "usage npssh.sh ec2-instance-name"
  exit 1
fi


id=$(aws ec2 describe-instances --filters Name=instance-state-name,Values=running Name=tag:Name,Values=$1 --query 'Reservations[*].Instances[*].{Instance:InstanceId}' --output text)

if [[ -z "$id" ]] ; then
  echo "no instance found for $1"
  exit 1
fi

ssh $id
