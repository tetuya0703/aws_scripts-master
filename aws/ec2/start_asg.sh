"""
Add ScheduledAction to ASG
"""
group_name=$1
time_hour=$2
if [ -z "$group_name" ]; then
  echo "need group_name"
  exit 1
fi
if [ -z "$time_hour" ]; then
  echo "need time_hour"
  exit 1
fi

schedule_name=start_at_${time_hour}_JST
utc_hour=$(($time_hour - 9))
start_time=`gdate -d 'tomorrow' -u +"%Y-%m-%dT${utc_hour}:00:00Z"`
recurrence="0 ${utc_hour} * * 1-5"

aws autoscaling put-scheduled-update-group-action \
  --auto-scaling-group-name $group_name \
  --scheduled-action-name  $schedule_name \
  --start-time $start_time \
  --recurrence "$recurrence" \
  --min-size 1 \
  --max-size 2 \
  --desired-capacity 1
