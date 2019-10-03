{
  "_id": "containerRuntime",
  "rules": [
    {
      "modified": "2019-10-03T07:33:25.832Z",
      "owner": "admin",
      "name": "justin1234",
      "previousName": "",
      "resources": {
        "hosts": [
          "*"
        ],
        "images": [
          "*"
        ],
        "labels": [
          "*"
        ],
        "containers": [
          "*"
        ]
      },
      "advancedProtection": true,
      "processes": {
        "effect": "alert",
        "blacklist": [],
        "whitelist": [],
        "checkCryptoMiners": true,
        "checkLateralMovement": true,
        "checkParentChild": false
      },
      "syscalls": {
        "effect": "alert",
        "staticProfiles": false,
        "whitelist": [],
        "blacklist": []
      },
      "network": {
        "effect": "alert",
        "blacklistIPs": [],
        "blacklistListeningPorts": [],
        "whitelistListeningPorts": [],
        "blacklistOutboundPorts": [],
        "whitelistOutboundPorts": [],
        "whitelistIPs": [],
        "detectPortScan": true
      },
      "dns": {
        "effect": "disable",
        "whitelist": [],
        "blacklist": []
      },
      "filesystem": {
        "effect": "alert",
        "blacklist": [],
        "whitelist": [],
        "checkNewFiles": true,
        "backdoorFiles": true
      },
      "kubernetes": {
        "enabled": false
      }
    },
    {
      "modified": "2019-10-02T06:31:45.293Z",
      "owner": "system",
      "name": "Default - alert on suspicious runtime behavior",
      "previousName": "",
      "resources": {
        "hosts": [
          "*"
        ],
        "images": [
          "*"
        ],
        "labels": [
          "*"
        ],
        "containers": [
          "*"
        ]
      },
      "advancedProtection": true,
      "processes": {
        "effect": "alert",
        "blacklist": [],
        "whitelist": [],
        "checkCryptoMiners": true,
        "checkLateralMovement": true,
        "checkParentChild": false
      },
      "syscalls": {
        "effect": "alert",
        "staticProfiles": false,
        "whitelist": [],
        "blacklist": []
      },
      "network": {
        "effect": "alert",
        "blacklistIPs": [],
        "blacklistListeningPorts": [],
        "whitelistListeningPorts": [],
        "blacklistOutboundPorts": [],
        "whitelistOutboundPorts": [],
        "whitelistIPs": [],
        "detectPortScan": true
      },
      "dns": {
        "effect": "disable",
        "whitelist": [],
        "blacklist": []
      },
      "filesystem": {
        "effect": "alert",
        "blacklist": [],
        "whitelist": [],
        "checkNewFiles": true,
        "backdoorFiles": true
      },
      "kubernetes": {
        "enabled": false
      }
    }
  ],
  "learningDisabled": false
}
