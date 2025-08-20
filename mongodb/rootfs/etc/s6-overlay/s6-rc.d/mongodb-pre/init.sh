#!/command/with-contenv bashio

bashio::log.info "Create config file"

cat <<EOF > /etc/mongod.conf
# --> modified
# mongod.conf

# for documentation of all options, see:
#   http://docs.mongodb.org/manual/reference/configuration-options/

# Where and how to store data.
storage:
  dbPath: ${DATA_ROOT}
  directoryPerDB: true

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

EOF

cat <<EOF > /tmp/create.js
const adminDb = db.getSiblingDB("admin");

try {    
    const adminUser = adminDb.getUser("${ADMIN_USER}");
    if (!adminUser) {
        console.log("Creating admin user...");
        adminDb
            .createUser({
                user: "${ADMIN_USER}",
                pwd: "${ADMIN_PASSWORD}",
                roles: [
                    { role: "userAdminAnyDatabase", db: "admin" },
                    { role: "readWriteAnyDatabase", db: "admin" }
                ]
            });
    } else {
        console.log("Admin user already exists. Changing password...");
        adminDb.changeUserPassword("${ADMIN_USER}", "${ADMIN_PASSWORD}");
    }
} catch (e) {
    throw "Error creating admin user";
}
EOF
