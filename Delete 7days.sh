#!/bin/bash
 
# Usage: cleanup_old_logs &lt;folder&gt; &lt;days&gt;
# Removes all log files in the directory older than a certain number of days
 
FOLDER=$1
N_DAYS=$2
 
# Validate
if [ "$FOLDER" == "" ] || [ "$N_DAYS" == "" ]
then
echo "Usage: $0 folder number_of_days"
exit 1
fi
 
if [ ! -d "$FOLDER" ]
then
echo "$FOLDER is not a directory"
exit 2
fi
 
# Remove
echo "Deleting files in $FOLDER older than $N_DAYS days"
find $FOLDER/* -mtime +$N_DAYS -exec rm {} \;