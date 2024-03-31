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
  
  Jour.init(
    {
      jour: {
        type: DataTypes.ENUM('dimanche', 'lundi', 'mardi', 'mercredi', 'jeudi', 'vendredi', 'samedi'),
        allowNull: false,
        unique: true,
       
      },
      heureDebut: {
        type: DataTypes.TIME,
        allowNull: false,
      },
      heureFin: {
        type: DataTypes.TIME,
        allowNull: false,
      },
    },
    {
      sequelize,
      modelName: 'Jour',
    }
  );

  return Jour;
};
