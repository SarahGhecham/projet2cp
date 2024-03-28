'use strict';
const {
  Model
} = require('sequelize');

const sequelize = require('../config/sequelize');



module.exports = (sequelize, DataTypes) => {
  class Artisan extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      this.belongsToMany(models.Jour, {
        through: models['artisan.jour'],
        foreignKey: 'artisanId'
      });
    }
  }
  Artisan.init({
    NomArtisan: DataTypes.STRING,
    PrenomArtisan: DataTypes.STRING,
    MotdepasseArtisan: DataTypes.STRING,
    EmailArtisan: DataTypes.STRING,
    AdresseArtisan: DataTypes.STRING,
    NumeroTelArtisan: DataTypes.STRING,
    ActifArtisan: {
      type: DataTypes.BOOLEAN,
      defaultValue: true 
    },
    disponibilite: {
      type: DataTypes.BOOLEAN,
      defaultValue: true // Default value for disponibilite
    },
    photo: {
      type: DataTypes.STRING,
      allowNull: true
    }
  }, {
    sequelize,
    modelName: 'Artisan',
  });
  return Artisan;
};