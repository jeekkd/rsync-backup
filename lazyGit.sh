#!/usr/bin/env bash

# Written by: https://gitlab.com/u/huuteml
# Website: https://daulton.ca
# Purpose: To make basic git usage even easier and quicker then it already is
#
# Instructions:
# Change to where you're working on your project wherever your git repo is initalized then run the script
# and following the prompts
#
# Tips:
# To make this process even quicker and easier you link the script into your local bin so you can call it globally
# 
# Example: ln /home/<username>/scripts/lazyGit.sh /usr/local/bin/lazyGit
# Now calling it will become as easy as typing out 'lazyGit' which will call and launch the script

control_c() {
	echo "Control-c pressed - exiting NOW"
	exit $?
}

trap control_c SIGINT

dir=$(pwd)
echo "Working directory is: $dir.."
echo "Is this the correct git directory? Y/N"
read -r answer
if [[ $answer == "Y" || $answer == "y" || $answer = "" ]]; then
	echo
	git add *
	echo "What would you like the commit message to be?"
	read -r answer
	echo
	echo
	git commit -m "$answer"
	git push
	if [ $? -eq 0 ]; then	
		echo "Git pushed!"
	else
		echo "Error: git push failed"
	fi
else
	echo "Answer was $answer, exiting.."
	exit $?
fi

