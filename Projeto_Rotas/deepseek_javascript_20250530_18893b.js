// Variáveis globais
let map;
let routeLayer;
let markers = [];
let geocoder;

// Inicializa o mapa quando a página carrega
document.addEventListener('DOMContentLoaded', function() {
    initMap();
    setupEventListeners();
});

function initMap() {
    // Cria o mapa centrado no Brasil
    map = L.map('map').setView([-14.2350, -51.9253], 5);
    
    // Adiciona o tile layer do OpenStreetMap
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map);
    
    // Inicializa o geocoder (Nominatim)
    geocoder = L.Control.geocoder({
        defaultMarkGeocode: false,
        position: 'topleft'
    }).addTo(map);
    
    geocoder.on('markgeocode', function(e) {
        const input = document.querySelector('.location-input:focus');
        if (input) {
            input.value = e.geocode.name;
        }
    });
    
    // Camada para a rota
    routeLayer = L.layerGroup().addTo(map);
}

function setupEventListeners() {
    // Adiciona evento ao botão de adicionar localização
    document.getElementById('add-location').addEventListener('click', addLocation);
    
    // Adiciona evento ao botão de otimizar rota
    document.getElementById('optimize-route').addEventListener('click', optimizeRoute);
    
    // Adiciona evento ao botão de resetar
    document.getElementById('reset').addEventListener('click', resetAll);
    
    // Adiciona evento aos botões de remover (delegação de eventos)
    document.getElementById('location-inputs').addEventListener('click', function(e) {
        if (e.target.classList.contains('remove-btn')) {
            removeLocation(e.target);
        }
    });
}

function addLocation() {
    const inputsContainer = document.getElementById('location-inputs');
    const newInputGroup = document.createElement('div');
    newInputGroup.className = 'input-group';
    
    const newInput = document.createElement('input');
    newInput.type = 'text';
    newInput.className = 'location-input';
    newInput.placeholder = 'Digite um endereço';
    
    const removeBtn = document.createElement('button');
    removeBtn.className = 'remove-btn';
    removeBtn.innerHTML = '×';
    
    newInputGroup.appendChild(newInput);
    newInputGroup.appendChild(removeBtn);
    inputsContainer.appendChild(newInputGroup);
    
    // Foca no novo input
    newInput.focus();
}

function removeLocation(button) {
    const inputGroups = document.querySelectorAll('.input-group');
    if (inputGroups.length > 1) {
        button.parentNode.remove();
    } else {
        alert('Você precisa ter pelo menos um local.');
    }
}

async function optimizeRoute() {
    const inputs = document.querySelectorAll('.location-input');
    const locations = [];
    
    // Coleta todos os endereços digitados
    for (let i = 0; i < inputs.length; i++) {
        if (inputs[i].value.trim() === '') {
            alert('Por favor, preencha todos os campos de endereço.');
            return;
        }
        locations.push(inputs[i].value);
    }
    
    if (locations.length < 2) {
        alert('Você precisa adicionar pelo menos dois locais para calcular uma rota.');
        return;
    }
    
    try {
        // Limpa marcadores e rotas anteriores
        clearMap();
        
        // Converte endereços em coordenadas
        const coordinates = await Promise.all(locations.map(geocodeAddress));
        
        // Filtra coordenadas válidas
        const validCoordinates = coordinates.filter(coord => coord !== null);
        
        if (validCoordinates.length < 2) {
            alert('Não foi possível geocodificar endereços suficientes para calcular uma rota.');
            return;
        }
        
        // Encontra a ordem otimizada (simplificado - na prática use um algoritmo melhor para muitos pontos)
        const optimizedOrder = await findOptimizedRoute(validCoordinates);
        
        // Desenha a rota otimizada
        await drawOptimizedRoute(optimizedOrder);
        
        // Ajusta o zoom do mapa para mostrar toda a rota
        const bounds = L.latLngBounds(optimizedOrder.map(coord => [coord.lat, coord.lon]));
        map.fitBounds(bounds);
        
    } catch (error) {
        console.error('Erro ao otimizar a rota:', error);
        alert('Ocorreu um erro ao calcular a rota. Por favor, verifique os endereços e tente novamente.');
    }
}

function geocodeAddress(address) {
    return fetch(`https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(address)}`)
        .then(response => response.json())
        .then(data => {
            if (data && data.length > 0) {
                const firstResult = data[0];
                return {
                    address: address,
                    lat: parseFloat(firstResult.lat),
                    lon: parseFloat(firstResult.lon),
                    display_name: firstResult.display_name
                };
            }
            return null;
        })
        .catch(error => {
            console.error('Erro no geocoding:', error);
            return null;
        });
}

async function findOptimizedRoute(locations) {
    if (locations.length <= 2) {
        return locations; // Não há otimização para menos de 3 pontos
    }
    
    // Implementação simplificada - para produção considere usar uma biblioteca especializada
    // ou limitar o número de pontos
    
    // Usa o primeiro local como ponto de partida fixo
    const startPoint = locations[0];
    const otherPoints = locations.slice(1);
    
    let shortestDistance = Infinity;
    let bestOrder = [];
    
    // Gera todas as permutações possíveis (não eficiente para muitos pontos)
    const permutations = generatePermutations(otherPoints);
    
    for (const permutation of permutations) {
        const currentOrder = [startPoint, ...permutation];
        const totalDistance = await calculateTotalDistance(currentOrder);
        
        if (totalDistance < shortestDistance) {
            shortestDistance = totalDistance;
            bestOrder = currentOrder;
        }
    }
    
    return bestOrder;
}

