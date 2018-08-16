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





if [[ "$#" -eq 1 ]]; then # by the file's extension

	ext=$(rev <<< "$1" | cut -d . -f 1 | rev)


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


	openfile="$1"



elif [[ "$#" -gt 1 ]]; then # first argument is type


	type="$1"
	shift


	while [[ $# -gt 0 ]]; do

		case $type in
			python|py)
				new_py $1
			;;
			bash|sh)
				new_sh $1
			;;
		esac
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
