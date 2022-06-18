#!/bin/sh
rm -rf /etc/xray/config.json
cat << EOF > /etc/xray/config.json
{
  "inbounds": [
    {
      "port": 443,
      "protocol": "vless",
      "settings": {
        "decryption": "none",
        "clients": [
          {
            "id": "3680c68e-4a47-4832-ba53-bfd37fd46f80"
          }
        ]
      },
      "streamSettings": {
        "network": "ws"
      },
      "sniffing": {
                "enabled": true,
                "destOverride": [
                     "http",
                     "tls"
                ]
            }
},
    {
      "port": 443,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "3680c68e-4a47-4832-ba53-bfd37fd46f80"
          }
        ] 
      },
      "streamSettings": {
        "network": "ws"
      },
      "sniffing": {
                "enabled": true,
                "destOverride": [
                     "http",
                     "tls"
                ]
            }
},
    {
      "port": 443,
      "protocol": "trojan",
      "settings": {
        "clients": [
          {
            "password": "3680c68e-4a47-4832-ba53-bfd37fd46f80"
          }
        ]
      },
      "streamSettings": {
        "network": "ws"
      },
      "sniffing": {
                "enabled": true,
                "destOverride": [
                     "http",
                     "tls"
                ]
            }
    }
  ],
  "routing": {
        "domainStrategy": "IPIfNonMatch",
        "domainMatcher": "mph",
        "rules": [
           {
              "type": "field",
              "protocol": [
                 "bittorrent"
              ],
              "domains": [
                  "geosite:cn",
                  "geosite:category-ads-all"
              ],
              "outboundTag": "blocked"
           }
        ]
    },
    "outbounds": [
        {
            "protocol": "freedom",
            "settings": {
               "domainStrategy": "UseIPv4",
               "userLevel": 0
            }
        },
        {
            "protocol": "blackhole",
            "tag": "blocked"
        }
    ],
    "dns": {
        "servers": [
            {
                "address": "https+local://dns.google/dns-query",
                "address": "https+local://cloudflare-dns.com/dns-query",
                "skipFallback": true
            }
        ],
        "queryStrategy": "UseIPv4",
        "disableCache": true,
        "disableFallbackIfMatch": true
    }
}
EOF
xray -c /etc/xray/config.json
