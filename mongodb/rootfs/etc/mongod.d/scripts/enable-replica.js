
const status = rs.status();
if (status.ok === 0) {
  printjson(rs.initiate());
} else {
  print("Replica set already initialized");
}
  
