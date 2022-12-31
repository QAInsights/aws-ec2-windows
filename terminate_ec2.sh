#!/bin/bash

instance_id=$(cat ~/.instance_id 2>/dev/null) 
if [ -f ~/.instance_id ]
then
    echo "***** This script will delete the instance $instance_id. *****"
    read -p "Are you sure that you want to delete this instance, my dear 💙? y/n " answer

    case ${answer:0:1} in
        y|Y )
            terminate_status=$(aws ec2 terminate-instances --instance-ids $instance_id) 
            echo "The instance has been deleted successfully."           
        ;;
        * )
            echo "Cancelling this operation."
        ;;
    esac
else
    echo "No instance is running."
fi