#!/bin/bash

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
name="Preethi"

instance_id=$(aws ec2 run-instances --image-id $image_id --count $count --instance-type $instance_type \
--key-name $key_name --security-group-ids $security_group | jq -r '.Instances[0].InstanceId')

echo "The instance ID is $instance_id"
echo $instance_id > ~/.instance_id

public_dns_name=$(aws ec2 describe-instances --instance-ids ${instance_id} \
--query 'Reservations[].Instances[].PublicDnsName' --output text)

echo "The public DNS name is $public_dns_name"
echo "Waiting for few moments..."
echo "$(date) The password is getting generated. Have patience. It is not me, it is AWS :)"
echo "Meanwhile here are some quotes about 💙"

password_status=false
while ! $password_status
do
    get_password=$(aws ec2 get-password-data --instance-id $instance_id \
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
echo -e "✅ The user name is \t\t Administrator"
echo -e "✅ The password is \t\t $get_password"
echo -e "✅ The public DNS name is \t $public_dns_name"
echo "********************"
echo "Once the purpose is done, please execute ./terminate_ec2.sh"
echo "🙏 Thank you :)"
echo "********************"