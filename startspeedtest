#!/bin/bash
function usage
{
	echo "Usage: startspeedtest [OPTIONS]"
	echo ""
	echo "Options		GNU long option			Meaning"
	echo "-h		--help				Show this message"
	echo "-d <directory>	--directory <directory>		Destination file to where the result should be written. By default is in \"/var/www/speedtestresults\""
	echo "-o <filename>	--testoutput <filename>		If this option is used, the last output from the speedtest script will be kept in the designed location"
}

#Starting script at time $hour...
hour=$(date +"%H:%M")
now=$(date +"%m_%d_%Y")

directory="/var/www/speedtestresults"
output=""

while [ "$1" != "" ]; do
    case $1 in
        -d | --directory )	shift
                                directory="$1"
                                ;;
	-o | --testoutput )	shift
				output="$1"
				;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

#Defining output folder
file="$directory/result_$now.csv"
echo "Sending result to \"$file\""

tempOutput="output.txt"
#Checking if using $output
if ! [ -z "$output"]
	then
	echo "Using output \"$output\"."
	tempOutput = output
fi

#Execute script to test speed
./speedtest-cli-modified > "$(echo $tempOutput)"
#Retrive data from test
download="$(sed '7q;d' $tempOutput)"
upload="$(sed '9q;d' $tempOutput)"
if [ -z "$download" ]
	then
	download="0"
fi
download="$(echo $download | sed -r 's/\.+/,/g')"

if [ -z "$upload" ]
	then
	upload="0"
fi
upload="$(echo $upload | sed -r 's/\.+/,/g')"

echo "$hour;$download;$upload" >> "$file"

#If no output was set, remove file, otherwise, keep it
if [ -z "$output"]
        then
	rm "$(echo $tempOutput)"
fi
