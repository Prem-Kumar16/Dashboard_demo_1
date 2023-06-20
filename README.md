# Dashboard_demo_1

The repository contains the instructions and code that allows you to create a single kubernetes pod dashboard demo using virtual can interface

## THIS DEMO WILL WORK BEST ON MUMBAI (ap-south-1) region

Deploy EC2 in Mumbai region

[![Launch](https://samdengler.github.io/cloudformation-launch-stack-button-svg/images/ap-south-1.svg)](https://ap-south-1.console.aws.amazon.com/cloudformation/home?region=ap-south-1#/stacks/quickcreate?templateURL=https%3A%2F%2Fs3.ap-south-1.amazonaws.com%2Fcf-templates-fui01m96flo3-ap-south-1%2F2023-06-12T102342.059Z33r-demo-1-dashboard-ec2-template.yml&stackName=demo-1-dashboard)

Acknowledge the creation of the stack and press the button **Create stack** on the bottom right. 

The ```demo-1-dashboard``` CloudFormation stack will take about **2 minutes** to be created.

### Locally downloading the Private key file

Follow the steps below to download the private .pem key file to SSH into the instance

Open cloudshell and run the following command

```sh 
aws ec2 describe-key-pairs --filters Name=key-name,Values=keypair-for-ewaol --query KeyPairs[*].KeyPairId --output text
```

The output will be the key ID. Note down it

Run the below command to save .pem file in the cloudshell directory

Change the keyid paramater to the output of previous command

```sh
aws ssm get-parameter --name /ec2/keypair/<keyid here> --with-decryption --query Parameter.Value --output text > keypair-for-ewaol.pem
```

<img width="911" alt="Screenshot 2023-06-16 085413" src="https://github.com/Prem-Kumar16/Dashboard_demo_1/assets/75419846/d3d6379a-c1bf-4ca0-abd4-f8978f98e16e">

Go to actions -> download file and paste this path "/home/cloudshell-user/keypair-for-ewaol.pem" inside the path field to save .pem key file locally

<img width="516" alt="Screenshot 2023-06-16 090012" src="https://github.com/Prem-Kumar16/Dashboard_demo_1/assets/75419846/5618f31a-8193-4bdf-aa66-a4be0688886d">

If you go to ec2 instances page, you will find a newly created instance named "EWAOL-Instance". SSH into the instance using the key file  that you have previously downloaded

#### Important note, while SSH change the user name from root to ewaol i.e., instead of root@ip.eu-central-1.compute.amazonaws.com, you should use ewaol@ip.eu-central-1.compute.amazonaws.com

After connected to the instance via SSH, run the below command 

Note : Give the access & secret access key to the instance via "aws configure" command & the default region name must be ap-south-1

```sh
aws configure
cd Dashboard_demo_1/
```

Run the below steps to log into ECR Repository for pulling images from it

```sh
AWS_DEFAULT_REGION=ap-south-1
PASS=$(aws ecr get-login-password --region $AWS_DEFAULT_REGION)
```

Create a kubectl secret 

```sh
sudo kubectl create secret docker-registry regcred \
   --docker-server=783584839454.dkr.ecr.ap-south-1.amazonaws.com \
   --docker-username=AWS \
   --docker-password=$PASS
```

The below command helps you to run the pod

```sh
sudo kubectl apply -f deployaws.yaml -f servicedeploy.yaml
```

If you want to know the status of pods, the below commands will help you

```sh
sudo kubectl get pods
sudo kubectl describe pods
```

To visualize the dashboard running in your ec2 instance, run the commands below (Please run the command one by one) 

```sh
sudo kubectl exec -it canapp /bin/sh
node car.js
```

### Cleanup

From [CloudFormation](https://console.aws.amazon.com/cloudformation/home) just delete `demo-1-dashboard` stack.
