const Client=require('pg').Pool
require("dotenv").config();

console.log('DB Config:',process.env.DB_HOST,process.env.DB_USERNAME)

const client=new Client({
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  user: process.env.DB_USERNAME,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT,
})
client.connect()
  .then(() => console.log("✅ Connected to Postgres"))
  .catch(err => console.error("❌ DB connection error:", err));
module.exports=client;
