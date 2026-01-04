#!/bin/sh

url="https://workplace.zoho.com/#cliq_app/company/64396901/chats/CT_2242279121967653169_64396901-B1"
keyword=“a”

while true; do
  # Use curl to fetch the website content and store it in a variable
  content="$(curl -s "$url")"

  # Check if the keyword exists in the content
  if [ -n "$(echo "$content" | grep "$keyword")" ]; then
    echo "The keyword '$keyword' was found on $url."
    break
  else
    echo "The keyword '$keyword' was not found on $url. Retrying in 5 seconds..."
    sleep 5
  fi
done
