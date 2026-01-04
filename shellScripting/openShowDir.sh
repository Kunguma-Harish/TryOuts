dir="/Users/kunguma-14252/Library/Containers/com.zoho.show"

if [ -d $dir ]; then
  echo "$dir does exist."
  substring="/com.zoho.show"
  dir2="/Users/kunguma-14252/Library/Containers"
  echo "first if $dir2"
  $openDirectory $dir2
  else
    echo "first else"
  openDirectory dir
fi

 openDirectory() {
 echo "Inside Function"
 if [ -d $1 ]; then
 echo "$DIRECTORY does exist."
 else
 cd $1
 echo "Here you go"
 open $1
 echo
 fi
 }
