const express = require('express');
const clientController = require('../controllers/client.controller');
const { auth } = require('../middleware/check-auth');
const CheckAuthMiddleWare = require('../middleware/check-auth');

const router = express.Router();
router.post('/sign-up',clientController.signUp);
router.post('/creerEvaluation',clientController.creerEvaluation);
router.patch('/:id',clientController.updateclient);
router.post('/lancerdemande',auth(),clientController.lancerdemande);
router.post('/creerRDV',auth(),clientController.creerRDV);
router.post('/confirmerRDV',auth(),clientController.confirmerRDV);
router.post('/annulerRDV',auth(),clientController.annulerRDV);

module.exports = router;