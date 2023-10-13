#!/bin/bash

# Check that tx hash was provided as first argument
if [ -z "$1" ]; then
  echo "Error: no tx hash provided"
  echo ""
  echo -n "USAGE: "
  filepath=$0
  scriptname=$(basename "$filepath")
  echo "$scriptname <tx_hash>"
  echo "The tx_hash is the hash of the transaction on the bitcoin blockchain."
  exit 1
fi

# Save tx hash to variable 
tx_hash=$1

# Get current blockchain height by looking for the value according to the debug.log file
height=$(tail -n 20 ~/citadel/bitcoin/debug.log | grep height | head -n 1 | awk -F '=' '/height/ {print $3}')

# Run lncli command to search for tx 
output=$(docker exec -it lnd-service-1 lncli listchaintxns --start_height $height --end_height -1 | jq -c ".transactions[] | select(.tx_hash == \"$tx_hash\")")

# Print output formatted with jq
echo "$output" | jq
