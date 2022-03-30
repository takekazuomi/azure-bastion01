---
title: README
---

az cliなどのhttp trafficをfidderでキャプチャーする方法のメモ

Windows Host側で起動したfiddler classicを使って、docker 内で実行したaz cliをキャプチャーする方法。

1. fiddler classicのroot certificatesをDesktopにエクスポート
2. fiddler classicのroot certificatesをderからpemに変換
3. az cliのcacert.pem をコピーして、fiddler classicのroot certificatesを追加
4. 環境変数、REQUESTS_CA_BUNDLE に追加後のcacert.pemのパスをセット
5. pythonのproxyをホストで動いているfidder に向けるため。環境変数、http[s]_proxyを、http://host.docker.internal:8888/ に設定

## fiddler docker and wsl2(ubuntu)

```sh
#!/bin/bash

set -euo pipefail

cd tmp
cat /opt/az/lib/python3.8/site-packages/certifi/cacert.pem > cacert.pem

cp /mnt/c/Users/takekazu/Desktop/FiddlerRoot.cer .
openssl x509 -inform der -outform pem -in FiddlerRoot.cer -out FiddlerRoot.crt
cat FiddlerRoot.crt >> cacert.pem
```

