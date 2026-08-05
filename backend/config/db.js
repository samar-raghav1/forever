// connectDB.js
import { Sequelize } from "sequelize";

export const sequelize = new Sequelize(
  process.env.MYSQL_DB,       // database name
  process.env.MYSQL_USER,     // username
  process.env.MYSQL_PASS,     // password
  {
    host: process.env.MYSQL_HOST,
    dialect: "mysql",
    port: 3306,
    logging: false,           // disable SQL logs
  }
);

const connectDB = async () => {
  try {
    await sequelize.authenticate();
    await sequelize.sync();
    console.log("✅ MySQL connected successfully with Sequelize");
  } catch (error) {
    console.error("❌ MySQL connection failed:", error.message);
    process.exit(1);
  }
};

export default connectDB;
