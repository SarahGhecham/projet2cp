
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
                model: 'artisan',
            }
        },
        jourId: {
            type: DataTypes.INTEGER,
            allowNull: false,
            references: {
                model: 'Jour',
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