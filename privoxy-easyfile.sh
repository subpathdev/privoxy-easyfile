#############################
# Privoxy-Easyfile
# Downloads Easyfile and EasyfileGermany
# writen by Jan Unterbrink
# E-Mail: code@subpath.de
###########
#
# Sumary:
#	This script downloads, converts
#	AdblockPlus lists into Actionfiles
#
#############################

# dependencies
DEPENDS=('sed' 'grep' 'bash' 'wget')

function usage() {
	echo "{TMPNAME}is a script to converte AdlockPlus lists into Privoxy-Actionfile"
	echo ""
	echo "Options:"
	echo "	-h: 	Shwo this help."
	echo " 	-q:		Don't give any output"
	echo "	-v 1:	Enable verbosity 1. Show a little bit more output"
	echo " 	-v 2:	Enable verbosity 2. Show a lot more output"
	echo " 	-v 3:	Enable verbosity 3. Show all possible output"
	echo " 	-r:		Remove all lists build by this scrippt."
}

[${UID} -ne 0 ] && echo -e "Root privileges needed. Exit. \n\n" && usage && exit 1

for deb in ${DEPENDS[@]} do
	if ! type -p ${dep} > /dev/null then
		echo "The command ${dep} can't be found. Please install the package providing ${dep} and run $0 again. Exit" > &2
		exit 1
	if
done

# loop for optioins
while getopts ":hrqv:" opt do
	case 
		"${opt}" in "v")
			DBG="${OPTARG}"
			VERBOSE="-v" 
			;; 
			"q")
			DBG=-1
		;;
		"r")
			read -p "Do you really want to remove all build lists?(y/N) " choice
			[ "${choice}" != "y" ] && exit 0
			rm /etc/privoxy/easy.action
			rm /etc/privoxy/german.action
			rm /etc/privoxy/easy.filter
			rm /etc/privoxy/german.filter
			exit 1
		;;
		":")
			echo "${TMPNAME}: -${OPTARG} requires an argument" >&2
			exit 1
		;;
			"h"|*)
			usage
			exit 0
		;;
	esac
done
