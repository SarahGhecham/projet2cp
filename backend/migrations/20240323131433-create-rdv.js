'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('RDVs', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      DateDebut: {
        type: Sequelize.DATE
      },
      DateFin: {
        type: Sequelize.DATE
      },
      HeureDebut: {
        type: Sequelize.TIME
      },
      HeureFin: {
        type: Sequelize.TIME
      },
      annule: {
        type: Sequelize.BOOLEAN
      },
      DemandeId: {
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
    await queryInterface.dropTable('RDVs');
  }
};