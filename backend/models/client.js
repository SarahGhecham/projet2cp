'use strict';
const {
  Model
} = require('sequelize');
const demande = require('./demande');
module.exports = (sequelize, DataTypes) => {
  class Client extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      Client.belongsToMany(models.Demande,{through: 'demandeclient'});
    }
  }
  Client.init({
    NomClient: DataTypes.STRING,
    PrenomClient: DataTypes.STRING,
    MotdepasseClient: DataTypes.STRING,
    EmailClient: DataTypes.STRING,
    AdresseClient: DataTypes.STRING,
    NumeroTelClient: DataTypes.STRING,
    ActifClient: {
      type: DataTypes.BOOLEAN,
      defaultValue: true 
      }
  }, {
    sequelize,
    modelName: 'Client',
  });
  return Client;
};