const express = require('express');
const artisanJourController = require('../controllers/artisanjour.controller');

const router = express.Router();

router.post('/addJourToArtisan/:artisanId', artisanJourController.addJourToArtisan);
router.delete('/deleteJourFromArtisan/:artisanId/:jourId', artisanJourController.deleteJourFromArtisan);


module.exports = router;
