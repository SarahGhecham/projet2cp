const express = require('express');
const demandeclientController = require('../controllers/demandeclient.controller');

const router = express.Router();

router.post('/lancerdemande',demandeclientController.lancerdemande);

module.exports = router;