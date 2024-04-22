'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('ArtisanDemandes', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      DemandeId: {
        type: Sequelize.INTEGER
      },
      ArtisanId: {
        type: Sequelize.INTEGER
      },
      accepte: {
        type: Sequelize.BOOLEAN
      },
      confirme: {
        type: Sequelize.BOOLEAN
      },
      refuse: {
        type: Sequelize.BOOLEAN
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
    await queryInterface.dropTable('ArtisanDemandes');
  }
};