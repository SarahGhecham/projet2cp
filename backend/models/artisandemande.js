'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class ArtisanDemande extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
    }
  }
  ArtisanDemande.init({
    DemandeId: DataTypes.INTEGER,
    ArtisanId: DataTypes.INTEGER,
    accepte: DataTypes.BOOLEAN,
    confirme: DataTypes.BOOLEAN,
    refuse: DataTypes.BOOLEAN
  }, {
    sequelize,
    modelName: 'ArtisanDemande',
  });
  return ArtisanDemande;
};