// controllers/messages.js

const models = require('../models');
// Controller function to send a message
async function sendMessage(req, res) {
    try {
        // Extract data from request body
        const { sender_id, sender_type, receiver_id, receiver_type, content } = req.body;

        // Create message in the database
        const message = await models.Message.create({
            sender_id,
            sender_type,
            receiver_id,
            receiver_type,
            content
        });

        // Respond with success message
        res.status(201).json({ message: 'Message sent successfully', data: message });
    } catch (error) {
        // Handle errors
        console.error('Error sending message:', error);
        res.status(500).json({ message: 'Failed to send message', error: error.message });
    }
}

async function retrieveMessagesofartisan(req, res) {
    try {
        // Extract query parameters
        const {  sender_id , receiver_id } = req.body;

        // Query messages from the database based on sender and receiver IDs
        const messages = await models.Message.findAll({
            where: {
                sender_id,
                sender_type :'artisan' ,
                receiver_id
            }
        });

        // Respond with retrieved messages
        res.status(200).json({ data: messages });
    } catch (error) {
        // Handle errors
        console.error('Error retrieving messages:', error);
        res.status(500).json({ message: 'Failed to retrieve messages', error: error.message });
    }
}

async function retrieveMessagesofclient(req, res) {
    try {
        // Extract query parameters
        const {  sender_id , receiver_id } = req.body;

        // Query messages from the database based on sender and receiver IDs
        const messages = await models.Message.findAll({
            where: {
                sender_id,
                sender_type :'artisan' ,
                receiver_id
            }
        });

        // Respond with retrieved messages
        res.status(200).json({ data: messages });
    } catch (error) {
        // Handle errors
        console.error('Error retrieving messages:', error);
        res.status(500).json({ message: 'Failed to retrieve messages', error: error.message });
    }
}



async function historyMessages(req, res) {
    try {
        const { artisanId, clientId } = req.body; // Assuming you have the IDs of the artisan and the client

        // Query messages from the database based on artisan and client IDs
        const messages = await models.Message.findAll({
            where: {
                // Retrieve messages sent between the artisan and the client
                [models.Sequelize.Op.or]: [
                    {
                        sender_id: artisanId,
                        sender_type: 'artisan',
                        receiver_id: clientId,
                        receiver_type: 'client'
                    },
                    {
                        sender_id: clientId,
                        sender_type: 'client',
                        receiver_id: artisanId,
                        receiver_type: 'artisan'
                    }
                ]
            },
            order: [['sent_at', 'ASC']] // Order messages by sent_at timestamp
        });

        // Respond with retrieved messages
        res.status(200).json({ data: messages });
    } catch (error) {
        // Handle errors
        console.error('Error retrieving message history:', error);
        res.status(500).json({ message: 'Failed to retrieve message history', error: error.message });
    }
}

module.exports = {
    sendMessage,
    retrieveMessagesofartisan ,
    retrieveMessagesofclient ,
    historyMessages ,

    
};
