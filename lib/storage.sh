#
# Get a percent of usage mount path
#
storage_usage() {

  echo $(df | grep " $1$" | awk '{print $((NF-1))}' | tr -d %)
}

monitor_storage() {

  for path in $MOUNT_PATHS;
  do
    local du=$(storage_usage $path)

    if [[ -z $du ]]; then
      continue
    fi

    if [[ $du -lt $STORAGE_LIMIT ]]; then
      continue
    fi

    text="🚨 Server Alert 🚨\n\n🔴 Storage Usage Exceeded!\n\n📊 Current Usage: $du%\n\n⚠️ Threshold Limit: $STORAGE_LIMIT%"
    notify "$text"
    
  done
}