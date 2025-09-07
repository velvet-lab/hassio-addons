#!/command/with-contenv bashio

bashio::log.info "Create MongoDB configuration file"

MONGO_CONFIG=$(cat << EOF
net:
  port: 27017
  bindIpAll: true
  ipv6: false
  unixDomainSocket:
    enabled: false
  tls:
    mode: disabled

processManagement:
  pidFilePath: /run/mongodb/mongod.pid
  timeZoneInfo: /usr/share/zoneinfo

operationProfiling:
  mode: off

# Where and how to store data.
storage:
  dbPath: ${DATA_ROOT}
  directoryPerDB: true 
EOF
)

if  [ "${LOGGING_ENABLED}" = true ]; then
    bashio::log.debug "Enable security in configuration"  
    LOGGING_CONFIG=$(cat << EOF
systemLog:
  verbosity: 0
  quiet: false
EOF
)
    MONGO_CONFIG="${MONGO_CONFIG}\n${LOGGING_CONFIG}"
fi

if  [ "${AUTH_ENABLED}" = true ]; then
    bashio::log.debug "Enable security in configuration"  
    SECURITY_CONFIG=$(cat << EOF
security:
  authorization: enabled
  javascriptEnabled: false
EOF
)
    MONGO_CONFIG="${MONGO_CONFIG}\n${SECURITY_CONFIG}"
fi

if  [ "${REPLICA_ENABLED}" = true ]; then
    bashio::log.debug "Enable replica set in configuration"
  
    REPL_CONFIG=$(cat << EOF
# Replication settings
replication:
  replSetName: rs01
EOF
)
    MONGO_CONFIG="${MONGO_CONFIG}\n${REPL_CONFIG}"
fi

echo -e "${MONGO_CONFIG}" > /etc/mongod.conf