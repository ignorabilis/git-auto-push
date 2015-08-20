#!/bin/bash
#Automatically pushes any changes for files generated with a tool.

usage() { echo "
Complete list of arguments, all are required:
	-w	<string>	The path to the file to watch.
	-s	<string>	The path to the source.
	-d	<string>	The destination path (somewhere in the source).
	-m	<string>	The git commit message.
	-t	<int>		The time to wait after the first  

Tools needed:
 1. sudo apt-get install inotify-tools
 2. ssh (otherwise git will require password on push) - https://confluence.atlassian.com/bitbucket/getting-started-with-bitbucket/set-up-version-control/set-up-git/set-up-ssh-for-git" 1>&2; exit 1; }

while getopts ":w:s:d:m:t:" o; do
    case "${o}" in
        w)
            w=${OPTARG}
            ;;
        s)
            s=${OPTARG}
            ;;
        d)
            d=${OPTARG}
            ;;
        m)
            m=${OPTARG}
            ;;
        t)
            t=${OPTARG}
            ((t >= 10)) || usage
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${w}" ] || [ -z "${s}" ] || [ -z "${d}" ] || [ -z "${m}" ] || [ -z "${t}" ]; then
    usage
fi

auto_gen_file=$w
auto_mod_path=${w%/*} 		
source_path=$s
destination_path="$s$d"
commit_message=$m
delay_for=$t

echo "Watching file: $auto_gen_file in folder: $auto_mod_path"

export GIT_WORK_TREE=$source_path
export GIT_DIR="${GIT_WORK_TREE}/.git"

while true
do
	#the algorithm actually watches the folder of the file - 
	#that is because inotifywait does not behave properly when watching a single file
	if inotifywait -e modify $auto_mod_path; then
		sleep $delay_for
		cp $auto_gen_file $destination_path
		sleep 5

		git add txt
		git commit -m "$commit_message"
		git push
	fi
done