function generatePermutations(arr) {
    if (arr.length <= 1) return [arr];
    
    const result = [];
    for (let i = 0; i < arr.length; i++) {
        const current = arr[i];
        const remaining = [...arr.slice(0, i), ...arr.slice(i + 1)];
        const remainingPerms = generatePermutations(remaining);
        
        for (const perm of remainingPerms) {
            result.push([current, ...perm]);
        }
    }
    
    return result;
}

async function calculateTotalDistance(locations) {
    let totalDistance = 0;
    
    for (let i = 0; i < locations.length - 1; i++) {
        const origin = locations[i];
        const destination = locations[i + 1];
        
        const distance = await getDistanceBetween(origin, destination);
        totalDistance += distance;
    }
    
    return totalDistance;
}

function getDistanceBetween(origin, destination) {
    return fetch(`https://router.project-osrm.org/route/v1/driving/${origin.lon},${origin.lat};${destination.lon},${destination.lat}?overview=false`)
        .then(response => response.json())
        .then(data => {
            if (data.routes && data.routes.length > 0) {
                return data.routes[0].distance; // em metros
            }
            // Se falhar, retorna distância em linha reta
            return calculateHaversineDistance(origin, destination);
        })
        .catch(() => {
            // Em caso de erro, usa cálculo de distância simples
            return calculateHaversineDistance(origin, destination);
        });
}

function calculateHaversineDistance(coord1, coord2) {
    // Fórmula de Haversine para calcular distância entre dois pontos
    const R = 6371000; // Raio da Terra em metros
    const φ1 = coord1.lat * Math.PI / 180;
    const φ2 = coord2.lat * Math.PI / 180;
    const Δφ = (coord2.lat - coord1.lat) * Math.PI / 180;
    const Δλ = (coord2.lon - coord1.lon) * Math.PI / 180;

    const a = Math.sin(Δφ/2) * Math.sin(Δφ/2) +
              Math.cos(φ1) * Math.cos(φ2) *
              Math.sin(Δλ/2) * Math.sin(Δλ/2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));

    return R * c;
}

async function drawOptimizedRoute(optimizedOrder) {
    // Limpa a rota anterior
    routeLayer.clearLayers();
    
    // Adiciona marcadores para cada ponto
    optimizedOrder.forEach((point, index) => {
        const marker = L.marker([point.lat, point.lon]).addTo(routeLayer);
        marker.bindPopup(`<b>${index + 1}. ${point.display_name || point.address}</b>`).openPopup();
        markers.push(marker);
    });
    
    // Prepara os pontos para a API OSRM
    const coordinates = optimizedOrder.map(point => `${point.lon},${point.lat}`).join(';');
    
    try {
        const response = await fetch(`https://router.project-osrm.org/route/v1/driving/${coordinates}?overview=full&geometries=geojson&steps=true`);
        const data = await response.json();
        
        if (data.routes && data.routes.length > 0) {
            const route = data.routes[0];
            
            // Desenha a rota no mapa
            const routeGeoJSON = {
                type: 'Feature',
                geometry: route.geometry,
                properties: {}
            };
            
            L.geoJSON(routeGeoJSON, {
                style: {
                    color: '#3388ff',
                    weight: 5,
                    opacity: 0.7
                }
            }).addTo(routeLayer);
            
            // Exibe as instruções da rota
            displayRouteInstructions(route.legs, optimizedOrder);
        } else {
            throw new Error('Não foi possível calcular a rota');
        }
    } catch (error) {
        console.error('Erro ao desenhar rota:', error);
        alert('Não foi possível traçar a rota. Tente novamente com menos pontos ou endereços mais precisos.');
    }
}

function displayRouteInstructions(legs, points) {
    const instructionsPanel = document.getElementById('instructions');
    instructionsPanel.innerHTML = '';
    
    legs.forEach((leg, legIndex) => {
        // Adiciona ponto de partida
        if (legIndex === 0) {
            const startStep = document.createElement('div');
            startStep.className = 'route-step';
            startStep.innerHTML = `<strong>Partida:</strong> ${points[legIndex].display_name || points[legIndex].address}`;
            instructionsPanel.appendChild(startStep);
        }
        
        // Adiciona instruções para cada etapa
        leg.steps.forEach(step => {
            const stepElement = document.createElement('div');
            stepElement.className = 'route-step';
            stepElement.innerHTML = step.maneuver.instruction;
            instructionsPanel.appendChild(stepElement);
        });
        
        // Adiciona ponto de chegada
        const endStep = document.createElement('div');
        endStep.className = 'route-step';
        endStep.innerHTML = `<strong>Chegada:</strong> ${points[legIndex + 1].display_name || points[legIndex + 1].address}`;
        instructionsPanel.appendChild(endStep);
    });
}

function clearMap() {
    routeLayer.clearLayers();
    markers = [];
    document.getElementById('instructions').innerHTML = '';
}

function resetAll() {
    clearMap();
    const inputsContainer = document.getElementById('location-inputs');
    inputsContainer.innerHTML = '';
    
    // Adiciona um input vazio
    const newInputGroup = document.createElement('div');
    newInputGroup.className = 'input-group';
    
    const newInput = document.createElement('input');
    newInput.type = 'text';
    newInput.className = 'location-input';
    newInput.placeholder = 'Digite um endereço';
    
    const removeBtn = document.createElement('button');
    removeBtn.className = 'remove-btn';
    removeBtn.innerHTML = '×';
    
    newInputGroup.appendChild(newInput);
    newInputGroup.appendChild(removeBtn);
    inputsContainer.appendChild(newInputGroup);
}