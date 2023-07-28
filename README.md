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
```

After the aws configuration step, launch the below cloudformation stack which will create all the necessary developer tools and creates a whole codepipeline.

Please open the below link in new tab to ease the process

[![Launch](https://samdengler.github.io/cloudformation-launch-stack-button-svg/images/ap-south-1.svg)](https://ap-south-1.console.aws.amazon.com/cloudformation/home?region=ap-south-1#/stacks/quickcreate?templateURL=https%3A%2F%2Fs3.ap-south-1.amazonaws.com%2Fcf-templates-fui01m96flo3-ap-south-1%2F2023-07-26T112423.424Zqro-codepipeline_cfn_template.yaml&stackName=codepipeline-demo-1)

Acknowledge the creation of the stack and press the button **Create stack** on the bottom right. 

The ```codepipeline-demo-1``` CloudFormation stack will take about **2 minutes** to be created.

After the creation of the stack, go to the codePipeline management console, You will see a pipeline named **autodemocodepipeline** created. Wait for it to be completed.

<img width="662" alt="Screenshot 2023-07-27 084106" src="https://github.com/Prem-Kumar16/Dashboard_demo_1/assets/75419846/82cfe7ca-f95f-4bce-8aee-cfb551c5bb21">


If you want to know the status of pods, the below commands in the ec2 instance will help you

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

Now copy the below url and paste it in any browser to see the demo running (This is the IP address of ec2 instance where your demo is running)

```sh
http://13.126.233.234:3000/
```

You should see something similar to the below gif

![giphy](https://github.com/Prem-Kumar16/Dashboard_demo_1/assets/75419846/9f4406d6-10b4-4e8a-84ec-fd9e41e54b34)

### Cleanup

From [CloudFormation](https://console.aws.amazon.com/cloudformation/home) delete `codepipeline-demo-1` stack.

<img width="471" alt="Screenshot 2023-07-27 064719" src="https://github.com/Prem-Kumar16/Dashboard_demo_1/assets/75419846/526be2be-2b9d-4080-9445-fc97430afbf4">



<img width="452" alt="Screenshot 2023-07-27 064800" src="https://github.com/Prem-Kumar16/Dashboard_demo_1/assets/75419846/16a50a52-0c7e-485f-afcc-a644c29e8b7d">


If the delete is failed, go to the resources tab under `codepipeline-demo-1` stack and open the ECR Repository in a new tab.

<img width="367" alt="Screenshot 2023-07-27 070006" src="https://github.com/Prem-Kumar16/Dashboard_demo_1/assets/75419846/4f20c65e-81b1-47e3-9d02-40e1d1919af3">

Choose delete stack again. This time a message appears to retain the resources. Choose to retain and click delete.

<img width="469" alt="Screenshot 2023-07-27 065902" src="https://github.com/Prem-Kumar16/Dashboard_demo_1/assets/75419846/033185b8-33b5-468e-b82d-26c94418bc83">


<img width="455" alt="Screenshot 2023-07-27 070128" src="https://github.com/Prem-Kumar16/Dashboard_demo_1/assets/75419846/28074d9e-055f-4e17-ba3b-d19c7967cbc7">


Now the `codepipeline-demo-1` stack will be deleted. 

Go to the ECR Repo page that you have already opened in new tab and delete the **autodemo** repo.

<img width="705" alt="Screenshot 2023-07-27 070235" src="https://github.com/Prem-Kumar16/Dashboard_demo_1/assets/75419846/a1e1220b-29a4-4bbf-94db-dac18a7df999">


Then delete `demo-1-dashboard` stack.

Do not forget to delete the downloaded keypair in cloudshell by running the below command

```sh
rm keypair-for-ewaol-demo1.pem
```
