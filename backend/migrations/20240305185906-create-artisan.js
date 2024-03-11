'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('Artisans', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      PrenomArtisan: {
        type: Sequelize.STRING
      },
      NomArtisan: {
        type: Sequelize.STRING
      },
      MotdepasseArtisan: {
        type: Sequelize.STRING
      },
      EmailArtisan: {
        type: Sequelize.STRING
      },
      AdresseArtisan: {
        type: Sequelize.STRING
      },
      NumeroTelArtisan: {
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
    await queryInterface.dropTable('Artisans');
  }
};