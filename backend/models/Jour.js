'use strict';
const {
  Model
} = require('sequelize');

const sequelize = require('../config/sequelize');

module.exports = (sequelize, DataTypes) => {
  class Jour extends Model {
    static associate(models) {
        this.belongsToMany(models.Artisan, {
          through: models['artisan.jour'],
          foreignKey: 'jourId'
        });
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
