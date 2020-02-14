#!/usr/bin/env bash
echo "Trying to fix $1"
cp $1 $1.bak
URL=$(egrep -o https:.*eks\.amazonaws\.com $1)
TARGET=$(echo $URL | sed 's/\./\\\./g')
REPLACEMENT=$(echo $URL | tr '[:upper:]' '[:lower:]')
echo "$TARGET -> $REPLACEMENT"
sed -i .bak "s|$TARGET|$REPLACEMENT|g" $1

TARGET=$(egrep -o "arn:aws:eks:.*:cluster/" $1 | head -n 1)
REPLACEMENT=''
echo "$TARGET -> $REPLACEMENT"
sed -i .bak2 "s|$TARGET|$REPLACEMENT|g" $1
