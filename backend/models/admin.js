'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Admin extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
    }
  }
  Admin.init({
    NomAdmin: DataTypes.STRING,
    PrenomAdmin: DataTypes.STRING,
    EmailAdmin: DataTypes.STRING,
    MotdepasseAdmin: DataTypes.STRING,
    //ActifAdmin: DataTypes.BOOLEAN
  }, {
    sequelize,
    modelName: 'Admin',
  });
  return Admin;
};