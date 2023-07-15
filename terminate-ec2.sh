#!/bin/bash

# Copyright 2023 NaveenKumar Namachivayam.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Run `./spin-ec2-windows.sh` to spin an Windows EC2 instance on AWS - India region
# Run `./terminate-ec2.sh` to terminate the instance

# This script is gifted to my wife who needs an Windows machine to take care of her
# banking needs in India. Instead of opting for a VPN, I created this script.

instance_id=$(cat ~/.instance_id 2>/dev/null) 
region="ap-south-1"

if [ -f ~/.instance_id ]
then
    echo "***** This script will delete the instance $instance_id. *****"
    read -p "Are you sure that you want to delete this instance, my dear 💙? y/n " answer

    case ${answer:0:1} in
        y|Y )
            terminate_status=$(aws ec2 terminate-instances --region $region --instance-ids $instance_id) 
            echo "The instance has been deleted successfully."           
        ;;
        * )
            echo "Cancelling this operation."
        ;;
    esac
else
    echo "No instance is running."
fi
