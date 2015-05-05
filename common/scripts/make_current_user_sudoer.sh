#! /bin/sh


if sudo grep -q "$USER ALL=NOPASSWD: ALL" /etc/sudoers; then
    echo "passwordless sudo already active"
else
    echo "setting sudo without password for $USER";
    sudo sh -c 'echo "'$USER' ALL=NOPASSWD: ALL" >> /etc/sudoers'
fi
