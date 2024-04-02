
'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.createTable('jours', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      Jour: {
        type: Sequelize.DATE
      },
      HeureDebut: {
        type: Sequelize.TIME ,
        allowNull: true,

      },
      HeureFin: {
        type: Sequelize.TIME,
        allowNull: true,

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
    await queryInterface.dropTable('jours');
  }
};
