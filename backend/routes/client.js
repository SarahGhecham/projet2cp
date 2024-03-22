const express = require('express');
const clientController = require('../controllers/client.controller');

const router = express.Router();
router.post('/sign-up',clientController.signUp);
router.patch('/:id',clientController.updateclient);
router.post('/lancerdemande/:demandeId/:clientId',clientController.lancerdemande);

module.exports = router;