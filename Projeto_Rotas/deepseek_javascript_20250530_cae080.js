// Variáveis globais
let map;
let routeLayer;
let markers = [];
let geocoder;

// Inicializa o mapa quando a página carrega
document.addEventListener('DOMContentLoaded', function() {
    initMap();
    setupEventListeners();
    
    // Configura o botão remover do primeiro input
    const firstRemoveBtn = document.querySelector('.remove-btn');
    if (firstRemoveBtn) {
        firstRemoveBtn.addEventListener('click', function() {
            removeLocation(this);
        });
    }

    // Configura o autocomplete para todos os inputs existentes na inicialização
    document.querySelectorAll('.location-input').forEach(input => {
        setupAutocomplete(input);
    });
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
    
    // Este listener global é importante para a funcionalidade do geocoder, mas a interação
    // com inputs dinâmicos será gerenciada pela função setupAutocomplete.
    geocoder.on('markgeocode', function(e) {
        // Se o geocoder tem um input focado, atualiza o valor dele
        const activeInput = document.activeElement;
        if (activeInput && activeInput.classList.contains('location-input')) {
            activeInput.value = e.geocode.name;
        }
    });
    
    // Camada para a rota
    routeLayer = L.layerGroup().addTo(map);
}

function setupEventListeners() {
    // Adiciona evento ao botão de adicionar localização
    document.getElementById('add-location').addEventListener('click', function() {
        addLocation();
    });
    
    // Adiciona evento ao botão de otimizar rota
    document.getElementById('optimize-route').addEventListener('click', optimizeRoute);
    
    // Adiciona evento ao botão de resetar
    document.getElementById('reset').addEventListener('click', resetAll);
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
    removeBtn.addEventListener('click', function() {
        removeLocation(this);
    });
    
    newInputGroup.appendChild(newInput);
    newInputGroup.appendChild(removeBtn);
    inputsContainer.appendChild(newInputGroup);
    
    // Configura o autocomplete para o novo input
    setupAutocomplete(newInput);
    
    // Foca no novo input
    newInput.focus();
}

function setupAutocomplete(input) {
    // Usando a API Nominatim para autocompletar na tecla Enter
    input.addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            e.preventDefault(); // Evita a submissão de formulário
            geocodeAddress(input.value).then(result => {
                if (result) {
                    input.value = result.display_name || result.address;
                }
            });
        }
    });

    // Adiciona o geocoder ao input quando ele ganha foco
    input.addEventListener('focus', function() {
        // Nada a fazer aqui diretamente, pois o geocoder é global e atualiza o activeElement
        // A lógica de `geocoder.on('markgeocode')` já está na `initMap` e verifica o `document.activeElement`
    });
}

function removeLocation(button) {
    const inputGroups = document.querySelectorAll('.input-group');
    if (inputGroups.length > 1) {
        button.parentNode.remove();
    } else {
        alert('Você precisa ter pelo menos um local.');
    }
}

