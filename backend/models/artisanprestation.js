'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class ArtisanPrestation extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
    }
  }
  ArtisanPrestation.init({
    ArtisanId: DataTypes.INTEGER,
    PrestationId: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'ArtisanPrestation',
  });
  return ArtisanPrestation;
};