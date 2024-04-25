'use strict';
const { Model } = require('sequelize');

module.exports = (sequelize, DataTypes) => {
  class Conversation extends Model {
    static associate(models) {
      Conversation.hasMany(models.Message, { foreignKey: 'conversationId' });
      Conversation.belongsTo(models.Client, { foreignKey: 'clientId' });
      Conversation.belongsTo(models.Artisan, { foreignKey: 'artisanId' });
    }
  }
  Conversation.init({
    clientId: DataTypes.INTEGER,
    artisanId: DataTypes.INTEGER ,
    status: DataTypes.ENUM('open', 'closed')
  }, {
    sequelize,
    modelName: 'Conversation',
  });
  return Conversation;
};
