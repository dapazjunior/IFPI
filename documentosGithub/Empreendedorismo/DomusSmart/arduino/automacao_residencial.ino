#include <ArduinoJson.h>

// Definição dos pinos
const int PIN_SALA = 2;
const int PIN_QUARTO = 3;
const int PIN_COZINHA = 4;
const int PIN_GARAGEM = 5;

// Estados dos dispositivos
bool salaState = false;
bool quartoState = false;
bool cozinhaState = false;
bool garagemState = false;

void setup() {
  // Inicializar comunicação serial
  Serial.begin(9600);
  
  // Configurar pinos como saída
  pinMode(PIN_SALA, OUTPUT);
  pinMode(PIN_QUARTO, OUTPUT);
  pinMode(PIN_COZINHA, OUTPUT);
  pinMode(PIN_GARAGEM, OUTPUT);
  
  // Inicializar todos desligados
  digitalWrite(PIN_SALA, LOW);
  digitalWrite(PIN_QUARTO, LOW);
  digitalWrite(PIN_COZINHA, LOW);
  digitalWrite(PIN_GARAGEM, LOW);
  
  // LED interno para indicar que está pronto
  pinMode(LED_BUILTIN, OUTPUT);
  blinkLED(3, 200); // Piscar 3 vezes
  
  Serial.println("🔄 Arduino Iniciado - Pronto para comandos");
  sendStatus();
}

void loop() {
  // Verificar se há dados disponíveis na serial
  if (Serial.available() > 0) {
    String input = Serial.readStringUntil('\n');
    input.trim();
    
    // Processar comando JSON
    if (input.startsWith("{")) {
      processCommand(input);
    }
  }
  
  // Pequeno delay para estabilidade
  delay(100);
}

void processCommand(String jsonCommand) {
  StaticJsonDocument<200> doc;
  DeserializationError error = deserializeJson(doc, jsonCommand);
  
  if (error) {
    Serial.print("❌ Erro JSON: ");
    Serial.println(error.c_str());
    return;
  }
  
  const char* device = doc["device"];
  bool state = doc["state"];
  
  // Controlar dispositivo conforme comando
  if (strcmp(device, "sala") == 0) {
    controlDevice(PIN_SALA, state, "sala", salaState);
  } 
  else if (strcmp(device, "quarto") == 0) {
    controlDevice(PIN_QUARTO, state, "quarto", quartoState);
  }
  else if (strcmp(device, "cozinha") == 0) {
    controlDevice(PIN_COZINHA, state, "cozinha", cozinhaState);
  }
  else if (strcmp(device, "garagem") == 0) {
    controlDevice(PIN_GARAGEM, state, "garagem", garagemState);
  }
  else {
    Serial.println("❌ Dispositivo desconhecido: " + String(device));
  }
}

void controlDevice(int pin, bool state, const char* deviceName, bool &deviceState) {
  digitalWrite(pin, state ? HIGH : LOW);
  deviceState = state;
  
  // Enviar confirmação
  StaticJsonDocument<100> doc;
  doc["device"] = deviceName;
  doc["state"] = state;
  doc["pin"] = pin;
  
  serializeJson(doc, Serial);
  Serial.println();
  
  // Feedback no LED interno
  digitalWrite(LED_BUILTIN, HIGH);
  delay(50);
  digitalWrite(LED_BUILTIN, LOW);
  
  Serial.print("✅ ");
  Serial.print(deviceName);
  Serial.print(state ? " LIGADO" : " DESLIGADO");
  Serial.println();
}

void sendStatus() {
  StaticJsonDocument<200> doc;
  doc["sala"] = salaState;
  doc["quarto"] = quartoState;
  doc["cozinha"] = cozinhaState;
  doc["garagem"] = garagemState;
  doc["status"] = "online";
  
  serializeJson(doc, Serial);
  Serial.println();
}

void blinkLED(int times, int delayTime) {
  for (int i = 0; i < times; i++) {
    digitalWrite(LED_BUILTIN, HIGH);
    delay(delayTime);
    digitalWrite(LED_BUILTIN, LOW);
    delay(delayTime);
  }
}   