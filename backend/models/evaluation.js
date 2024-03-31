'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Evaluation extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      Evaluation.belongsTo(models.RDV, { foreignKey: 'RDVId'});
    }
  }
  Evaluation.init({
    Note: DataTypes.DECIMAL,
    Commentaire: DataTypes.STRING,
    RDVId: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'Evaluation',
  });
  return Evaluation;
};