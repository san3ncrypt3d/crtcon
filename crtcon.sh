#!/bin/bash
# Author: san3ncrypt3d


TARGET="$1"
DIR="$PWD/results"
DomainDir="$PWD/Domain"
if [ -z $TARGET ]; then
        echo -e "Use: ./crtcon.sh <domain-name>"
        echo -e "example: ./crtcon.sh san3ncrypt3d.com"
        exit
fi

echo -e "[+] Creating Folder to dump result $DIR"
mkdir $DIR
mkdir $DomainDir

TARGET=${TARGET// /+}

echo -e "[+] Getting Results into Dump.txt file"
curl -s https://crt.sh/?q=$TARGET > $DIR/Dump.txt
echo -e "[+] Saving Certificate IDs to $DIR/Certs.ids"
cat $DIR/Dump.txt | grep ?id= | cut -d \" -f5 | cut -d '<' -f1 | cut -d '>' -f2 >> $DIR/Certs.ids

TOTAL=`wc -l $DIR/Certs.ids`
echo -e "[+] Collected : $TOTAL #of Certs"
cat $DIR/Certs.ids| while read line
do
   echo "[+] Downloading Certificate ID: $line"
   curl -s https://crt.sh/?id=$line > $DIR/$line.txt
done

cat $DIR/* | grep -oP '(DNS)(.*?)(<BR>)' | cut -d ":" -f2 | cut -d "<" -f1 | sort -u >> $DomainDir/domains.txt

echo -e "[+] Domains saved to: $DomainDir/domains.txt"
echo -e "[+] Done"
