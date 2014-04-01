#!/bin/sh

# This programs checks some common norm mistakes.
# Feel free to suggest improvements :)
# ~avannest

# The script tests all files present in the given repertory.

export CLICOLOR=1
echo "\033[38;5;167mThanks for using SpiderNorminette v0.14\033[0m"

# Print Usage if -h is given then exit.

if [ "$1" = "-h" ] ; then
	echo "Usage $0 [-h] [--headers] [directory]"
	echo "This script check some common norm mistakes, in all files present in the given repertory ."
	echo "By default it take current directory as input."
	echo "Feel free to contribute by pull request at https://github.com/dyarob/SpiderNorminette :)"
	echo "~avannest"
	exit
fi

# Check if --header is provide : if true check for .h files.
# If no diretory is given use current one.
# If $1 is empty check for .c file in directory
# If no diretory check in current one.

if [ $# -gt 0 ]
then
	if [ "$1" = "--headers" ] ; then
		if [ $# -gt 1 ] ; then
			FILES="$2/*.h"
		else
			FILES=".*.h"
		fi
	else
		if [ -n $1 ] ; then
			FILES="$1/*.c"
		else
			FILES=".*.c"
		fi
	fi
fi

function	ft_grep {
grep -n "$1" $FILES | grep -v ":[\*][\*]\|/[\*]" | grep -v "Binary file"
}

function	category {
	echo "\033[38;5;36m$1:\033[0m"
}

function	check {
	echo "\033[38;5;30m- Checking $1...\033[0m"
}

category "SPACING & PUNCTUATION"
check "spacing at end of lines"
ft_grep " $\|\t$"

check "spacing at the beginning of lines"
ft_grep "\n "

check "spacing after keywords"
ft_grep "if(\|else(i\|return("

check "spacing around punctuation marks"
ft_grep "( \| )"
ft_grep "{ \| {\|{\t\|[;a-zA-Z0-9]{[;a-zA-Z0-9]\|[;a-zA-Z0-9]}[;a-zA-Z0-9]"
ft_grep " ,"

check "parenthesis around return value"
ft_grep "return " | grep -v "return ("

check "spacing around any = operator"
ft_grep "=" | grep -v " = \| == \| != \| -= \| += \| *= \| /= \| >= \| <= "

check "lines with more than 80 characters"
grep -nE "^.{81,}$" $FILES | grep -v "Binary file"

check "space after * in function prototypes"
ft_grep "\t[\*]  *\|\t[\*]\t\t*"

category "FUNCTIONS"
check "number of parameters shouldn't exceed 4"
ft_grep "([a-zA-Z0-9]*, [a-zA-Z0-9]*, [a-zA-Z0-9]*, [a-zA-Z0-9]*,"

category "REQUIRED CASTS"
check "casts before malloc calls"
ft_grep " malloc("

check "casts before ft_memalloc calls"
ft_grep " ft_memalloc("

category "COMMENTARIES"
check "// commentaries"
ft_grep "//"

category "MISC"
check "more than one instruction per line"
ft_grep ";.*;"
