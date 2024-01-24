#!/bin/bash
logFile="apache_access.logs"
 
logContent=$(cat "$logFile")
#taking user input (time range).
echo "Enter timestamp in 24-hr format"
read -p "Enter the start time: " start_time
read -p "Enter the end time: " end_time
 
start=$(date -d "$start_time" "+%s")
end=$(date -d "$end_time" "+%s")
 
# Initialize variables
totalRequests=0
declare -A accessedUrls
declare -A responseCodes
 
 
if [ "$start" -gt "$end" ]; then
    echo "Start time should be less than end time"
    exit 1
fi
 
#main loop to go through each line of log file.
while IFS= read -r line; do
     #extracting timestamp, URL, and response code from the log file
    timestamp=$(echo "$line" | grep -oE '[0-9]{2}:[0-9]{2}:[0-9]{2}')
    url=$(echo "$line" | grep -oE ' "(GET|POST) [^"]+HTTP/1\.[01]"')
    response_code=$(echo "$line" | grep -oE '(408|200|303) | head -n1')
    #checking if timestamp is not empty
    if [[ -n $timestamp ]]; then
        time=$(date -d "$timestamp" "+%s")
        if [[ $time -ge $start && $time -le $end ]]; then
            echo "start : $start and end : $end and time : $time and timestamp:$timestamp"
            ((totalRequests++))
        fi
    fi
 
    # Track accessed URLs
    if [[ -n $url ]]; then
        key="${url//[/_}"
        key="${key//]/_}"
        ((accessedUrls[$key]++))
    fi
    #check if responsecode is not empty.
    # responseCodes
    if [[ -n $response_code ]]; then
        ((responseCodes[$response_code]++))
    fi
done < $logFile
 
#printing total number of requests
echo "Total number of requests between $start_time and $end_time: $totalRequests"
 
#printing urlwise request counts
echo -e "\nURL-wise request counts:"
for key in "${!accessedUrls[@]}"; do
    url="${key//_/[/}"
    url="${url//_/]}"
    echo "$url: ${accessedUrls[$key]}"
done
 
#printing response code counts.
echo -e "\nResponse code counts:"
for code in "${!responseCodes[@]}"; do
    echo "$code: ${responseCodes[$code]}"
done