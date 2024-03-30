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
      // define association here
    }
  }
  ArtisanDemande.init({
    DemandeId: DataTypes.INTEGER,
    ArtisanId: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'ArtisanDemande',
  });
  return ArtisanDemande;
};