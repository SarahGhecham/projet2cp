'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Client extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
    }
  }
  Client.init({
    NomClient: DataTypes.STRING,
    PrenomClient: DataTypes.STRING,
    MotdepasseClient: DataTypes.STRING,
    EmailClient: DataTypes.STRING,
    AdresseClient: DataTypes.STRING,
    NumeroTelClient: DataTypes.STRING
  }, {
    sequelize,
    modelName: 'Client',
  });
  return Client;
};