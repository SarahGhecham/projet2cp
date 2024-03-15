const express = require('express');
const demandeclientController = require('../controllers/demandeclient.controller');

const router = express.Router();

router.post('/lancerdemande/:demandeId/:clientId',demandeclientController.lancerdemande);

module.exports = router;