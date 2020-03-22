#!/bin/bash
set -e

# replace uid with the uid the container is running under
sed s/1000/`id -u`/g /etc/passwd > /tmp/passwd
cat /tmp/passwd > /etc/passwd
echo -e "thispasswordneedstobechanged\n$SFTP_PASSWORD\n$SFTP_PASSWORD" | passwd

mkdir -p /home/$SFTP_USER/.ssh
echo -e $SFTP_PUBLIC_KEY > /home/$SFTP_USER/.ssh/authorized_keys
chmod 600 /home/$SFTP_USER/.ssh
chmod 700 /home/$SFTP_USER/.ssh/authorized_keys

# Set Host Keys
if [ -n "$SSH_HOST_ED25519_KEY" ]; then
    echo -e $SSH_HOST_ED25519_KEY > /tmp/ssh_host_ed25519_key
    chmod 600 /tmp/ssh_host_ed25519_key
else
echo "SSH_HOST_ED25519_KEY Environment variable not defined!"
fi

if [ -n "$SSH_HOST_RSA_KEY" ]; then
    echo -e $SSH_HOST_RSA_KEY > /tmp/ssh_host_rsa_key
    chmod 600 /tmp/ssh_host_rsa_key
else
echo "SSH_HOST_RSA_KEY Environment variable not defined!"
fi

exec "$@"
