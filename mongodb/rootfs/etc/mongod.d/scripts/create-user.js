const adminDb = db.getSiblingDB("admin");

const user = process.env.ADMIN_USER;
const pwd = process.env.ADMIN_PASSWORD;

try {
  const adminUser = adminDb.getUser(user);
  if (!adminUser) {
    console.log("Creating admin user...");
    adminDb.createUser({
      user,
      pwd,
      roles: [
        { role: "userAdminAnyDatabase", db: "admin" },
        { role: "readWriteAnyDatabase", db: "admin" },
      ],
    });
  }
} catch (e) {
  throw "Error creating admin user. (Reason: " + e + ")";
}
