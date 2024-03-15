// jour.js

const express = require('express');
const router = express.Router();
const jourController = require('../controllers/jour.controller');

// Route to create a Jour record
router.post('/', jourController.createJour);

/* Route to fetch all Jour records
router.get('/', jourController.getAllJours);

// Route to update a Jour record
router.put('/:id', jourController.updateJour);

// Route to delete a Jour record
router.delete('/:id', jourController.deleteJour);*/

module.exports = router;
