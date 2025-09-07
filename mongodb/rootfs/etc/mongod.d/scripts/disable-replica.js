
const status = rs.status();
if (status.ok !== 0) {
  printjson(rs.remove());
} else {
  print("Replica set already disabled");
}
