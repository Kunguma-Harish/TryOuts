url="https://www.irctc.co.in"
keyword="LOGIN"
while true; do
  # Use curl to fetch the website content and store it in a variable
  content="$(curl "$url")"

  # Check if the keyword exists in the content
  if [ -n "$(echo "$content" | grep "$keyword")" ]; then
    echo "Found"
    osascript -e 'display altert notification "Website is active now 👍🏻"'
#    pmset displaysleepnow
    break
  else
    echo "The keyword '$keyword' was not found on $url. Retrying in 5 seconds..."
    sleep 5
  fi
done
