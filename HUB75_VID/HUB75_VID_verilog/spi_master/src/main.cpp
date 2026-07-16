
#include <Arduino.h>

#include <SPI.h>

#include <FS.h>

#include <LittleFS.h>

  

// Definición de pines SPI en el ESP32 DevKit

#define VSPI_MISO 19 // No se usa para transmitir, pero se declara

#define VSPI_MOSI 23

#define VSPI_SCLK 18

#define VSPI_SS 5

  

File videoFile;

  

// Tamaño del frame para 1024 palabras de 24 bits (3 bytes cada una)

const int FRAME_SIZE = 3072;

uint8_t frameBuffer[FRAME_SIZE];

  

void setup() {

Serial.begin(115200);

if(!LittleFS.begin(true)){

Serial.println("[-] Error al montar el sistema LittleFS");

return;

}

  

// El binario contiene los datos secuenciales de 3 bytes por píxel agrupados

videoFile = LittleFS.open("/image.bin", "r");

if(!videoFile){

Serial.println("[-] No se encontró el archivo /image.bin en LittleFS");

return;

}

  

// Inicialización del periférico SPI Master

SPI.begin(VSPI_SCLK, VSPI_MISO, VSPI_MOSI, VSPI_SS);

pinMode(VSPI_SS, OUTPUT);

digitalWrite(VSPI_SS, HIGH);

Serial.println("[+] Inicialización completa. Transmitiendo video...");

}

  

void loop() {

if (videoFile.available()) {

int bytesRead = videoFile.read(frameBuffer, FRAME_SIZE);

if (bytesRead > 0) {

// Frecuencia segura de 4 MHz para el receptor de sobre-muestreo de la FPGA

SPI.beginTransaction(SPISettings(4000000, MSBFIRST, SPI_MODE0));

digitalWrite(VSPI_SS, LOW); // Comienza frame: FPGA pone write_addr a 0

SPI.writeBytes(frameBuffer, bytesRead);

digitalWrite(VSPI_SS, HIGH); // Fin de frame: FPGA conmuta Ping-Pong Buffer

SPI.endTransaction();

// Intervalo para ajustar la tasa de refresco visual (ej. 33 ms ~ 30 FPS)
const int FPS = 15; // Ajusta este valor al que uses en el script de Python
const int FRAME_DELAY = 1000 / FPS;
delay(FRAME_DELAY);

}

} else {

// Regresa al inicio del archivo binario para reproducción continua

videoFile.seek(0);

Serial.println("[+] Reiniciando animación...");

}

}