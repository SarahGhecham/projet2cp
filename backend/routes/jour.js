// jour.js

const express = require('express');
const router = express.Router();
const jourController = require('../controllers/jour.controller');

// Route to create a Jour record
router.get('/', jourController.getAllJours);
router.delete('/:id', jourController.deleteJour);
router.patch('/:id', jourController.updateJour);
router.delete('/:id', jourController.deleteJour);



/*
router.post('/', jourController.createJour);
router.delete('/:id', jourController.deleteJour);



// Route to update a Jour record
router.patch('/:id', jourController.updateJour);

// Route to delete a Jour record
router.delete('/:id', jourController.deleteJour);*/

module.exports = router;
