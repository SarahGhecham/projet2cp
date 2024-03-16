const express = require('express');
const artisanController = require('../controllers/artisan.controller');
const CheckAuthMiddleware = require('../middleware/check-auth'); // Importer l'objet entier

const router = express.Router();
router.patch('/:id', artisanController.updateartisan);
router.post('/AjouterPrestation', CheckAuthMiddleware.CheckAuth, artisanController.AjouterPrestation); // Utilisation de CheckAuth directement

module.exports = router;
