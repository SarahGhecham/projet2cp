const express = require('express');
const clientController = require('../controllers/client.controller');
const { auth } = require('../middleware/check-auth');
const CheckAuthMiddleWare = require('../middleware/check-auth');

const router = express.Router();
router.post('/sign-up',clientController.signUp);
router.post('/creerEvaluation',clientController.creerEvaluation);
router.patch('/updateClient',auth(),clientController.updateClient);
router.post('/lancerdemande',auth(),clientController.lancerdemande);
router.post('/creerRDV',auth(),clientController.creerRDV);
router.post('/confirmerRDV',auth(),clientController.confirmerRDV);
router.post('/annulerRDV',auth(),clientController.annulerRDV);
router.get('/AffcherArtisan/:id',clientController.AfficherArtisan);
router.get('/Affichermonprofil',auth(),clientController.AfficherProfil)
router.get('/test/:id',clientController.test);
router.get('/AfficherActiviteTerminee',auth(),clientController.Activiteterminee);
router.get('/AfficherActiviteEncours',auth(),clientController.ActiviteEncours);
router.get('/AfficherPrestations',auth(),clientController.AfficherPrestations);
module.exports = router;