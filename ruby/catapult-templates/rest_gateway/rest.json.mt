{
  "network": {
    "name": "publicTest",
    "description": "catapult development network",
    "propertiesFilePath": "{{api_node_config_path}}/config-network.properties"
  },

  "port": 3000,
  "crossDomain": {
    "allowedHosts": ["*"],
    "allowedMethods": ["GET", "POST", "PUT", "OPTIONS"]
  },
  "extensions": [
    "accountLink",
    "aggregate",
    "lockHash",
    "lockSecret",
    "mosaic",
    "metadata",
    "multisig",
    "namespace",
    "receipts",
    "restrictions",
    "transfer"
  ],
  "db": {
    "url": "mongodb://{{db_host}}:27017/",
    "name": "catapult",
    "pageSizeMin": 10,
    "pageSizeMax": 100,
    "maxConnectionAttempts": 7,
    "baseRetryDelay": 750
  },

  "apiNode": {
    "host": "{{api_node_host}}",
    "port": 7900,
    "tlsClientCertificatePath": "{{api_node_config_path}}/cert/node.crt.pem",
    "tlsClientKeyPath": "{{api_node_config_path}}/cert/node.key.pem",
    "tlsCaCertificatePath": "{{api_node_config_path}}/cert/ca.cert.pem",
    "timeout": 1000
  },

  "websocket": {
    "mq": {
      "host": "{{api_node_broker_host}}",
      "port": 7902,
      "monitorInterval": 500,
      "connectTimeout": 10000,
      "monitorLoggingThrottle": 60000
    },
    "allowOptionalAddress": true
  },

  "logging": {
    "console": {
      "formats": ["colorize", "simple"],

      "level": "verbose",
      "handleExceptions": true
    },
    "file": {
      "formats": ["prettyPrint"],

      "level": "verbose",
      "handleExceptions": true,

      "filename": "catapult-rest.log",
      "maxsize": 20971520,
      "maxFiles": 100
    }
  },

  "numBlocksTransactionFeeStats": 300
}
