const express = require('express');
const router = express.Router();
const messageController = require('../controllers/messages');

router.post('/send', messageController.sendMessage);
router.get('/artisans/:conversationId', messageController.retrieveMessagesOfArtisan);
router.get('/clients/:conversationId', messageController.retrieveMessagesOfClient);
router.get('/history/:conversationId', messageController.retrieveMessageHistory);
router.delete('/:messageId/delete', messageController.deleteMessage);

module.exports = router;


