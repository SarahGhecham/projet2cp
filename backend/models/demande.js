'use strict';
const {
  Model
} = require('sequelize');
const client = require('./client');
module.exports = (sequelize, DataTypes) => {
  class Demande extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      Demande.belongsToMany(models.Client,{through: 'demandeclient'});
      
    }
  }
  Demande.init({
    nom: DataTypes.STRING,
  }, {
    sequelize,
    modelName: 'Demande',
  });
  return Demande;
};