"""
Open ports from all office and VPN
"""
region=$1
group_id=$2
ports=${@:3}

if [ -z "$group_id" ]; then
  echo "need group_id"
  exit 1
fi
if [ -z "$ports" ]; then
  echo "need ports"
  exit 1
fi

# HCM1, HCM2, HN, Tokyo, VyOS
ips="
113.161.53.242
112.197.61.252
183.91.7.250
27.110.13.83
54.186.72.153
"

case $region in
 t*)
   region_code='ap-northeast-1'
   vpc_id='vpc-07241cd62c2af840a'  # staging
   ;;
 o*)
   region_code='us-west-2'
   vpc_id='vpc-0f13b48df95460bd0'  # staging
   ;;
 s*)
   region_code='ap-southeast-1'
   vpc_id='vpc-0591ab5d586a6fd1f'  # staging
   ;;
 *)
   echo 'invalid region'
   exit 1
   ;;
esac

for port in $ports ; do
  for address in $ips ; do
    aws --region $region_code ec2 authorize-security-group-ingress \
      --group-id ${group_id} \
      --protocol tcp \
      --port $port \
      --cidr $address/32
  done
done
