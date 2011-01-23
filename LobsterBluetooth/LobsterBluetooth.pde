#include <MeetAndroid.h>
#include <Servo.h> 

//Servos
// Vao de 0 a 90. Nesse caso, deve ser calibrado para parar nos 45,
// e assim ele irá rodar para trás abaixo dos 45 e para frente acima dos 45.
Servo rodaDir;
Servo rodaEsq;

const int VEL_MAX = 45;
const int VEL_MIN = 5;
const int STOP = 45;
//---

//MeetAndroid
MeetAndroid meetAndroid;

const float DIFF = 2;
const int X = 0;
const int Y = 1;
const int Z = 2;

float eixos[3];
//---

void setup() {
  //Inicialização dos Servos
  rodaEsq.attach(10);
  rodaDir.attach(11);
  delay(10);
  parar();
  //---

  //Inicialização do Amarino
  Serial.begin(57600);
  meetAndroid.registerFunction(acelerometro, 'B'); // a string
  //---
}

void loop() {
  meetAndroid.receive(); // you need to keep this in your loop() to receive events
  andar();
  delay(20);
}

/*
 */
void acelerometro(byte flag, byte numOfValues)
{
  int length = meetAndroid.stringLength();
  char data[length];
  meetAndroid.getString(data);
  String leitura = data;

  //Separa a string recebida do Amarino em 3 strings
  //Ex: 1.42342;-3.43242;-1.34232  
  int offset = 0;
  int count = 0;
  for(int i = 0; i < length; i++) {
    //Toda vez que encontrar um ';', le de 'offset' até 'i'
    if(data[i] == ';') {
      eixos[count] = stringToFloat(leitura.substring(offset, i));
      offset = i + 1;
      count++;
      
      //Se o último ';' na string tiver o mesmo índice de 'i', então pega 
      //o restante da string no próximo elemento do array.
      if(leitura.lastIndexOf(';') == i) {
        eixos[count] = stringToFloat(leitura.substring(offset, length));
      }
    }
  }
  
//  meetAndroid.send("x");
//  meetAndroid.send(eixos[X]);
//  meetAndroid.send("y");
//  meetAndroid.send(eixos[Y]);
//  meetAndroid.send("z");
//  meetAndroid.send(eixos[Z]);
}

void andar() {
  if(eixos[Y] < -DIFF) {
    meetAndroid.send("frente");
    frente();
  } else if(eixos[Y] > DIFF) {
    meetAndroid.send("recuar");
    recuar();
  } else if (eixos[X] > DIFF) {
    meetAndroid.send("esquerda");
    esquerda();
  } else if(eixos[X] < -DIFF) {
    meetAndroid.send("direita");
    direita();
  } else {
    parar();
  }
}

void parar() {
  rodaDir.write(STOP);
  rodaEsq.write(STOP);
}

void frente() {
  rodaDir.write(45 - VEL_MAX);
  rodaEsq.write(VEL_MAX + 45);
}

void recuar() {
  rodaDir.write(VEL_MAX + 45);
  rodaEsq.write(45 - VEL_MAX);
}

void direita() {
  rodaDir.write(STOP);
  rodaEsq.write(VEL_MAX + 45);
}

void esquerda() {
  rodaDir.write(45 - VEL_MAX);
  rodaEsq.write(STOP);
}

/**
 * Converts a String to a float
 */
float stringToFloat(String str) {
  char arr[str.length()];
  str.toCharArray(arr, sizeof(arr));
  return atof(arr);
}
