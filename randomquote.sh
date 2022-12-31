#!/bin/bash

# Get random quotes

random_quote=$(curl -s https://api.quotable.io/random?tags=love)
quote=$(echo $random_quote | jq --raw-output '.content')
author=$(echo $random_quote | jq --raw-output '.author')

echo $quote
echo $author
