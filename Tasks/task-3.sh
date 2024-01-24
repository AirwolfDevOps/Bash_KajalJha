#!/bin/bash

logFile="apache_access.logs"
dir="/home/kajal_jha/Bash_Scripts/Tasks"
# Initialize Variables
totalRequests=0
declare -A urlCounts
declare -A responseCodeCounts

while IFS= read -r line; do
    # Extract URL
    #url=$(echo "$line" | grep -oP ' "(GET|POST) [^"]+HTTP/1\.[01]"' | cut -d' ' -f2)
    url=$(echo "$line" | grep -oE ' "(GET|POST) [^"]+HTTP/1\.[01]"')

    # Extract Response Code
    response_code=$(echo "$line" | grep -oE '(408|200|303)' | head -n1)

    ((totalRequests++))
    # Track accessed URLs
    if [[ -n $url ]]; then
        key="${url//[/_}"
        key="${key//]/_}"
        ((urlCounts[$key]++))
    fi
    #check if responsecode is not empty.
    # responseCodes
    if [[ -n $response_code ]]; then
        ((responseCodeCounts[$response_code]++))
    fi
done < "$logFile"

# Generate a report
report="
Web Server Activity Report
--------------------------

Total Requests: $totalRequests

Top Accessed URLs:
$({ for url in "${!urlCounts[@]}"; do echo "  [$url]: ${urlCounts[$url]} requests"; done } | sort -k4,4nr | head -n 5)

Response Code Distribution:
$({ for code in "${!responseCodeCounts[@]}"; do echo "  [$code]: ${responseCodeCounts[$code]} requests"; done } | sort -k1,1n)

"

# Save the report to a file
reportPath="$dir/Task3Report.txt"
echo "$report" > "$reportPath"

echo "Report generated and saved to: $reportPath"
