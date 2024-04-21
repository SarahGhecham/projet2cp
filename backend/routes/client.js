const express = require('express');
const clientController = require('../controllers/client.controller');
const { auth } = require('../middleware/check-auth');
const CheckAuthMiddleWare = require('../middleware/check-auth');
const imageUploader = require("../helpers/image_uploader");

const router = express.Router();
router.post('/sign-up',clientController.signUp);
router.post('/creerEvaluation',auth(),clientController.creerEvaluation);
router.patch('/updateClient/:id',clientController.updateClient);
router.post('/updateClientImage/:id',imageUploader.upload.single('photo'), clientController.updateClientImage);

router.post('/lancerdemande',auth(),clientController.lancerdemande);
router.post('/creerRDV',auth(),clientController.creerRDV);
router.post('/confirmerRDV',auth(),clientController.confirmerRDV);
router.post('/annulerRDV',auth(),clientController.annulerRDV);
router.get('/AffcherArtisan',auth(),clientController.AfficherArtisan);
router.get('/Affichermonprofil/:id',clientController.AfficherProfil)
router.get('/test',clientController.test);
router.get('/AfficherActiviteTerminee',auth(),clientController.Activiteterminee);
router.get('/AfficherActiviteEncours',auth(),clientController.ActiviteEncours);
router.get('/AfficherPrestations/:id',clientController.AfficherPrestations);
router.get('/DetailsDemandeConfirmee',auth(),clientController.DetailsDemandeConfirmee);
router.get('/DetailsRDVTermine',auth(),clientController.DetailsRDVTermine);

module.exports = router;