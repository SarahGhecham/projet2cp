'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Tarif extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      Tarif.hasOne(models.Prestation, { foreignKey: 'TarifId' });

    }
  }
  Tarif.init({
    TarifJourMin: DataTypes.DECIMAL,
    TarifJourMax: DataTypes.DECIMAL,
    PourcentageNuit: DataTypes.INTEGER,
    PourcentageJourFérié: DataTypes.INTEGER,
    PourcentageWeekend: DataTypes.INTEGER,
    Unité: DataTypes.STRING
  }, {
    sequelize,
    modelName: 'Tarif',
  });
  return Tarif;
};