const express = require('express');
const artisanJourController = require('../controllers/artisanjour.controller');

const router = express.Router();

router.post('/addJourToArtisan/:artisanId/:jourId', artisanJourController.addJourToArtisan);

module.exports = router;
