#!/bin/bash

set -euo pipefail

cd tmp
cat /opt/az/lib/python3.8/site-packages/certifi/cacert.pem > cacert.pem

cp /mnt/c/Users/takekazu/Desktop/FiddlerRoot.cer .
openssl x509 -inform der -outform pem -in FiddlerRoot.cer -out FiddlerRoot.crt
cat FiddlerRoot.crt >> cacert.pem

