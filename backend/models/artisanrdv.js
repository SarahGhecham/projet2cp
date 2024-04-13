// artisanRDV.js
'use strict';
const { Model } = require('sequelize');

module.exports = (sequelize, DataTypes) => {
  class ArtisanRDV extends Model {
    static associate(models) {
      // Define associations here
    }
  }
  ArtisanRDV.init({
    artisanId: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },
    rdvId: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },
  }, {
    sequelize,
    modelName: 'artisanrdv',
  });
  return ArtisanRDV;
};
