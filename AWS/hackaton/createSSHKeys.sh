#!/bin/sh

ssh-keygen -N '' -q -f ~/.ssh/id_rsa_AWS_WS
ssh-add id_rsa_AWS_WS
