#!/bin/bash

# change the path of the log file
log_directory="/home/kajal_jha/Bash_Scripts/logfiles"

# Ilerating over all log files in the directory
for log_file in "$log_directory"/*.logs; do
  echo "Processing $log_file"
  echo

  # fetching the required information & displaying
  while IFS= read -r logs_entry; do
      # Extracting the TimeStamp
      timestamp1=$(echo "$logs_entry" | grep -oE '\[\w{3} (\w{3} [0-9]{2} [0-9:]+\.[0-9]+ [0-9]+)\]')
      timestamp2=$(echo "$logs_entry" | grep -oE '([A-Za-z]{3} [0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2})')
      timestamp3=$(echo "$logs_entry" | grep -oE '\[([0-9]{2}/[A-Za-z]+/[0-9]{4}:[0-9]{2}:[0-9]{2}:[0-9]{2} \+[0-9]{4})\]')
                                                   
      
      if [ -n "$timestamp1" ]; then
          echo "Timestamp: $timestamp1"
      elif [ -n "$timestamp2" ]; then
          echo "Timestamp: $timestamp2"
      elif [ -n "$timestamp3" ]; then
          echo "Timestamp: $timestamp3"
      fi
      
      # Extracting the URL
      url=$(echo "$logs_entry" | grep -oE '"(GET|POST) [^"]+ HTTP/1\.[01]"')
      if [ -n "$url" ]; then
          echo "Url: $url"
      fi
      
      #Extracting the Response Code
      response_code=$(echo "$logs_entry" | grep -oE '(408|200|303) | head -n1')
      if [ -n "$response_code" ]; then
          echo "Response Code: $response_code"
      fi
      
      # Extracting the Process Id
      pid_match1=$(echo "$logs_entry" | grep -oP 'pid ([0-9]+)')
      pid_match2=$(echo "$logs_entry" | grep -oP 'CRON\[(\d+)\]')

      if [ -n "$pid_match1" ]; then
            pid1=$(echo "$pid_match1" | awk '{print $2}')
            echo "Process Id: $pid1"
      fi
      if [ -n "$pid_match2" ]; then
            pid2=$(echo "$pid_match2" | awk '{print $1}')
            echo "Process Id: $pid2"
      fi
      
      
  done < "$log_file"
  
  echo
  echo
done