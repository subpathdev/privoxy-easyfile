#############################
# Privoxy-Easyfile
# Downloads Easyfile and EasyfileGermany
# writen by Jan Unterbrink
# E-Mail: privoxy-easyfile@subpath.de
###########
#
# Sumary:
#	This script downloads, converts
#	AdblockPlus lists into Actionfiles
#
#############################

# lists of the using URLS
# they are used by AdBlockPlus
URLS=(\"https://easylist-downloads.adblockplus.org/easylistgermany.txt\", \"https://easylist-downloads.adblockplus.mozdev.org/easylist/easylist.txt\")

# dependencies
DEPENDS=('sed' 'grep' 'bash' 'wget')

#function for exists
command_exists () {
	type "$1" $> /dev/null;
}

# which parameter you can insert
function usage() {
	echo "{TMPNAME}is a script to converte AdlockPlus lists into Privoxy-Actionfile"
	echo ""
	echo "Options:"
	echo "	-h: 	Show this help."
	echo " 	-q:		Don't give any output"
	echo "	-v 1:	Enable verbosity 1. Show a little bit more output"
	echo " 	-v 2:	Enable verbosity 2. Show a lot more output"
	echo " 	-v 3:	Enable verbosity 3. Show all possible output"
	echo " 	-r:		Remove all lists build by this scrippt."
}

if $UID != 0 then echo -e "Root privileges needed. Exit. \n\n" && usage && exit 1

for deb in ${DEPENDS[@]} 
do
	if ! command_exists ${dep} ; then
		echo "The command ${dep} can't be found. Please install the package providing ${dep} and run $0 again. Exit" >&2
		exit 1
	fi	
done

# downloading the files and saving in /tmp/
function download() {
	for url in ${URLS[@]}
	do
		debug "Downloading ${url} ...\n" 0
		wget -t 3 ${url} > /tmp/${url//\//#}
	done
	debug "done download" 0
}

# function debug()
function debug() {
	[ ${DBG} -ge ${2} ] && echo -e "${1}"
}

# main funcation
function main() {
	for url in ${URLS[@]}
	do
		debug "create variables: file and dictory" 2
		file=/tmp/${url//\//#}
		dictory=/etc/privoxy

		debug "Processing at ${url} .../n" 0
		
		# downloading
		download

		if [ grep -e Adblock ${file} == ""]; then
			echo "This file isn't an Adblock file"
		fi

		# this want be done for the action and the filter file
		# deleting first line
		sed -i '1d' ${file} 
		# insert {-block{whitelisted}} after each line, which include whitelist
		sed -i '/whitelist/a {-block{whitelisted}}' ${file}

		#creating actionfile and fill it
		touch ${dictory}/${url//\//#}.action
		# insert {+block{blocked}} after each line, which include block
		sed '/block/a {+block{blocked}}' ${file} > ${dictory}/${url//\//#}
		# deleting all comments
		sed -i '/^!.*/d' ${dictory}/${url//\//#}
		# deleting all lines, which startetd with a #
		sed -i '/^#.*/d' ${dictory}/${url//\//#}

		#creating filterfile and fill it
		touch ${dictory}/${url//\//#}.filter
		echo -e "{+block{blacklisted at ${url}}}" > ${dictory}/${url//\//#}.filter


		#insert filterfile and actionfile into the config
	done
}

# loop for options
while getopts ":hrqv:" opt 
do
	case "${opt}" in 
		"v")
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

exit 0
