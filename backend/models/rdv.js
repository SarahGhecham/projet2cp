'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class RDV extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      RDV.belongsTo(models.Demande, { foreignKey: 'DemandeId'});
      RDV.hasOne(models.Evaluation, { foreignKey: 'RDVId' });


    }
  }
  RDV.init({
    DateDebut: DataTypes.DATE,
    DateFin: DataTypes.DATE,
    HeureDebut: DataTypes.TIME,
    HeureFin: DataTypes.TIME,
    annule:DataTypes.BOOLEAN,
    DemandeId:DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'RDV',
  });
  return RDV;
};