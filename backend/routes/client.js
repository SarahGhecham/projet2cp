const express = require('express');
const clientController = require('../controllers/client.controller');
const CheckAuthMiddleWare = require('../middleware/check-auth');

const router = express.Router();
router.post('/sign-up',clientController.signUp);
router.post('/creerEvaluation',clientController.creerEvaluation);
router.patch('/:id',clientController.updateclient);
router.post('/lancerdemande/:demandeId/:clientId',clientController.lancerdemande);

module.exports = router;