const axios = require('axios');

// Fonction pour géocoder une adresse et retourner ses coordonnées
async function geocode(address) {
    try {
        // Construire l'URL pour la requête de géocodage avec l'API Google Maps
        const url = `https://maps.googleapis.com/maps/api/geocode/json?address=${encodeURIComponent(address)}&key=AIzaSyBUoTHDCzxA7lix93aS8D5EuPa-VCuoAq0`;
        
        // Effectuer la requête HTTP pour géocoder l'adresse
        const response = await axios.get(url);
        const data = response.data; // Convertir la réponse en JSON
        //console.log("Réponse de l'API Google Maps:", data);

        // Vérifier si des résultats ont été trouvés pour l'adresse
        if (data && data.results && data.results.length > 0) {
            // Extraire les coordonnées de latitude et de longitude du premier résultat
            const { lat, lng } = data.results[0].geometry.location;
            return { latitude: lat, longitude: lng };
        } else {
            // Si aucun résultat n'a été trouvé, lancer une erreur
            throw new Error('No results found for the address');
        }
    } catch (error) {
        // Gérer les erreurs de géocodage
        console.error('Error geocoding address:', error);
        throw new Error('Failed to geocode address');
    }
}

// Fonction pour calculer la distance routière entre deux coordonnées en utilisant l'API Google Maps
async function calculateRouteDistance(coords1, coords2) {
    try {
        // Construire l'URL pour la requête de calcul de l'itinéraire avec l'API Directions de Google Maps
        const url = `https://maps.googleapis.com/maps/api/directions/json?origin=${coords1.latitude},${coords1.longitude}&destination=${coords2.latitude},${coords2.longitude}&key=AIzaSyD_d366EANPIHugZe9YF5QVxHHa_Bzef_4`;

        // Effectuer la requête HTTP pour obtenir l'itinéraire
        const response = await axios.get(url);
        const data = response.data; // Convertir la réponse en JSON
        //console.log("Réponse de l'API Google Maps:", data);

        // Vérifier si des résultats ont été renvoyés et s'il n'y a pas d'erreur
        if (data && data.routes && data.routes.length > 0 && data.routes[0].legs && data.routes[0].legs.length > 0) {
            // Extraire la distance en mètres depuis les résultats de l'itinéraire
            const distanceInMeters = data.routes[0].legs[0].distance.value;
            const distanceInKilometers = distanceInMeters / 1000; // Convertir en kilomètres
            return distanceInKilometers;
        } else {
            throw new Error('No route found or error in response');
        }
    } catch (error) {
        // Gérer les erreurs
        console.error('Error calculating route distance:', error);
        throw new Error('Failed to calculate route distance');
    }
}


// Exemple d'utilisation :
/*const clientAddress = 'Résidence Les Pins, Ben Aknoun';
const artisanAddress = 'ENP,El Harrach';

(async () => {
    try {
        // Géocoder les adresses du client et de l'artisan pour obtenir leurs coordonnées
        const clientCoords = await geocode(clientAddress);
        const artisanCoords = await geocode(artisanAddress);
        
        // Afficher les coordonnées du client et de l'artisan
        console.log('Client coordinates:', clientCoords);
        console.log('Artisan coordinates:', artisanCoords);

        // Calculer la distance routière entre le client et l'artisan
        const routeDistance = await calculateRouteDistance(clientCoords, artisanCoords);
        console.log('Route distance between client and artisan:', routeDistance.toFixed(2), 'km');
        
        // Votre logique pour déterminer si l'artisan peut se déplacer vers l'adresse du client
        // (par exemple, en comparant la distance avec le spectre géographique de l'artisan)
    } catch (error) {
        // Gérer les erreurs
        console.error('Error:', error);
    }
})();*/

module.exports = {
    calculateRouteDistance,
    geocode
}




