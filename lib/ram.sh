#
# this function returns usage of ram
#
ram_usage() {

  echo $(free | awk '/Mem:/ {print $3/$2*100}' | cut -d, -f1)
}

ram_wave=0
backward_ram_wave=0
is_ram_alerted=0

#
# this function monitor ram usage when it is higher than limit, warning is sent to telegram chat
#
monitor_ram() {
  # how much ram is used in percent
  local used=$(ram_usage)

  if [[ $LOG_LEVEL == "info" ]]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') | INFO | RAM_USAGE: $used%, WAVE: $ram_wave, BACK_WAVE: $backward_ram_wave" >> $ROOT_DIR/logs/$LOG_FILE
  fi

  # when used ram is lower than limit which is OK
  if [[ $used -lt $RAM_LIMIT ]]; then
    ram_wave=0

    if [[ $is_ram_alerted -eq 1 ]]; then
      backward_ram_wave=$((backward_ram_wave+1))
    fi

    # if warning message is sent and server's ram is resolved, resolve message is sent to telegram chat
    if [[ $is_ram_alerted -eq 1 && $backward_ram_wave -gt 5 ]]; then
      text="✅ Server Status Normal ✅\n\n📊  RAM Load: $used%\n\nThreshold limit of $RAM_LIMIT% is no longer exceeded."
      notify "$text"

      # logging
      if [[ ! -z $LOG_LEVEL ]]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') | NORMALIZED | RAM_USAGE: $used%, WAVE: $ram_wave, BACK_WAVE: $backward_ram_wave" >> $ROOT_DIR/logs/$LOG_FILE
      fi

      is_ram_alerted=0
      backward_ram_wave=0
    fi

    return
  fi

  backward_ram_wave=0

  if [[ $is_ram_alerted -eq 0 ]]; then
    ram_wave=$((ram_wave+1))
  fi

  # if wave is higher than $WAVE_LIMIT, warning message is sent to telegram chat
  if [[ $ram_wave -gt $WAVE_LIMIT && $is_ram_alerted -eq 0 ]]; then
    text="🚨 Server Alert 🚨\n\n🔴 RAM Load Exceeded!\n\n📊 RAM Load: $used%\n\n⚠️ Threshold Limit: $RAM_LIMIT%"
    notify "$text"

    # logging
    if [[ ! -z $LOG_LEVEL ]]; then
      echo "$(date '+%Y-%m-%d %H:%M:%S') | WARNING | RAM_USAGE: $used%, WAVE: $ram_wave, BACK_WAVE: $backward_ram_wave" >> $ROOT_DIR/logs/$LOG_FILE
    fi

    is_ram_alerted=1
  fi

}