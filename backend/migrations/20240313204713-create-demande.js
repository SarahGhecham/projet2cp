'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('Demandes', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      PrestationId: {
        allowNull: false, // La colonne PrestationId ne peut pas être nulle
        type: Sequelize.INTEGER,
        references: { // Définition de la clé étrangère
          model: 'Prestations', // Nom de la table référencée
          key: 'id' // Nom de la colonne référencée dans la table Prestations
        }
      },
      nom: {
        type: Sequelize.STRING
      },
      Urgente: {
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
    await queryInterface.dropTable('Demandes');
  }
};