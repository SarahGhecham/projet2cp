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
    NumeroTelClient: DataTypes.STRING,
    ActifClient: {
      type: DataTypes.BOOLEAN,
      defaultValue: true 
    },
    disponibilite: {
      type: DataTypes.BOOLEAN,
      defaultValue: true // Default value for disponibilite
    },
    photo: {
      type: DataTypes.BLOB,
      allowNull: true
    }
  }, {
    sequelize,
    modelName: 'Client',
  });
  return Client;
};