#!/bin/sh

IP_ADDRESS=$1
KNOWN_HOSTS_FILE="/home/`whoami`/.ssh/known_hosts"

mkdir -p "`dirname \"$KNOWN_HOSTS_FILE\"`"
touch "$KNOWN_HOSTS_FILE"
chmod 600 "$KNOWN_HOSTS_FILE"

MAX_RETRIES=10
RETRY_DELAY=5
ATTEMPT=0

echo "Adding server ($IP_ADDRESS) to known_hosts..."
while [ $ATTEMPT -lt $MAX_RETRIES ]; do
    ssh-keyscan -H "$IP_ADDRESS" >> "$KNOWN_HOSTS_FILE" 2> /tmp/ssh-keyscan-error.log

    if [ $? -eq 0 ]; then
        echo "Successfully added server ($IP_ADDRESS) to known_hosts"
        cat "$KNOWN_HOSTS_FILE"
        exit 0
    fi

    ATTEMPT=$((ATTEMPT + 1))
    echo "Attempt $ATTEMPT failed. Retrying in $RETRY_DELAY seconds..."
    sleep $RETRY_DELAY
done

echo "Error: Failed to add server ($IP_ADDRESS) to known_hosts after $MAX_RETRIES attempts"
cat /tmp/ssh-keyscan-error.log
rm /tmp/ssh-keyscan-error.log
exit 1