async function geocodeAddress(address) {
    // Usando a API Nominatim para geocodificação
    const url = `https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(address)}`;
    try {
        const response = await fetch(url);
        const data = await response.json();
        if (data && data.length > 0) {
            return { lat: parseFloat(data[0].lat), lon: parseFloat(data[0].lon), display_name: data[0].display_name, address: data[0].address };
        }
        return null;
    } catch (error) {
        console.error('Erro ao geocodificar o endereço:', error);
        return null;
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
        
        // Encontra a ordem otimizada (simplificado)
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

async function findOptimizedRoute(coordinates) {
    if (coordinates.length <= 2) {
        return coordinates; // Para 2 ou menos pontos, a ordem é trivial ou não há otimização de "caixeiro viajante"
    }

    // Simplificação: para mais de 2 pontos, vamos usar um serviço de roteamento para encontrar a ordem otimizada.
    // Para um problema de "caixeiro viajante" real, seria necessário um algoritmo mais complexo.
    // Aqui, vamos usar a API OSRM que pode calcular uma rota entre múltiplos pontos e otimizá-los.
    // O profile 'viaroute' tenta otimizar o tempo de viagem.

    const waypoints = coordinates.map(coord => `${coord.lon},${coord.lat}`).join(';');
    const osrmUrl = `https://router.project-osrm.org/viaroute/v1/driving/${waypoints}?overview=full&alternatives=false&steps=true&annotations=true`;

    try {
        const response = await fetch(osrmUrl);
        const data = await response.json();

        if (data.code === 'Ok' && data.waypoints) {
            // A OSRM retorna a ordem otimizada dos waypoints
            const optimizedCoords = data.waypoints.map(wp => {
                const originalCoord = coordinates[wp.waypoint_index];
                return { lat: originalCoord.lat, lon: originalCoord.lon, display_name: originalCoord.display_name };
            });
            return optimizedCoords;
        } else {
            console.error('Erro na API OSRM:', data);
            alert('Não foi possível otimizar a rota. Tente novamente mais tarde ou com menos pontos.');
            return coordinates; // Retorna a ordem original se a otimização falhar
        }
    } catch (error) {
        console.error('Erro ao chamar a API OSRM:', error);
        alert('Erro ao otimizar a rota. Verifique sua conexão ou tente novamente.');
        return coordinates; // Retorna a ordem original em caso de erro na chamada da API
    }
}


async function drawOptimizedRoute(optimizedCoordinates) {
    routeLayer.clearLayers();
    markers.forEach(marker => map.removeLayer(marker)); // Remove marcadores antigos
    markers = [];

    // Adiciona marcadores para os pontos
    optimizedCoordinates.forEach((coord, index) => {
        const marker = L.marker([coord.lat, coord.lon]).addTo(map)
            .bindPopup(`<b>Parada ${index + 1}</b><br>${coord.display_name || 'Endereço desconhecido'}`);
        markers.push(marker);
    });

    if (optimizedCoordinates.length < 2) {
        return; // Não há rota para desenhar com menos de 2 pontos
    }

    // Requisita a rota do OSRM com os pontos na ordem otimizada
    const waypoints = optimizedCoordinates.map(coord => `${coord.lon},${coord.lat}`).join(';');
    const osrmUrl = `https://router.project-osrm.org/route/v1/driving/${waypoints}?overview=full&alternatives=false&steps=true&geometries=geojson`;

    try {
        const response = await fetch(osrmUrl);
        const data = await response.json();

        if (data.routes && data.routes.length > 0) {
            const route = data.routes[0];
            const geometry = route.geometry;

            L.geoJSON(geometry, {
                style: {
                    color: '#3498db',
                    weight: 5,
                    opacity: 0.7
                }
            }).addTo(routeLayer);

            // Exibir instruções da rota
            displayRouteInstructions(route.legs);

        } else {
            alert('Não foi possível encontrar uma rota para os endereços fornecidos.');
            console.error('Nenhuma rota encontrada:', data);
        }
    } catch (error) {
        console.error('Erro ao desenhar a rota:', error);
        alert('Ocorreu um erro ao desenhar a rota. Por favor, tente novamente.');
    }
}

function displayRouteInstructions(legs) {
    const instructionsPanel = document.getElementById('instructions');
    instructionsPanel.innerHTML = ''; // Limpa instruções anteriores

    if (!legs || legs.length === 0) {
        instructionsPanel.innerHTML = '<p>Nenhuma instrução de rota disponível.</p>';
        return;
    }

    legs.forEach((leg, legIndex) => {
        const legDiv = document.createElement('div');
        legDiv.className = 'route-leg';
        legDiv.innerHTML = `<h4>Trecho ${legIndex + 1}</h4>`;

        if (leg.steps && leg.steps.length > 0) {
            leg.steps.forEach((step, stepIndex) => {
                const stepDiv = document.createElement('div');
                stepDiv.className = 'route-step';
                stepDiv.innerHTML = `<p>${stepIndex + 1}. ${step.maneuver.instruction} (${(step.distance / 1000).toFixed(2)} km)</p>`;
                legDiv.appendChild(stepDiv);
            });
        } else {
            legDiv.innerHTML += '<p>Nenhuma instrução detalhada para este trecho.</p>';
        }
        instructionsPanel.appendChild(legDiv);
    });
}

function clearMap() {
    routeLayer.clearLayers();
    markers.forEach(marker => map.removeLayer(marker));
    markers = [];
    document.getElementById('instructions').innerHTML = ''; // Limpa as instruções
}

function resetAll() {
    clearMap();
    
    // Remove todos os inputs de localização, exceto o primeiro
    const inputsContainer = document.getElementById('location-inputs');
    while (inputsContainer.children.length > 1) {
        inputsContainer.removeChild(inputsContainer.lastChild);
    }
    
    // Limpa o valor do primeiro input
    const firstInput = document.querySelector('.location-input');
    if (firstInput) {
        firstInput.value = '';
    }

    // Centraliza o mapa de volta ao Brasil
    map.setView([-14.2350, -51.9253], 5);
}