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
      Artisan.belongsToMany(models.Prestation, { through: 'ArtisanPrestations' });
      Artisan.belongsToMany(models.Demande, { through: 'ArtisanDemandes' });
      Artisan.belongsTo(models.Domaine, { foreignKey: 'DomaineId'});

    }
  }
  Artisan.init({
    NomArtisan: DataTypes.STRING,
    PrenomArtisan: DataTypes.STRING,
    MotdepasseArtisan: DataTypes.STRING,
    EmailArtisan: DataTypes.STRING,
    AdresseArtisan: DataTypes.STRING,
    NumeroTelArtisan: DataTypes.STRING,
    DomaineId: DataTypes.INTEGER,
    ActifArtisan: {
      type: DataTypes.BOOLEAN,
      defaultValue: true 
    },
    photo: {
      type: DataTypes.STRING,
      allowNull: true
    },
    Disponibilite: {
        type: DataTypes.BOOLEAN,
        defaultValue: true // Default value for disponibilite
      },
    Note: DataTypes.DECIMAL,
    Service_account: DataTypes.INTEGER ,
    RayonKm: DataTypes.DECIMAL
  }, {
    sequelize,
    modelName: 'Artisan',
  });
  return Artisan;
};