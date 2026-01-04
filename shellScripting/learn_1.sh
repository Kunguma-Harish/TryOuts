url="http://exam.unom.ac.in"
keyword="BCOM/BCOM(CA)/BCOM(A&F)/BCOM(HONS.)/PG/PROFESSIONAL Examination Results."
#content=$(curl "https://www.apple.com")
#echo $content

while true; do
  # Use curl to fetch the website content and store it in a variable
  content="$(curl "$url")"

  # Check if the keyword exists in the content
  if [ -n "$(echo "$content" | grep "$keyword")" ]; then
    echo "Found"
    osascript -e 'display altert notification "Papu result kedachiruchu" with title "Got the result"'
#    pmset displaysleepnow
    break
  else
    echo "The keyword '$keyword' was not found on $url. Retrying in 5 seconds..."
    sleep 5
  fi
done
