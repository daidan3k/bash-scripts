#!/bin/sh

USER=$1
PASS=$2

useradd $USER
usermod --password $(echo $PASS | openssl passwd -1 -stdin) $USER
