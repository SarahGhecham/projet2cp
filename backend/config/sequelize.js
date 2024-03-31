// sequelize.js

const { Sequelize } = require('sequelize');

const sequelize = new Sequelize('datab', 'root', 'root', {
  host: 'localhost',
  dialect: 'mysql',
  // Other configuration options
});

module.exports = sequelize;
