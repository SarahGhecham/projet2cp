'use strict';
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.createTable('Artisan_Jours', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      artisanId: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'artisans', // Make sure this matches the actual table name of your Artisan model
          key: 'id'
        },
        onUpdate: 'CASCADE',
        onDelete: 'CASCADE'
      },
      jourId: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'jours', // Make sure this matches the actual table name of your Jour model
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
  down: async (queryInterface, Sequelize) => {
    await queryInterface.dropTable('Artisan_Jours');
  }
};

