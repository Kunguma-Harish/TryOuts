#!/bin/sh

############################################################
# Help                                                     #
############################################################

function Help() {
	# Display Help
	echo "Copies Assets (.xcassets) from given source directory to target directory.\n"
	echo "Usage:\tsh CopyAssets.sh [-s <source_directory>] [-t <target_directory>]"
	echo "\nOptions:\n"
	echo "s\tSource directory from which .xcassets should be copied from"
	echo "t\tTarget directory to which .xcassets should be copied to"
	echo "H|?\tPrint this Help"
	exit 1
}

############################################################
# Helper Functions                                         #
############################################################

function copy_assets {
	relative_path="$1"
	path_suffix=${relative_path##*"$source_dir/"}

	cd "$source_dir"
	rsync -aR "$path_suffix" "$target_dir"
}

function find_and_copy_assets {
	if [[ ! -e "$1" ]]; then
		return
	fi
	asset_paths=(`find "$1" -type d -name *.xcassets`)

	for (( i=0; i<${#asset_paths[@]}; i++ )); do
	     copy_assets "${asset_paths[$i]}"
	done	
}

function copy_show_assets {
	rm -rf "${target_dir}"
	mkdir -p "${target_dir}"

	show_asset_paths=(
		"${source_dir}/Show-iOS"
		"${source_dir}/Show-tvOS"
		"${source_dir}/Show-macOS"

		"${source_dir}/SlideShowKit-iOS"
		"${source_dir}/SlideShowKit-macOS"
		"${source_dir}/SlideShowKit-tvOS"

		"${source_dir}/Shared/Show/iOS_tvOS"
		"${source_dir}/Shared/Show/iOS_macOS"
		"${source_dir}/Shared/Show/macOS_tvOS"

		"${source_dir}/Shared/Common"
		"${source_dir}/Shared/SlideShowKit"
	)

	for (( index=0; index<${#show_asset_paths[@]}; index++ )); do
		find_and_copy_assets "${show_asset_paths[$index]}"
	done
}

############################################################
# Process Input                                            #
############################################################

while getopts "s:t:h?" option; do
	case "$option" in
		s) source_dir="`readlink -f $OPTARG`" ;;
		t) target_dir="`readlink -f $OPTARG`/External/GraphikosAppleAssets" ;;
		?|h) Help ;;
	esac
done

[ -z "$source_dir" ] && [ -z "$target_dir"] && Help

copy_show_assets