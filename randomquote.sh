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
# banking needs in India. Instead of opting for a VPN, I created this scri

# Get random quotes

random_quote=$(curl -s https://api.quotable.io/random?tags=love)
quote=$(echo $random_quote | jq --raw-output '.content')
author=$(echo $random_quote | jq --raw-output '.author')

echo $quote
echo $author
