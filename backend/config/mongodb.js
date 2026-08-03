import mysql from "mysql2/promise";

const connectDB = async () => {
  try {
    const connection = await mysql.createConnection(process.env.MYSQL_URI);
    console.log("MySQL DB Connected");
    return connection;
  } catch (error) {
    console.error("Connection Failed:", error);
    process.exit(1);
  }
};

export default connectDB;
