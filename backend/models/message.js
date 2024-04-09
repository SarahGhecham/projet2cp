
'use strict';
const { Model } = require('sequelize');

module.exports = (sequelize, DataTypes) => {
  class Message extends Model {
    static associate(models) {
    }
  }
  Message.init({
    sender_id: DataTypes.INTEGER,
    sender_type: DataTypes.ENUM('client', 'artisan'),
    receiver_id: DataTypes.INTEGER,
    receiver_type: DataTypes.ENUM('client', 'artisan'),
    content: DataTypes.TEXT,
    sent_at: {
      type: DataTypes.DATE,
      defaultValue: DataTypes.NOW
    }
  }, {
    sequelize,
    modelName: 'Message',
    tableName: 'messages',
  
  });
  return Message;
};
