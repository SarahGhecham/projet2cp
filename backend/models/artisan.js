'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Artisan extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      Artisan.belongsToMany(models.Prestation, { through: 'ArtisanPrestations' });
      Artisan.belongsToMany(models.Demande, { through: 'ArtisanDemandes' });

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
    Disponibilite: {
        type: DataTypes.BOOLEAN,
        defaultValue: true // Default value for disponibilite
      },
    Points: DataTypes.INTEGER,
    Service_account: DataTypes.INTEGER ,
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