
'use strict';
const { Model } = require('sequelize');

module.exports = (sequelize, DataTypes) => {
  class Message extends Model {
    static associate(models) {
      Message.belongsTo(models.Conversation, { foreignKey: 'conversationId' });
    }
  }
  Message.init({
    senderId: DataTypes.INTEGER,
    senderType: DataTypes.ENUM('client', 'artisan'),
    receiverId: DataTypes.INTEGER,
    receiverType: DataTypes.ENUM('client', 'artisan'),
    content: DataTypes.TEXT,
    sentAt: {
      type: DataTypes.DATE,
      defaultValue: DataTypes.NOW
    },
    conversationId: DataTypes.INTEGER // Added conversationId field
  }, {
    sequelize,
    modelName: 'Message',
    tableName: 'messages',
  });
  return Message;
};
