const express = require('express');
const artisanController = require('../controllers/artisan.controller');
const { auth } = require('../middleware/check-auth');
const clientController = require('../controllers/client.controller');

const router = express.Router();
router.get('/Affichermonprofil',auth(),artisanController.AfficherProfil)
router.patch('/updateartisan',auth(),artisanController.updateartisan);
router.post('/accepterRDV',auth(),artisanController.accepterRDV);
router.post('/annulerRDV',auth(),artisanController.annulerRDV);
//router.get('/HistoriqueInterventions',auth(),artisanController.HistoriqueInterventions);
router.post('/test',artisanController.associerDemandeArtisan);
//router.get('/AfficherEvaluations',auth(),artisanController.AfficherEvaluations);
router.get('/AfficherActiviteTerminee',auth(),artisanController.Activiteterminee);
router.get('/AfficherActiviteEncours',auth(),artisanController.ActiviteEncours);


module.exports = router;