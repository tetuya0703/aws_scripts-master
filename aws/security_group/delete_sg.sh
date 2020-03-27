"""
Delete unused SecurityGroup
"""
#!/bin/bash
region=$1
case $region in
 ap-northeast-1)
   region_code=$region
   ;;
 us-west-2)
   region_code=$region
   ;;
 ap-southeast-1)
   region_code=$region
   ;;
 t*)
   region_code='ap-northeast-1'
   ;;
 o*)
   region_code='us-west-2'
   ;;
 s*)
   region_code='ap-southeast-1'
   ;;
 *)
   echo 'invalid region'
   exit 1
   ;;
esac

echo 'delete the following security groups'
echo "sg_id,sg_name"
for sg in `aws --region $region_code ec2 describe-security-groups --query 'SecurityGroups[].[join(\`,\`,[GroupId,GroupName])]' --output text`; do
  sg_id=$(echo ${sg} | cut -d ',' -f1)
  sg_name=$(echo ${sg} | cut -d ',' -f2)
  if [ $sg_name = 'default' ] ; then
    continue
  fi
  if [[ "$sg_id" != "sg-"* ]] ; then
    continue
  fi

  # このSGを使用しているENIがあるか問合せ
  eni=$(aws --region $region_code ec2 describe-network-interfaces --filters Name=group-id,Values=${sg_id} --query 'NetworkInterfaces[]' --output text)

  if [ -n "${eni}" ]; then
    continue
  fi

  # このSGを使用しているLaunch Configutationがあるか問合せ
  as=$(aws --region $region_code autoscaling describe-launch-configurations --query "LaunchConfigurations[?contains(SecurityGroups,\`${sg_id}\`)].[LaunchConfigurationName]" --output text)
  if [ -n "${as}" ]; then
    continue
  fi

  echo "${sg}"
  aws --region $region_code ec2 delete-security-group --group-id $sg_id
done
