#!/bin/bash
echo "Kills the with highest memory consumption"
ProcessId=`ps au --sort -%mem | head -11 | awk 'NR==2 {print $2}'`
echo $Processid
kill -9 $Processid
if [[ $? -eq 0 ]];
then
echo "Process is killed successfully"
else
echo "Can't kill the process"
fi