const express = require('express');
const artisanController = require('../controllers/artisan.controller');
const { auth } = require('../middleware/check-auth');

const router = express.Router();
router.patch('/:id', artisanController.updateartisan);
router.post('/accepterRDV',auth(),artisanController.accepterRDV);
router.post('/annulerRDV',auth(),artisanController.annulerRDV);
router.get('/getdemandes',auth(),artisanController.HistoriqueInterventions);
router.post('/test',artisanController.associerDemandeArtisan);
router.get('/AfficherEvaluations',auth(),artisanController.AfficherEvaluations);

module.exports = router;