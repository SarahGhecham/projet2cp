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
      Client.hasMany(models.Demande, { foreignKey: 'ClientId' });
    }
  }
  Client.init({
    Username: DataTypes.STRING,
    MotdepasseClient: DataTypes.STRING,
    EmailClient: DataTypes.STRING,
    AdresseClient: DataTypes.STRING,
    NumeroTelClient: DataTypes.STRING,
    ActifClient: {
      type: DataTypes.BOOLEAN,
      defaultValue: true 
    },
    photo: {
      type: DataTypes.STRING,
      allowNull: true
    },
    Points: DataTypes.INTEGER,
    Service_account: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'Client',
  });
  return Client;
};