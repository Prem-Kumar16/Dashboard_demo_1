# Dashboard_demo_1

The repository contains the instructions and code that allows you to create a single kubernetes pod dashboard demo using virtual can interface

## Overview

The below image is the detailed overview of the following demo

<img width="583" alt="Screenshot 2023-06-20 220123" src="https://github.com/Prem-Kumar16/Dashboard_demo_1/assets/75419846/36bc7f78-b368-466d-9303-eb1c065e4ef5">

## THIS DEMO WILL WORK BEST ON MUMBAI (ap-south-1) region

Deploy EC2 in Mumbai region

Please open the below link in new tab to ease the process

[![Launch](https://samdengler.github.io/cloudformation-launch-stack-button-svg/images/ap-south-1.svg)](https://ap-south-1.console.aws.amazon.com/cloudformation/home?region=ap-south-1#/stacks/quickcreate?templateURL=https%3A%2F%2Fs3.ap-south-1.amazonaws.com%2Fcf-templates-fui01m96flo3-ap-south-1%2F2023-06-29T122523.614Z86v-demo-1-dashboard-ec2-template.yml&stackName=demo-1-dashboard)

Acknowledge the creation of the stack and press the button **Create stack** on the bottom right. 

The ```demo-1-dashboard``` CloudFormation stack will take about **2 minutes** to be created. This cloudformation stack creates an ec2 instance named "EWAOL-Instance" to deploy the demo, a security group, a key pair and it also associates the ec2 instance with the already created elastic IP.

### Locally downloading the Private key file

Follow the steps below to download the private .pem key file to SSH into the instance

Open cloudshell and run the following command

```sh 
aws ec2 describe-key-pairs --filters Name=key-name,Values=keypair-for-ewaol-demo1 --query KeyPairs[*].KeyPairId --output text
```

The output will be the key ID. Note down it

Run the below command to save .pem file in the cloudshell directory

Change the keyid paramater to the output of previous command

```sh
aws ssm get-parameter --name /ec2/keypair/<keyid here> --with-decryption --query Parameter.Value --output text > keypair-for-ewaol-demo1.pem
```


<img width="953" alt="Screenshot 2023-06-29 180231" src="https://github.com/Prem-Kumar16/Dashboard_demo_1/assets/75419846/40dd6540-1540-4719-b1ac-86324fde9f8b">


Go to actions -> download file and paste this path "/home/cloudshell-user/keypair-for-ewaol-demo1.pem" inside the path field to save .pem key file locally


<img width="458" alt="Screenshot 2023-06-29 180510" src="https://github.com/Prem-Kumar16/Dashboard_demo_1/assets/75419846/55c0a283-5337-4f9e-87d8-e9a9c46d8d0a">


If you go to ec2 instances page, you will find a newly created instance named "EWAOL-Instance". SSH into the instance using the key file  that you have previously downloaded

#### Important note, while SSH change the user name from root to ewaol i.e., instead of root@ip.eu-central-1.compute.amazonaws.com, you should use ewaol@ip.eu-central-1.compute.amazonaws.com

After connected to the instance via SSH, run the below command 

Note : Give the access key ID & secret access key to the instance via "aws configure" command & the default region name must be ap-south-1

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

<img width="748" alt="Screenshot 2023-06-20 125347" src="https://github.com/Prem-Kumar16/Dashboard_demo_1/assets/75419846/cb8a36ca-05ad-45b2-9782-be832afc7acf">

The below command helps you to run the pod

```sh
sudo kubectl apply -f deployaws.yaml -f servicedeploy.yaml
```

Please wait for atleast 2 minutes for the pod to pull image and deploy

If you want to know the status of pods, the below commands will help you

```sh
sudo kubectl get pods
sudo kubectl describe pods
```

Image for command "sudo kubectl get pods"
<img width="708" alt="Screenshot 2023-06-20 125640" src="https://github.com/Prem-Kumar16/Dashboard_demo_1/assets/75419846/98d61c11-cb78-4730-9f44-fc20044fe691">

Image for command "sudo kubectl describe pods"
![Screenshot (137)](https://github.com/Prem-Kumar16/Dashboard_demo_1/assets/75419846/df55fdea-98b4-4e50-b168-310305fb1bd2)


To visualize the dashboard running in your ec2 instance, run the commands below (Please run the command one by one) 

```sh
sudo kubectl exec -it canapp /bin/sh
node car.js
```

Now copy the below url and paste it in any browser to see the demo running

```sh
http://13.126.233.234:3000/
```

You should see something similar to the below gif

![giphy](https://github.com/Prem-Kumar16/Dashboard_demo_1/assets/75419846/9f4406d6-10b4-4e8a-84ec-fd9e41e54b34)

### Cleanup

From [CloudFormation](https://console.aws.amazon.com/cloudformation/home) just delete `demo-1-dashboard` stack.

Do not forget to delete the downloaded keypair in cloudshell by running the below command

```sh
rm keypair-for-ewaol.pem
```
