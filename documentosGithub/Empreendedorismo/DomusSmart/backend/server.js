const express = require('express');
const http = require('http');
const socketIo = require('socket.io');
const { SerialPort } = require('serialport');
const { ReadlineParser } = require('@serialport/parser-readline');
const path = require('path');
const cors = require('cors');

const app = express();
const server = http.createServer(app);
const io = socketIo(server, {
    cors: {
        origin: "*",
        methods: ["GET", "POST"]
    }
});

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, '../frontend')));

// Estado dos dispositivos (em memória)
let deviceStates = {
    sala: false,
    quarto: false,
    cozinha: false,
    garagem: false
};

// Configuração da porta serial (ajuste para sua porta Arduino)
let arduinoPort = null;
let isArduinoConnected = false;

// Função para conectar com o Arduino
function connectToArduino() {
    // Lista portas seriais disponíveis
    SerialPort.list().then(ports => {
        console.log('Portas seriais disponíveis:');
        ports.forEach(port => {
            console.log(`- ${port.path} | ${port.manufacturer || 'Desconhecido'}`);
        });

        // Tenta encontrar a porta do Arduino (ajuste conforme necessário)
        const arduinoPortPath = ports.find(port => 
            port.manufacturer?.includes('Arduino') || 
            port.path.includes('USB') ||
            port.path.includes('ACM0') ||
            port.path.includes('COM3')  // Ajuste para sua porta
        )?.path;

        if (arduinoPortPath) {
            console.log(`Conectando ao Arduino na porta: ${arduinoPortPath}`);
            
            arduinoPort = new SerialPort({
                path: arduinoPortPath,
                baudRate: 9600
            });

            const parser = arduinoPort.pipe(new ReadlineParser({ delimiter: '\r\n' }));

            arduinoPort.on('open', () => {
                console.log('✅ Conectado ao Arduino!');
                isArduinoConnected = true;
                io.emit('arduino-status', { connected: true });
            });

            arduinoPort.on('error', (err) => {
                console.error('Erro na porta serial:', err);
                isArduinoConnected = false;
                io.emit('arduino-status', { connected: false });
            });

            arduinoPort.on('close', () => {
                console.log('❌ Conexão com Arduino fechada');
                isArduinoConnected = false;
                io.emit('arduino-status', { connected: false });
            });

            // Ouvir mensagens do Arduino
            parser.on('data', (data) => {
                console.log('📨 Dados do Arduino:', data);
                try {
                    const parsedData = JSON.parse(data);
                    io.emit('sensor-data', parsedData);
                } catch (e) {
                    console.log('Mensagem do Arduino:', data);
                }
            });

        } else {
            console.log('❌ Arduino não encontrado. Modo simulação ativado.');
            isArduinoConnected = false;
        }
    }).catch(err => {
        console.error('Erro ao listar portas seriais:', err);
        isArduinoConnected = false;
    });
}

// Rota principal - serve o frontend
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, '../frontend/index.html'));
});

// API para verificar status
app.get('/api/status', (req, res) => {
    res.json({
        connected: isArduinoConnected,
        devices: deviceStates
    });
});

// API para controlar dispositivos
app.post('/api/device/:deviceName', (req, res) => {
    const { deviceName } = req.params;
    const { state } = req.body;

    if (deviceStates.hasOwnProperty(deviceName)) {
        deviceStates[deviceName] = state;
        
        // Enviar comando para o Arduino se conectado
        if (isArduinoConnected && arduinoPort) {
            const command = JSON.stringify({
                device: deviceName,
                state: state
            }) + '\n';
            
            arduinoPort.write(command, (err) => {
                if (err) {
                    console.error('Erro ao enviar comando:', err);
                    return res.status(500).json({ error: 'Erro na comunicação' });
                }
                console.log(`Comando enviado: ${deviceName} = ${state}`);
                res.json({ success: true, device: deviceName, state: state });
            });
        } else {
            // Modo simulação
            console.log(`Simulação: ${deviceName} = ${state}`);
            res.json({ success: true, device: deviceName, state: state, simulated: true });
        }

        // Emitir atualização via Socket.IO
        io.emit('device-update', { device: deviceName, state: state });
        
    } else {
        res.status(404).json({ error: 'Dispositivo não encontrado' });
    }
});

// WebSocket para comunicação em tempo real
io.on('connection', (socket) => {
    console.log('👤 Cliente conectado:', socket.id);

    // Enviar estado atual ao cliente
    socket.emit('initial-state', {
        connected: isArduinoConnected,
        devices: deviceStates
    });

    socket.on('disconnect', () => {
        console.log('👤 Cliente desconectado:', socket.id);
    });
});

// Iniciar servidor
const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
    console.log(`🚀 Servidor rodando na porta ${PORT}`);
    console.log(`📱 Acesse: http://localhost:${PORT}`);
    
    // Tentar conectar com o Arduino
    connectToArduino();
});

// Tentar reconectar com o Arduino a cada 30 segundos se desconectado
setInterval(() => {
    if (!isArduinoConnected) {
        console.log('🔄 Tentando reconectar com o Arduino...');
        connectToArduino();
    }
}, 30000);