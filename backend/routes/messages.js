const express = require('express');
const router = express.Router();
const messageController = require('../controllers/messages');

// Message routes
router.post('/send', messageController.sendMessage);
router.get('/artisans/:conversationId', messageController.retrieveMessagesOfArtisan);
router.get('/clients/:conversationId', messageController.retrieveMessagesOfClient);
router.get('/history/:conversationId', messageController.retrieveMessageHistory);

module.exports = router;


