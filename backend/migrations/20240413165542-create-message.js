'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    await queryInterface.createTable('Messages', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      senderId: {
        type: Sequelize.INTEGER
      },
      senderType: {
        type: Sequelize.ENUM('client', 'artisan')
      },
      receiverId: {
        type: Sequelize.INTEGER
      },
      receiverType: {
        type: Sequelize.ENUM('client', 'artisan')
      },
      content: {
        type: Sequelize.TEXT
      },
      sentAt: {
        type: Sequelize.DATE,
        defaultValue: Sequelize.NOW
      },
      conversationId: { // Add the conversationId field
        type: Sequelize.INTEGER,
        allowNull: false, // Ensure the conversationId is required
        references: {
          model: 'Conversations',
          key: 'id'
        },
        onUpdate: 'CASCADE',
        onDelete: 'CASCADE'
      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE
      }
    });
  },

  async down (queryInterface, Sequelize) {
    await queryInterface.dropTable('messages');

  }
};
