import User from './userModel.js';
import Product from './productModel.js';
import Order from './orderModel.js';

User.hasMany(Order, { foreignKey: 'userId', onDelete: 'CASCADE' });
Order.belongsTo(User, { foreignKey: 'userId' });

export { User, Product, Order };
