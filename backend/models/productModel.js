import { DataTypes } from "sequelize";
import { sequelize } from "../config/db.js";

const Product = sequelize.define("Product", {
  name: { type: DataTypes.STRING, allowNull: false },
  description: { type: DataTypes.TEXT, allowNull: false },
  price: { type: DataTypes.DECIMAL(10,2), allowNull: false },
  image: { type: DataTypes.JSON, allowNull: false },
  category: { type: DataTypes.STRING, allowNull: false },
  subCategory: { type: DataTypes.STRING, allowNull: false },
  sizes: { type: DataTypes.JSON, allowNull: false },
  bestseller: { type: DataTypes.BOOLEAN, defaultValue: false },
  date: { type: DataTypes.BIGINT, allowNull: false }
}, {
  timestamps: false
});

Product.prototype.toJSON = function () {
  const values = { ...this.get() };
  values._id = values.id;
  return values;
};

export default Product;
