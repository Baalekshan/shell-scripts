#!/bin/bash

function get_answer {

unset answer
ask_count=0

while [ -z "$answer" ] 
do
     

     if [ -n "$line2" ]
     then               
          echo $line1
          echo -e $line2" \c"
     else                  
          echo -e $line1" \c"
     fi

     read -t 60 answer
done

unset line1
unset line2

}

function process_answer {

answer=$(echo $answer | cut -c1)

case $answer in
y|Y)
;;
*)
        echo
        echo $exit_line1
        echo $exit_line2
        echo
        exit
;;
esac
unset exit_line1
unset exit_line2

} 

echo "Automated Deletion of accounts "
echo
line1="Please enter the username of the user "
line2="account you wish to delete from system:"
get_answer
user_account=$answer
line1="Is $user_account the user account "
line2="you wish to delete from the system? [y/n]"
get_answer
exit_line1="Because the account, $user_account, is not "
exit_line1="the one you wish to delete, we are leaving the script..."
process_answer

user_account_record=$(cat /etc/passwd | grep -w $user_account)

if [ $? -eq 1 ]          
then
     echo
     echo "Account, $user_account, not found. "
     echo "Leaving the script..."
     echo
     exit
fi

echo
echo "I found this record:"
echo $user_account_record
echo

line1="Is this the correct User Account? [y/n]"
get_answer
exit_line1="Because the account, $user_account, is not "
exit_line2="the one you wish to delete, we are leaving the script..."
process_answer

echo
echo "Step #2 - Find process on system belonging to user account"
echo

ps -u $user_account> /dev/null  
case $? in
1)    
     echo "There are no processes for this account currently running."
     echo
;;
0)   
     
     
     echo "$user_account has the following process(es) running:"
     ps -u $user_account
     
     line1="Would you like me to kill the process(es)? [y/n]"
     get_answer
     
     answer=$(echo $answer | cut -c1)
     
     case $answer in
     y|Y)   
            echo
            echo "Killing off process(es)..."
            command_1="ps -u $user_account --no-heading"
            command_3="xargs -d \\n /usr/bin/sudo /bin/kill -9"
        
            $command_1 | gawk '{print $1}' | $command_3
        
            echo
            echo "Process(es) killed."
     ;;
     *)   
            echo
            echo "Will not kill process(es)."
     ;;
     esac
;;
esac

echo
echo "Step #3 - Find files on system belonging to user account"
echo
echo "Creating a report of all files owned by $user_account."
echo
echo "It is recommended that you backup/archive these files,"
echo "and then do one of two things:"
echo "  1) Delete the files"
echo "  2) Change the files' ownership to a current user account."
echo
echo "Please wait. This may take a while..."

report_date=$(date +%y%m%d)
report_file="$user_account"_Files_"$report_date".rpt

find / -user $user_account> $report_file 2>/dev/null

echo
echo "Report is complete."
echo "Name of report:      $report_file"
echo -n "Location of report: "; pwd

echo
echo "Step #4 - Remove user account"
echo

line1="Do you wish to remove $user_account's account from system? [y/n]"
get_answer

exit_line1="Since you do not wish to remove the user account,"
exit_line2="$user_account at this time, exiting the script..."
process_answer

userdel $user_account         
echo
echo "User account, $user_account, has been removed"
echo

exit