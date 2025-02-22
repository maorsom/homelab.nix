db = db.getSiblingDB("admin");
db.createUser({
  user: "admin",
  pwd: "12345r",
  roles: [{ role: "root", db: "admin" }]
});
