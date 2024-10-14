#!/bin/sh

COMENTARI=$1

git add /home/daidan/bash-scripts/
git commit -m "$COMENTARI"
git push
