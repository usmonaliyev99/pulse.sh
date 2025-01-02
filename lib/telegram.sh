#
# The function sends message to telegram chat
#
notify() {
  text=$1

  if [[ -z $text ]]; then
    echo "Notify function requires one positional argument."
    return
  fi

  # replace %0A instead of /n for new line
  text=$(echo $text | sed 's/\\n/%0A/g')

  # send http request to telegram server
  curl https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage \
    -d "text=$text" \
    -d "chat_id=$TELEGRAM_CHAT_ID" > /dev/null 2>&1
}
