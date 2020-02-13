#!/usr/bin/env bash
echo "Trying to fix $1"
cp $1 $1.bak
URL=$(egrep -o https:.*eks\.amazonaws\.com $1)
TARGET=$(echo $URL | sed 's/\./\\\./g')
REPLACEMENT=$(echo $URL | tr '[:upper:]' '[:lower:]')
echo "$TARGET -> $REPLACEMENT"
sed -i bak "s|$TARGET|$REPLACEMENT|g" $1