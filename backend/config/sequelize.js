// sequelize.js

const { Sequelize } = require('sequelize');

const sequelize = new Sequelize('', 'root', 'root', {
  host: 'localhost',
  dialect: 'mysql',
  // Other configuration options
});

module.exports = sequelize;
