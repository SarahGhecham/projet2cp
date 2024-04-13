const models = require('../models');
async function sendMessage(req, res) {
    try {
        const { senderId, senderType, receiverId, receiverType, content, conversationId } = req.body;

        // We Check if the conversation exists
        const conversation = await models.Conversation.findByPk(conversationId);
        if (!conversation) {
            return res.status(404).json({ message: `Conversation with ID ${conversationId} not found. Create a new conversation, then you can start sending messages.` });
        }

        const message = await models.Message.create({
            senderId,
            senderType,
            receiverId,
            receiverType,
            content,
            conversationId,
            sentAt: new Date() // Add the sentAt field with the current timestamp
        });

        res.status(201).json({ message: 'Message sent successfully', data: message });
    } catch (error) {
        console.error('Error sending message:', error);
        res.status(500).json({ message: 'Failed to send message', error: error.message });
    }
}






async function retrieveMessagesOfArtisan(req, res) {
    try {
        const { conversationId } = req.params;

        const messages = await models.Message.findAll({
            where: {
                conversationId,
                senderType: 'artisan'
            },
            order: [['sentAt', 'ASC']]
        });

        res.status(200).json({ data: messages });
    } catch (error) {
        console.error('Error retrieving messages of artisan:', error);
        res.status(500).json({ message: 'Failed to retrieve messages', error: error.message });
    }
}

async function retrieveMessagesOfClient(req, res) {
    try {
        const { conversationId } = req.params;

        const messages = await models.Message.findAll({
            where: {
                conversationId,
                senderType: 'client'
            },
            order: [['sentAt', 'ASC']]
        });

        res.status(200).json({ data: messages });
    } catch (error) {
        console.error('Error retrieving messages of client:', error);
        res.status(500).json({ message: 'Failed to retrieve messages', error: error.message });
    }
}

async function retrieveMessageHistory(req, res) {
    try {
        const { conversationId } = req.params;

        const messages = await models.Message.findAll({
            where: { conversationId },
            order: [['sentAt', 'ASC']]
        });

        res.status(200).json({ data: messages });
    } catch (error) {
        console.error('Error retrieving message history:', error);
        res.status(500).json({ message: 'Failed to retrieve message history', error: error.message });
    }
}

async function deleteMessage(req, res) {
    try {
        const { messageId } = req.params;
        const message = await models.Message.findByPk(messageId);
        if (!message) {
            return res.status(404).json({ message: `Message with ID ${messageId} not found.` });
        }
        await message.destroy();
        res.status(200).json({ message: 'Message deleted successfully' });
    } catch (error) {
        console.error('Error deleting message:', error);
        res.status(500).json({ message: 'Failed to delete message', error: error.message });
    }
}
module.exports = {
    sendMessage,
    retrieveMessagesOfArtisan,
    retrieveMessagesOfClient,
    retrieveMessageHistory,
    deleteMessage
    
};
