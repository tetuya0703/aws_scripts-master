jobs=`aws sagemaker search --resource TrainingJob --sort-by CreationTime --query 'Results[].TrainingJob' --search-expression '
{
    "Filters": [
        {
            "Name": "TrainingJobStatus",
            "Operator": "Equals",
            "Value": "InProgress"
        }
    ]
}
'`

len=$(echo $jobs | jq length)
echo "spot_or_non_spot	InProgress_job_name	Instance_type"
echo ''
for i in `seq 0 $(($len - 1))`; do
  name=`echo $jobs | jq -r ".[$i].TrainingJobName"`
  instance_type=`echo $jobs | jq -r ".[$i].ResourceConfig.InstanceType"`
  is_spot=`aws sagemaker describe-training-job --training-job-name $name --query 'EnableManagedSpotTraining'`
  spot_msg='non-spot'
  if [ $is_spot == true ] ; then
    spot_msg='is-spot'
  fi
  echo $spot_msg"	"$name"	"$instance_type
done
