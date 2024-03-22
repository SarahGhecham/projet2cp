'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class demandeclient extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
    }
  }
  demandeclient.init({
    demandeId: DataTypes.INTEGER,
    clientId: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'demandeclient',
  });
  return demandeclient;
};