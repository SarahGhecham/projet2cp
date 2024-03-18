
'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
    class ArtisanJour extends Model {}
    ArtisanJour.init({
        artisanId: {
            type: DataTypes.INTEGER,
            allowNull: false,
            references: {
                model: 'artisan', // This should be the name of the Artisan model
                key: 'id'
            }
        },
        jourId: {
            type: DataTypes.INTEGER,
            allowNull: false,
            references: {
                model: 'Jour', // This should be the name of the Jour model
                key: 'id'
            }
        }
    }, {
        sequelize,
        modelName: 'artisan.jour',
        tableName: 'Artisan_Jours'
    });
  return ArtisanJour;
};