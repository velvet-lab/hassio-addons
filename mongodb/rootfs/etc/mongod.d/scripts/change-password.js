const adminDb = db.getSiblingDB("admin");

const user = process.env.ADMIN_USER;
const pwd = process.env.ADMIN_PASSWORD;

try {
  const adminUser = adminDb.getUser(user);
  if (adminUser) {    
    console.log("Admin user exists. Changing password...");
    adminDb.changeUserPassword(user, pwd);
  }
} catch (e) {
  throw "Error creating admin user. (Reason: " + e + ")";
}
