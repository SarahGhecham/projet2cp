'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('Prestations', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      NomPrestation: {
        type: Sequelize.STRING
      },
      Matériel: {
        type: Sequelize.TEXT
      },
      DuréeMax: {
        type: Sequelize.STRING
      },
      DuréeMin: {
        type: Sequelize.STRING
      },
      TarifId: {
        type: Sequelize.INTEGER
      },
      DomaineId: {
        type: Sequelize.INTEGER
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
    await queryInterface.dropTable('Prestations');
  }
};