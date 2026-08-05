import { DataTypes } from "sequelize";
import { sequelize } from "../config/db.js";

const Order = sequelize.define("Order", {
  userId: { type: DataTypes.INTEGER, allowNull: false },
  items: { type: DataTypes.JSON, allowNull: false },
  amount: { type: DataTypes.DECIMAL(10,2), allowNull: false },
  address: { type: DataTypes.JSON, allowNull: false },
  status: { type: DataTypes.STRING, allowNull: false, defaultValue: "Order Placed" },
  paymentMethod: { type: DataTypes.STRING, allowNull: false },
  payment: { type: DataTypes.BOOLEAN, allowNull: false, defaultValue: false },
  date: { type: DataTypes.BIGINT, allowNull: false }
}, {
  timestamps: false
});

Order.prototype.toJSON = function () {
  const values = { ...this.get() };
  values._id = values.id;
  return values;
};

export default Order;
