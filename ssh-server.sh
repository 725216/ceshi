#!/bin/bash

if [[ -z "$NGROK_TOKEN" ]]; then
  echo "Please set 'NGROK_TOKEN'"
  exit 2
fi

if [[ -z "$SSH_PASSWORD" ]]; then
  echo "Please set 'SSH_PASSWORD' for user: $USER"
  exit 3
fi
sudo apt-get -y install build-essential asciidoc binutils bzip2 gawk gettext git libncurses5-dev libz-dev patch python3 python2.7 unzip zlib1g-dev lib32gcc1 libc6-dev-i386 subversion flex uglifyjs git-core gcc-multilib p7zip p7zip-full msmtp libssl-dev texinfo libglib2.0-dev xmlto qemu-utils upx libelf-dev autoconf automake libtool autopoint device-tree-compiler g++-multilib antlr3 gperf wget curl swig rsync libncurses5-dev gawk libcloog-isl-dev ncftp
wget -q https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.zip
unzip ngrok-stable-linux-386.zip
chmod +x ./ngrok

echo -e "$SSH_PASSWORD\n$SSH_PASSWORD" | sudo passwd "$USER"

rm -f .ngrok.log
./ngrok authtoken "$NGROK_TOKEN"
./ngrok tcp 22 --log ".ngrok.log" &

sleep 10

HAS_ERRORS=$(grep "command failed" < .ngrok.log)

if [[ -z "$HAS_ERRORS" ]]; then
  echo ""
  echo "To connect: $(grep -o -E "tcp://(.+)" < .ngrok.log | sed "s/tcp:\/\//ssh $USER@/" | sed "s/:/ -p /")"
  echo ""
else
  echo "$HAS_ERRORS"
  exit 4
fi
