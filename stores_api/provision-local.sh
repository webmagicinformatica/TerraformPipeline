#!/bin/bash
set -e
while getopts "r:e:p:" opt; do
   case $opt in
    r) runcmd="$OPTARG"
      ;;
    e) envname="$OPTARG"
      ;;
    p) project="$OPTARG"
      ;;
    \?) echo "Invalid option -$OPTARG" >&2
       ;;
  esac
done


if [ -z ${runcmd} ] || [ -z ${envname} ] || [ -z ${project} ]; then
    printf "\n"
    printf "Please provide environment, terraform command and service to be created\n\n"
    printf "valid environment values are dev, int, stage, PROD \n"
    printf "\n"

elif [ "${runcmd}" != "init" ] && [  "${runcmd}" != "plan" ] && [  "${runcmd}" != "apply" ]  && [  "${runcmd}" != "destroy" ]; then
    printf "\n"
    printf "!!! invalid terrafrom command entry !!! \n"
    printf "Valid terrafrom command to run this script is:  init,plan,apply or destroy \n"
else
    export datevar=$(date +%Y%m%d-%H-%M)
    sed -i  's/BITBUCKET_CREDENTIALS/'"${BITBUCKET_CREDENTIALS}"'/g' *.tf

    data=$(aws --profile api sts assume-role --role-arn ${role} --role-session-name cpw${seed})
    if [ -z "${data}" ]; then
        echo "!!! Error getting a valid session. Please fix it."
        exit 1
    fi

    export AWS_ACCESS_KEY_ID=$(echo ${data} | sed 's/.*AccessKeyId": "\([A-Za-z0-9\/+=]*\).*/\1/')
    export AWS_SECRET_ACCESS_KEY=$(echo ${data} | sed 's/.*SecretAccessKey": "\([A-Za-z0-9\/+=]*\).*/\1/')
    export AWS_SESSION_TOKEN=$(echo ${data} | sed 's/.*SessionToken": "\([A-Za-z0-9\/+=]*\).*/\1/')
    export AWS_SECURITY_TOKEN=$(echo ${data} | sed 's/.*SessionToken": "\([A-Za-z0-9\/+=]*\).*/\1/')
    echo "AWS session set"
    
    if [ ${runcmd} == "init" ];then
       rm -rf .terraform/
       yes yes |  TF_WORKSPACE=${envname}-${project} terraform ${runcmd}
    elif [ ${runcmd} == "destroy" ];then
        TF_WORKSPACE=${envname}-${project} terraform ${runcmd} -var-file="$envname.tfvars" -force
    
    elif [ ${runcmd} == "apply" ];then
        TF_WORKSPACE=${envname}-${project} terraform ${runcmd} -var-file="$envname.tfvars" -auto-approve
    else
       TF_WORKSPACE=${envname}-${project} terraform ${runcmd} -var-file="$envname.tfvars"
   fi

fi
