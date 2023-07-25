sudo /usr/local/bin/kubectl delete pod canapp
sudo /usr/local/bin/kubectl delete service canapp-app-service
aws configure set aws_access_key_id $(aws --profile default configure get aws_access_key_id)
aws configure set aws_secret_access_key $(aws --profile default configure get aws_secret_access_key)
aws configure set default.region ap-south-1
sudo /usr/local/bin/kubectl delete secret regcred
sudo /usr/local/bin/kubectl create secret docker-registry regcred \
  --docker-server=783584839454.dkr.ecr.ap-south-1.amazonaws.com \
  --docker-username=AWS \
  --docker-password=$(aws ecr get-login-password --region ap-south-1)
sudo /usr/local/bin/kubectl apply -f /home/ewaol/Dashboard_demo_1/deployaws.yaml -f /home/ewaol/Dashboard_demo_1/servicedeploy.yaml
