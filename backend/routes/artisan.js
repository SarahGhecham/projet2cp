const express = require('express');
const artisanController = require('../controllers/artisan.controller');
const { auth } = require('../middleware/check-auth');

const router = express.Router();
router.patch('/:id', artisanController.updateartisan);
router.post('/accepterRDV',auth(),artisanController.accepterRDV);
router.post('/annulerRDV',auth(),artisanController.annulerRDV);

module.exports = router;