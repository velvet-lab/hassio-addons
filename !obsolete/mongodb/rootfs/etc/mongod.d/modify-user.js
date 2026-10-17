const credentials = globalThis.mongoAdminCredentials;
const user = typeof credentials?.user === "string" ? credentials.user.trim() : "";
const pwd = typeof credentials?.pwd === "string" ? credentials.pwd.trim() : "";

if (!user || !pwd) {
  throw new Error("Missing MongoDB admin credentials.");
}

print("Modifying MongoDB admin user...");
const adminDb = db.getSiblingDB("admin");

try {
  const adminUser = adminDb.getUser(user);
  if (!adminUser) {
    print("Creating admin user...");
    adminDb.createUser({
      user,
      pwd,
      roles: [
        { role: "userAdminAnyDatabase", db: "admin" },
        { role: "readWriteAnyDatabase", db: "admin" },
        { role: "clusterMonitor", db: "admin" },
      ],
    })
    print("Admin user created.");
  }
  else{
    print("Admin user exists. Changing password...");
    adminDb.changeUserPassword(user, pwd);
    print("Password changed.");
  }
} catch (e) {
  throw `Error creating admin user. (Reason: ${e})`;
}
