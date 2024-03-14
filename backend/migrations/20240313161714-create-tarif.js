'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('Tarifs', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      TarifJourMin: {
        type: Sequelize.DECIMAL
      },
      TarifJourMax: {
        type: Sequelize.DECIMAL
      },
      PourcentageNuit: {
        type: Sequelize.INTEGER
      },
      PourcentageJourFéié: {
        type: Sequelize.INTEGER
      },
      PourcentageWeeken: {
        type: Sequelize.INTEGER
      },
      Unité: {
        type: Sequelize.STRING
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
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('Tarifs');
  }
};