'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Prestation extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      Prestation.belongsTo(models.Tarif, { foreignKey: 'TarifId' });
      Prestation.belongsTo(models.Domaine, { foreignKey: 'DomaineId' });
    }
  }
  Prestation.init({
    NomPrestation: DataTypes.STRING,
    Matériel: DataTypes.TEXT,
    DuréeMax: DataTypes.STRING,
    DuréeMin: DataTypes.STRING,
    TarifId: DataTypes.INTEGER,
    DomaineId: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'Prestation',
  });
  return Prestation;
};