
if [ $# -eq 0 ]; then
 echo "Usage: emscripten_bindings_amalgamate <bindings_dir>"
exit 1
fi
bindings_dir=$1
output_file_name="vani_bindings_amalgamated.nex"
output_file="$bindings_dir/$output_file_name"
if [ ! -e "$output_file" ]; then
echo '@package com.zoho.nexus.vaninucleus;' > "$output_file"
echo '@import vaniproto_bindings_amalgamated;' >> "$output_file"
echo "Created $output_file for amalgamation"
for i in $bindings_dir/*.nx; do
echo -e "\t Adding $i"
cat "$i" >> "$output_file"
rm $i
done
else
echo "vani_bindings_amalgamated already exists.. so deleting any proto nx files if available"
if ls $bindings_dir/*.nx &> /dev/null; then
for i in $bindings_dir/*.nx; do
echo -e "\t Deleting $i"
rm $i
done
else
echo "files do not exist"
fi
fi