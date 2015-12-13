#!/bin/bash
function usage
{
	echo "Usage: startspeedtest [OPTIONS]"
	echo ""
	echo "Options		GNU long option			Meaning"
	echo "-h		--help				Show this message"
	echo "-d <directory>	--directory <directory>		Destination file to where the result should be written. By default is in \"/var/www/speedtestresults\""
	echo "-o <filename>	--testoutput <filename>		If this option is used, the last output from the speedtest script will be kept in the designed location"
	echo "-s <script>	--script <script>		Speed test script. If this option is not used, by default, it will be used /root/SpeedTestCollector/speedtest-cli-modified"
}

#Starting script at time $hour...
hour=$(date +"%H:%M")
now=$(date +"%m_%d_%Y")

directory="/var/www/speedtestresults"
output=""
script="/root/SpeedTestCollector/speedtest-cli-modified"

while [ "$1" != "" ]; do
    case $1 in
        -d | --directory )	shift
                                directory="$1"
                                ;;
	-o | --testoutput )	shift
				output="$1"
				;;
	-s | --script )		shift
				script="$1"
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

tempOutput="/var/www/speedtestresults/output.txt"
#Checking if using $output
if ! [ -z "$output" ]
	then
	echo "Using output \"$output\"."
	tempOutput="$output"
fi

#Execute script to test speed
echo "Starting to execute the speed test..."
"$(echo $script)" > "$(echo $tempOutput)"
echo "Output saved at $tempOutput... retrieving values..."
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

echo "Download speed at $download"
echo "Upload speed at $upload"
echo "Saving data..."
echo "$hour;$download;$upload" >> "$file"

#If no output was set, remove file, otherwise, keep it
if [ -z "$output" ]
        then
	echo "Removing temporary files..."
	rm "$(echo $tempOutput)"
fi
echo "Done."
