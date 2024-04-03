const fetch = require('node-fetch');
const geolib = require('geolib');

// Fonction pour géocoder une adresse et retourner ses coordonnées
async function geocode(address) {
    try {
        // Construire l'URL pour la requête de géocodage
        const url = `https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(address)}`;
        
        // Effectuer la requête HTTP pour géocoder l'adresse
        const response = await fetch(url);
        const data = await response.json(); // Convertir la réponse en JSON

        // Vérifier si des résultats ont été trouvés pour l'adresse
        if (data && data.length > 0) {
            // Extraire les coordonnées de latitude et de longitude du premier résultat
            const { lat, lon } = data[0];
            return { latitude: parseFloat(lat), longitude: parseFloat(lon) };
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

// Fonction pour calculer la distance routière entre deux coordonnées en utilisant l'API OSRM
async function calculateRouteDistance(coords1, coords2) {
    try {
        // Construire l'URL pour la requête de calcul de la distance routière avec OSRM
        const url = `https://router.project-osrm.org/route/v1/driving/${coords1.longitude},${coords1.latitude};${coords2.longitude},${coords2.latitude}?overview=false`;

        // Effectuer la requête HTTP pour calculer la distance routière
        const response = await fetch(url);
        const data = await response.json(); // Convertir la réponse en JSON

        // Vérifier si des résultats ont été renvoyés
        if (data && data.routes && data.routes.length > 0) {
            // Extraire la distance en mètres depuis les résultats
            const distanceInMeters = data.routes[0].distance;
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
const clientAddress = 'Résidence Les Pins, Ben Aknoun';
const artisanAddress = 'École Militaire Polytechnique';

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
})();

