const express = require('express');
const artisanJourController = require('../controllers/artisanjour.controller');

const router = express.Router();

router.post('/addJourToArtisan/:artisanId', artisanJourController.addJourToArtisan);
router.patch('/modifyJour/:jourId', artisanJourController.modifyJour);
router.delete('/deleteJourFromArtisan/:artisanId/:jourId', artisanJourController.deleteJourFromArtisan);
router.get('/:artisanId',artisanJourController.displayplanningofArtisan);

module.exports = router;
