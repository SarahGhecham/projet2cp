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
      Demande.belongsTo(models.Client, { foreignKey: 'ClientId' });  
      Demande.belongsToMany(models.Artisan, { through: 'ArtisanDemandes' });
      Demande.belongsTo(models.Prestation, { foreignKey: 'PrestationId' });
      Demande.hasOne(models.RDV, { foreignKey: 'DemandeId' });


    }
  }
  Demande.init({
    Description: DataTypes.TEXT,
    PrestationId: DataTypes.INTEGER,
    ClientId: DataTypes.INTEGER,
    Urgente:DataTypes.BOOLEAN,
    Localisation:DataTypes.STRING 

  }, {
    sequelize,
    modelName: 'Demande',
  });
  return Demande;
};