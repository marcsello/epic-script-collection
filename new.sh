#!/bin/bash

openfile=""

function new_sh {

	echo "#!/bin/bash" > $1
	chmod +x $1

}


function new_py {

	echo "#!/usr/bin/env python3" > $1
	chmod +x $1

}

function check_file {


	if [[ -f "$1" ]]; then

		echo "The file you want to create already exists: $1"
		printf "Do you want to overwrite it? "
		read -N 1 answer
		echo # newline

		[[ "$answer" != "y" ]] && return 1

	fi

	return 0

}



if [[ "$#" -eq 1 ]]; then # by the file's extension

	ext=$(rev <<< "$1" | cut -d . -f 1 | rev)

	if check_file "$1"; then


		case $ext in
		py)
			new_py $1
		;;
		sh)
			new_sh $1
		;;
		*)
			touch $1
		esac

	fi


	openfile="$1"



elif [[ "$#" -gt 1 ]]; then # first argument is type


	type="$1"
	shift


	while [[ $# -gt 0 ]]; do

		if check_file "$1"; then

			case $type in
				python|py)
					new_py $1
				;;
				bash|sh)
					new_sh $1
				;;
			esac

		fi
		shift
	done


else


	echo "New file creator thingy"
	echo ""
	echo "Usage:"
	echo "new [filename]"
	echo "new [type] [file1] [file2] [file3] ..."
	echo ""
	echo "If only one argument specified, new will try to figure out the type of the new file by it's extension"
	echo "If multiple parameters supplied, the first parameter is the type, others are the files created using this type"
	echo ""
	echo "known types:"
	echo "python - .py"
	echo "bash - .sh"


fi





if [[ "$openfile" != "" ]]; then
	exec nano "$openfile"
fi
