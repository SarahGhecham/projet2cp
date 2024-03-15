'use strict';
const {
  Model
} = require('sequelize');

module.exports = (sequelize, DataTypes) => {
  class Jour extends Model {
    static associate(models) {
      // Define associations here if needed
      Jour.belongsToMany(models.Artisan, { through: 'ArtisanJour' });

    }
  }

  Jour.init({
   
    Jour: DataTypes.DATE,
    HeureDebut: DataTypes.TIME,
    HeureFin: DataTypes.TIME
  }, {
    sequelize,
    modelName: 'Jour',
  
  });

  return Jour;
};
