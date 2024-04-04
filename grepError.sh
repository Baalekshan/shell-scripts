#!/bin/bash
error_file=`cat /var/log/messages`
matched_error=`grep -i error /var/log/messages`
echo $matched_error
if [[ $? -eq 0 ]];
then
        echo "Found error in OS logs: $matched_error "
else
        echo "No error in message logs"
fi