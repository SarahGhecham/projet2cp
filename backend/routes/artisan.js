const express = require('express');
const artisanController = require('../controllers/artisan.controller');
const { auth } = require('../middleware/check-auth');
const clientController = require('../controllers/client.controller');
const imageUploader = require("../helpers/image_uploader");

const router = express.Router();
router.get('/Affichermonprofil/:id',artisanController.AfficherProfil)
router.patch('/updateartisan',auth(),artisanController.updateartisan);
router.post('/accepterRDV',auth(),artisanController.accepterRDV);
router.post('/annulerRDV',auth(),artisanController.annulerRDV);
//router.get('/HistoriqueInterventions',auth(),artisanController.HistoriqueInterventions);
router.post('/test',artisanController.associerDemandeArtisan);
//router.get('/AfficherEvaluations',auth(),artisanController.AfficherEvaluations);
router.get('/AfficherActiviteTerminee',auth(),artisanController.Activiteterminee);
router.get('/AfficherActiviteEncours',auth(),artisanController.ActiviteEncours);
router.get('/DetailsRDVTermine',auth(),artisanController.DetailsRDVTermine);
router.get('/DetailsDemandeConfirmee',auth(),artisanController.DetailsDemandeConfirmee);
router.get('/ConsulterDemandes',auth(),artisanController.consulterdemandes);

router.post("/updateArtisanImage/:id", imageUploader.upload.single('photo'), artisanController.updateArtisanImage);


module.exports = router;