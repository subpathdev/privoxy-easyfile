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
URLS=(\"easylist.to/easylist/easylist.txt\" \"easylist.to/easylistgermany/easylistgermany.txt\")

# dependencies
DEPENDS=('sed' 'grep' 'bash' 'curl')

#function for exists
command_exists () {
	type ${1} > /dev/null;
}

# if $UID != 0 then echo -e "Root privileges needed. Exit. \n\n" && usage && exit 1

for deb in ${DEPENDS[@]} 
do
	if ! command_exists ${dep} ; then
		echo "The command ${dep} can't be found. Please install the package providing ${dep} and run $0 again. Exit" >&2
		exit 1
	fi	
done

# downloading the files and saving in /tmp/
download () {
	for url in ${URLS[@]}
	do
		debug "Downloading ${url} ...\n" 0
		curl -k  ${url} > /tmp/${url//\//#}
	done
	debug "done download" 0
}

# function debug()
debug () {
	echo ${1}
}

# main funcation
main () {
	for url in ${URLS[@]}
	do
		debug "create variables: file and dictory" 2
		file=/tmp/${url//\//#}
		dictory=/etc/privoxy
		action=${url//\//#}.action
		filter=${dictory}/${url//\//#}.filter

		debug "Processing at ${url} .../n" 0
		
		if [ grep -e Adblock ${file}]; then
			echo "This file isn't an Adblock file"
		fi

		# this want be done for the action and the filter file
		# deleting first line
		sed -i '1d' ${file} 
		
		# creating actionfile and fill it
		# insert {+block{blocked}} after each line, which include block
		sed '/block/a {+block{blocked}}' ${file} > ${dictory}/${action}
		# insert {-block{whitelisted}} after each line, which include whitelist
		sed -i '/whitelist/a {-block{whitelisted}}' ${file}
		# deleting all comments
		sed -i '/^!.*/d' ${dictory}/${action}
		# deleting all lines, which startetd with a #
		sed -i '/^#.*/d' ${dictory}/${action}

		# creating filterfile and fill it
		# deleting all lines, which beginnen with a &
		sed '/^&.*/d' ${file} > ${filter}
		# deleting all lines, which beginning with a +
		sed -i '/^+.*/d' ${filter}
		# deleting all lines, which beginning with a -
		sed -i '/^-.*/d' ${filter}
		# deleting all lines, which beginning with a /
		sed -i '/^\/.*/d' ${filter}
		# deleting all lines, which beginning with a .
		sed -i '/^\..*/d' ${filter}
		# deleting all lines, which beginning with a :
		sed -i '/^:.*/d' ${filter}
		# deleting all lines, which beginning with a ;
		sed -i '/^;.*/d' ${filter}
		# deleting all lines, which beginning with a =
		sed -i '/^=.*/d' ${filter}
		# deleting all lines, which beginning with a ;
		sed -i '/^;.*/d' ${filter}
		# deleting all lines, which beginning with a ?
		sed -i '/^?.*/d' ${filter}
		# deleting all lines, which beginning with a ^
		sed -i '/^\^.*/d' ${filter}
		# deleting all lines, which beginning with a _
		sed -i '/^_.*/d' ${filter}
		# deleting all lines, which beginning with a |
		sed -i '/^|.*/d' ${filter}
		# deleting all lines, which beginning with a ,
		sed -i '/^,.*/d' ${filter}
		# deleting all lines, which beginning with a number
		sed -i '/^[0-9].*/d' ${filter}
		# deleting all lines, wich beginning with a letter
		sed -i '/^[a-zA-Z].*/d' ${filter}
		# deleting all lines, wich beginning with a @
		sed -i '/^@.*/d' ${filter}

		#insert filterfile and actionfile into the config
	done
}

main

exit 1 
