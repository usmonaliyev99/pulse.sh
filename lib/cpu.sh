#
# the function returns int which is percent of avg cpu load
#
get_avg_cpu_load() {

  cores=$(lscpu | grep '^CPU(s):' | awk '{print $2}')
  usage=$(uptime | awk '{print $((NF-2))}' | sed 's/0,//' | tr -d ',')

  echo $(($usage/$cores))
}

cpu_wave=0
backward_cpu_wave=0
is_cpu_alerted=0

#
# the function compare $CPU_AVG_LIMIT and avg cpu load
#
monitor_cpu() {

  local cpu_avg=$(get_avg_cpu_load)

  if [[ $LOG_LEVEL == "info" ]]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') | INFO | CPU_AVG: $cpu_avg%, WAVE: $cpu_wave, BACK_WAVE: $backward_cpu_wave" >> $ROOT_DIR/logs/$LOG_FILE
  fi

  # skip if cpu avg is lower than $CPU_AVG_LIMIT
  if [[ $cpu_avg -lt $CPU_AVG_LIMIT ]]; then
    cpu_wave=0

    if [[ $is_cpu_alerted -eq 1 ]]; then
      backward_cpu_wave=$((backward_cpu_wave+1))
    fi

    # send a message to telegram when cpu avg load is stable
    if [[ $is_cpu_alerted -eq 1 && $backward_cpu_wave -gt 5 ]]; then

      text="✅ Server Status Normal ✅\n\n📊  CPU Load: $cpu_avg%\n\nThreshold limit of $CPU_AVG_LIMIT% is no longer exceeded."
      notify "$text"

      # logging
      if [[ ! -z $LOG_LEVEL ]]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') | NORMALIZED | CPU_AVG: $cpu_avg%, WAVE: $cpu_wave_count, BACK_WAVE: $backward_cpu_wave" >> $ROOT_DIR/logs/$LOG_FILE
      fi

      backward_cpu_wave=0
      is_cpu_alerted=0
    fi

    return
  fi

  backward_cpu_wave=0

  if [[ $is_cpu_alerted -eq 0 ]]; then
    cpu_wave=$((cpu_wave+1))
  fi

  # sending error message when wave_count is higher than limit and it is not sent
  if [[ $is_cpu_alerted -eq 0 && $cpu_wave -gt $WAVE_LIMIT ]]; then

    text="🚨 Server Alert 🚨\n\n🔴 CPU Load Exceeded!\n\n📊 Current Load: $cpu_avg%\n\n⚠️ Threshold Limit: $CPU_AVG_LIMIT%"
    notify "$text"

    # logging
    if [[ ! -z $LOG_LEVEL ]]; then
      echo "$(date '+%Y-%m-%d %H:%M:%S') | WARNING | CPU_AVG: $cpu_avg%, WAVE: $cpu_wave, BACK_WAVE: $backward_cpu_wave" >> $ROOT_DIR/logs/$LOG_FILE
    fi

    is_cpu_alerted=1
  fi

}
