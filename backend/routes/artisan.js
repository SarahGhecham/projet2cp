const express = require('express');
const artisanController = require('../controllers/artisan.controller');

const router = express.Router();
router.patch('/:id', artisanController.updateartisan);

module.exports = router;