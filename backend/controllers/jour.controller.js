// jourController.js

const models=require('../models');

function createJour(req, res) {
    const jourData = {
        Jour: req.body.Jour,
        HeureDebut: req.body.HeureDebut,
        HeureFin: req.body.HeureFin
    };

    models.Jour.create(jourData)
        .then(jour => {
            res.status(201).json({
                message: "Jour created successfully",
                jour: jour
            });
        })
        .catch(error => {
            console.error('Error creating jour:', error);
            res.status(500).json({ error: 'Failed to create jour' });
        });
}


function getAllJours(req, res) {
    models.Jour.findAll()
        .then(jours => {
            res.json(jours);
        })
        .catch(error => {
            console.error('Error fetching jours:', error);
            res.status(500).json({ error: 'Failed to fetch jours' });
        });
}

function updateJour(req, res) {
    const id = req;
    const updatedJour = {
        Jour: req.body.Jour,
        HeureDebut: req.body.HeureDebut,
        HeureFin: req.body.HeureFin
    };

    models.Jour.update(updatedJour, { where: { id } })
        .then(([updatedRows]) => {
            if (updatedRows === 1) {
                res.status(201).json({
                    message: "Jour updated successfully",
                    jour: updatedJour
                });
            } else {
                res.status(404).json({ message: "Jour not found" });
            }
        })
        .catch(error => {
            console.error('Error updating jour:', error);
            res.status(500).json({ error: 'Something went wrong' });
        });
}

function deleteJour(req, res) {
    const id = req;
    models.Jour.destroy({ where: { id } })
        .then(deletedRows => {
            if (deletedRows === 1) {
                res.json({ message: 'Jour deleted successfully' });
            } else {
                res.status(404).json({ message: 'Jour not found' });
            }
        })
        .catch(error => {
            console.error('Error deleting jour:', error);
            res.status(500).json({ error: 'Failed to delete jour' });
        });
}

module.exports = {
    createJour:createJour,
    getAllJours:getAllJours,
    
    updateJour: updateJour,
    deleteJour: deleteJour,
};
