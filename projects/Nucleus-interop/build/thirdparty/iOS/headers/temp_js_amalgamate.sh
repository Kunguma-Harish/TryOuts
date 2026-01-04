if [ $# -eq 0 ]; then
 echo "Usage: emscripten_bindings_amalgamate <bindings_dir>"
exit 1
fi
bindings_dir=$1
output_file_name="ems_bindings_amalgamated.js"
output_file="$bindings_dir/$output_file_name"
if [ ! -e "$output_file" ]; then
    echo 'function loadVaniDevProtoProperties(module) {' > "$output_file"
    echo "Created $output_file for amalgamation"
    for i in $bindings_dir/*.jsx; do
        echo -e "\t Adding $i"
        cat "$i" >> "$output_file"
        rm $i
    done
    echo "}" >> "$output_file"
else
    echo "ems_bindings_amalgamated already exists.. so deleting any jsx files if available"
    if ls $bindings_dir/*.jsx &> /dev/null; then
        for i in $bindings_dir/*.jsx; do
            echo -e "\t Deleting $i"
            rm $i
        done
    else
        echo "files do not exist"
    fi
fi