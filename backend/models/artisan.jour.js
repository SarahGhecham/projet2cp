const { Model, DataTypes } = require('sequelize');
const sequelize = require('../config/sequelize');

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

module.exports = ArtisanJour;
