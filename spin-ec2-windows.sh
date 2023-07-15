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

get_random_quote() {
    random_quote=$(curl -s https://api.quotable.io/random?tags=love)
    quote=$(echo $random_quote | jq --raw-output '.content')
    author=$(echo $random_quote | jq --raw-output '.author')

    echo "💙" $quote "-" $author
    sleep 1
}

region="ap-south-1" #mumbai
pem_location="/mnt/c/aws/"
image_id="ami-0de07eb85c12b8dbb"
instance_type="t2.medium"
key_name="win11-mum"
count=1
security_group="sg-43ec5f28"
name="Your_Name"
windows_username="Administrator"

instance_id=$(aws ec2 run-instances --image-id $image_id --count $count --instance-type $instance_type \
--key-name $key_name --security-group-ids $security_group --region $region | jq -r '.Instances[0].InstanceId')

echo "The instance ID is $instance_id."
echo $instance_id > ~/.instance_id

public_dns_name=$(aws ec2 describe-instances --region $region --instance-ids ${instance_id} \
--query 'Reservations[].Instances[].PublicDnsName' --output text)

echo "The public DNS name is $public_dns_name."
echo "Waiting for a few moments..."
echo "The password is getting generated. Have patience. It is not me, it is AWS :)"
echo "Meanwhile, here are some quotes about 💙💙💙"

password_status=false
while ! $password_status
do
    get_password=$(aws ec2 get-password-data --region $region --instance-id $instance_id \
                    --priv-launch-key $pem_location/$key_name.pem | jq -r '.PasswordData')
    get_random_quote
    if [[ -n $get_password ]]
    then
        echo "********************"
        echo "✅ Yay! The password has been generated successfully."
        echo "********************"
        password_status=true
    else
        password_status=false
    fi        
done

echo "Hey $name 💙! Please open the RDP client and use the below credentials to login."
echo "********************"
echo -e "✅ The user name is \t\t $windows_username"
echo -e "✅ The password is \t\t $get_password"
echo -e "✅ The public DNS name is \t $public_dns_name"
echo "********************"
echo "Once the purpose is done, please execute ./terminate_ec2.sh, else we will get a bill :)"
echo "🙏 Thank you :)"
echo "********************"
