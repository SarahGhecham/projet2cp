const fetch = require('node-fetch');

async function validateAddress(address) {
    try {
        const apiKey = 'AIzaSyD_d366EANPIHugZe9YF5QVxHHa_Bzef_4'; // Remplacez cela par votre clé API
        const url = `https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=${encodeURIComponent(address)}&inputtype=textquery&fields=formatted_address&key=${apiKey}`;
        
        const response = await fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            }
        });

        const data = await response.json();
        console.log("Réponse de l'API Google Maps:", data);
        if (data && data.status === 'OK' && data.candidates && data.candidates.length > 0) {
            const validatedAddress = data.candidates[0].formatted_address;
            return validatedAddress;
        } else {
            throw new Error('No validated address found or error in response');
        }
    } catch (error) {
        console.error('Error validating address:', error);
        throw new Error('Failed to validate address');
    }
}

// Exemple d'utilisation :
const addressToValidate = '1600 Amphitheatre Parkway, Mountain View, CA';
validateAddress(addressToValidate)
    .then(validatedAddress => {
        console.log('Validated address:', validatedAddress);
    })
    .catch(error => {
        console.error('Error:', error);
    });
