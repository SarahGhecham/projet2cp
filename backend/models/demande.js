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
      Demande.belongsTo(models.Client, { foreignKey: 'Id' });  
      Demande.belongsToMany(models.Artisan, { through: 'ArtisanDemandes' });
      Demande.belongsTo(models.Prestation, { foreignKey: 'id' });

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