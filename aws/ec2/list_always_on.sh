"""
Output instances that are always running
"""
for region in "us-west-2" "ap-northeast-1" "ap-southeast-1" ; do
  echo $region
  aws --region $region ec2 describe-instances \
    --query 'Reservations[].Instances[?!not_null(Tags[?Key == `Schedule`].Value) && !not_null(Tags[?Key == `aws:autoscaling:groupName`].Value)] | [].InstanceType' \
    --filters Name=instance-state-code,Values=16
done
