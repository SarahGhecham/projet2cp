'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Domaine extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      Domaine.hasMany(models.Prestation, { foreignKey:'DomaineId' });

    }
  }
  Domaine.init({
    NomDomaine: DataTypes.STRING,
    imageDomaine: DataTypes.STRING
  }, {
    sequelize,
    modelName: 'Domaine',
  });
  return Domaine;
};