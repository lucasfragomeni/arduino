/* 
 * Layout:
 * --------------------
 *    a  b  c  d  e  f
 *  1 .  .  .  .  .  .
 *  2 .  .  .  .  .  .
 *  3 .  .  .  .  .  .
 *  4 .  .  .  .  .  .
 *  5 .  .  .  .  .  .
 */

int ledPin;
int delayGeral = 10;  //Tempo da multiplexacao (microsegundos)
int delayRolar = 200; //Tempo em que cada palavra ficara num quadrante (milisegundos)

void setup() {
  //Serial.begin(9600);
  for (ledPin=2; ledPin <= 12; ledPin++) // Standard setup for LMP
  {
    pinMode(ledPin, OUTPUT); // sets the digital pins as output
    digitalWrite(ledPin, (ledPin <= 7)) ; // and sets all OFF
  }
}

void loop() {
  //Nao apagar. Sem isso nao funciona...
  Serial.println('a');
  
  rolarPalavra("108", 3);
  
/*
  char colunas[] = {'a', 'b', 'c', 'd', 'e', 'f'};
  for(int c = 0; c < 6; c++) {
    long timestamp = millis();
    while(millis() - timestamp < 1000) {
      switch(c) {
      case 5:
        acenderColuna(colunas[c]);
        acenderColuna(colunas[c-1]);
        acenderColuna(colunas[c-2]);
        acenderColuna(colunas[c-3]);
        acenderColuna(colunas[c-4]);
        acenderColuna(colunas[c-5]);
        break;
      case 4:
        acenderColuna(colunas[c]);
        acenderColuna(colunas[c-1]);
        acenderColuna(colunas[c-2]);
        acenderColuna(colunas[c-3]);
        acenderColuna(colunas[c-4]);
      case 3:
        acenderColuna(colunas[c]);
        acenderColuna(colunas[c-1]);
        acenderColuna(colunas[c-2]);
        acenderColuna(colunas[c-3]);
      case 2:
        acenderColuna(colunas[c]);
        acenderColuna(colunas[c-1]);
        acenderColuna(colunas[c-2]);
      case 1:
        acenderColuna(colunas[c]);
        acenderColuna(colunas[c-1]);
      case 0:
        acenderColuna(colunas[c]);
      }
    }
  }
*/
}

/* 
 * Layout:
 * --------------------
 *    a  b  c  d  e  f
 *  1 .  .  .  .  .  .
 *  2 .  .  .  .  .  .
 *  3 .  .  .  .  .  .
 *  4 .  .  .  .  .  .
 *  5 .  .  .  .  .  .
 */
void rolarPalavra(char palavra[], int length) {
  long timestamp = millis();
  for(char coluna = 'f'; coluna >= ('a' - (4 * length)); coluna--) {
    while(millis() - timestamp < delayRolar) {
      int colunaLetra = 0;
      for(int letra = 0; letra < length; letra++) {
        colunaLetra = coluna + (letra * 4);
        if(colunaLetra < ('a' - 3)) {
          continue;
        }
        if(colunaLetra > 'f') {
          break;
        }
        acenderSimbolo(palavra[letra], colunaLetra);
      }
    }
    timestamp = millis();
  }
}



void rolarSimbolo(char simbolo) {
  long timestamp = millis();
  for(char coluna = 'f'; coluna >= ('a' - 3); coluna--) {
    while(millis() - timestamp < delayRolar) {
      acenderSimbolo(simbolo, coluna);
    }
    timestamp = millis();
  }
}

/*
    .  .  .  a  b  c  d  e  f  .  .  .
  1 .  .  .  .  .  .  .  .  .  .  .  .
  2 .  .  .  .  .  .  .  .  .  .  .  .
  3 .  .  .  .  .  .  .  .  .  .  .  .
  4 .  .  .  .  .  .  .  .  .  .  .  .
  5 .  .  .  .  .  .  .  .  .  .  .  .
    .  .  .  a  b  c  d  e  f  .  .  .

void rolarPalavra(char[] palavra, int tamanho) {
  long timestamp = millis();
  char coluna = 'f';
  for(int i = 0; i < tamanho; i++) {
    char letraAtual = palavra[i];
    char proximaLetra = ' ';
    boolean temProximaLetra = ((i+1) < tamanho);
    if(temProximaLetra) {
      proximaLetra = palavra[i+1];
    }
    
    while(true) {
      while(millis() - timestamp < delayRolar) {
        acenderSimbolo(letraAtual, coluna);
        if(coluna <= 'c' && temProximaLetra) {
          acenderSimbolo(proximaLetra, coluna + 4);
        }
      }

      if(coluna == 'b' && temProximaLetra) {
        letraAtual = proximaLetra;
      }

      timestamp = millis();
      coluna--;
    }
  }
  
  for(char coluna = 'f'; coluna >= ('a' - 4); coluna--) {
    while(millis() - timestamp < delayRolar) {
      acenderSimbolo(simbolo, coluna);
    }
    timestamp = millis();
  }
}
 */

void tiltSimbolo(char simbolo, long tempo) {
  long timestampGlobal = millis();
  while(millis() - timestampGlobal < tempo) {
    long timestamp = millis();
    while(millis() - timestamp < 200) {
      acenderSimbolo(simbolo, 'a');
    }
    timestamp = millis();
    while(millis() - timestamp < 200) {
      acenderSimbolo(simbolo, 'b');
    }
  }
}


void acenderColuna(char coluna) {
  acenderColuna(coluna, 1, 5);
}  


void acenderColuna(char coluna, int linhaDe, int linhaAte) { 
  coluna = coluna - 95; // Em funÔøΩÔøΩo do valor de 'a' (97) na tabela ASCII
  linhaDe = 13 - linhaDe;
  linhaAte = 13 - linhaAte;  
      
  for (int linha = linhaDe; linha >= linhaAte; linha--) {
    acenderPonto(linha, coluna);
  }  
}  


void acenderSimbolo(char simbolo, char coluna) {
  switch(simbolo) {
     case '1':
       acenderColuna(coluna,1,1); 
       acenderColuna(coluna,5,5); 
       acenderColuna(coluna+1);
       acenderColuna(coluna+2,5,5); 
       break;
     case '2':
       acenderColuna(coluna,1,1); 
       acenderColuna(coluna,3,5); 
       acenderColuna(coluna+1,1,1); 
       acenderColuna(coluna+1,3,3); 
       acenderColuna(coluna+1,5,5); 
       acenderColuna(coluna+2,1,1); 
       acenderColuna(coluna+2,2,2); 
       acenderColuna(coluna+2,3,3); 
       acenderColuna(coluna+2,5,5); 
       break;
    case '3':
      acenderColuna(coluna,1,1); 
      acenderColuna(coluna,3,3); 
      acenderColuna(coluna,5,5); 
      acenderColuna(coluna+1,1,1); 
      acenderColuna(coluna+1,3,3); 
      acenderColuna(coluna+1,5,5); 
      acenderColuna(coluna+2);
      break;
    case '4':
      acenderColuna(coluna,1,1); 
      acenderColuna(coluna,2,2); 
      acenderColuna(coluna,3,3); 
      acenderColuna(coluna+1,3,3); 
      acenderColuna(coluna+2);
      break;
     case '5':
       acenderColuna(coluna,1,1); 
       acenderColuna(coluna,2,2); 
       acenderColuna(coluna,3,3); 
       acenderColuna(coluna,5,5); 
       acenderColuna(coluna+1,1,1); 
       acenderColuna(coluna+1,3,3); 
       acenderColuna(coluna+1,5,5); 
       acenderColuna(coluna+2,1,1); 
       acenderColuna(coluna+2,3,3); 
       acenderColuna(coluna+2,4,4); 
       acenderColuna(coluna+2,5,5); 
       break;
     case '6':
       acenderColuna(coluna); 
       acenderColuna(coluna+1,1,1); 
       acenderColuna(coluna+1,3,3); 
       acenderColuna(coluna+1,5,5); 
       acenderColuna(coluna+2,1,1); 
       acenderColuna(coluna+2,3,3); 
       acenderColuna(coluna+2,4,4); 
       acenderColuna(coluna+2,5,5); 
       break;
     case '7':
       acenderColuna(coluna,1,1); 
       acenderColuna(coluna+1,1,1); 
       acenderColuna(coluna+2); 
       break;
     case '8':
       acenderColuna(coluna); 
       acenderColuna(coluna+1,1,1); 
       acenderColuna(coluna+1,3,3); 
       acenderColuna(coluna+1,5,5); 
       acenderColuna(coluna+2); 
       break;
     case '9':
       acenderColuna(coluna,1,1); 
       acenderColuna(coluna,2,2); 
       acenderColuna(coluna,3,3); 
       acenderColuna(coluna,5,5); 
       acenderColuna(coluna+1,1,1); 
       acenderColuna(coluna+1,3,3); 
       acenderColuna(coluna+1,5,5); 
       acenderColuna(coluna+2); 
       break;
     case '0':
       acenderColuna(coluna); 
       acenderColuna(coluna+1,1,1); 
       acenderColuna(coluna+1,5,5); 
       acenderColuna(coluna+2); 
       break;
     case 'a':
     case 'A':
       acenderColuna(coluna);
       acenderColuna(coluna+1,1,1); 
       acenderColuna(coluna+1,3,3); 
       acenderColuna(coluna+2); 
       break;
    case 'b':
    case 'B':
      acenderColuna(coluna);
      acenderColuna(coluna+1,1,1); 
      acenderColuna(coluna+1,3,3); 
      acenderColuna(coluna+1,5,5); 
      acenderColuna(coluna+2,2,2); 
      acenderColuna(coluna+2,4,4); 
      break;
    case 'c':
    case 'C':
      acenderColuna(coluna);
      acenderColuna(coluna+1,1,1); 
      acenderColuna(coluna+1,5,5); 
      acenderColuna(coluna+2,1,1); 
      acenderColuna(coluna+2,5,5); 
      break;
    case 'd':
    case 'D':
      acenderColuna(coluna);
      acenderColuna(coluna+1,1,1); 
      acenderColuna(coluna+1,5,5); 
      acenderColuna(coluna+2,2,4); 
      break;
    case 'e':
    case 'E':
      acenderColuna(coluna);
      acenderColuna(coluna+1,1,1); 
      acenderColuna(coluna+1,3,3); 
      acenderColuna(coluna+1,5,5); 
      acenderColuna(coluna+2,1,1); 
      acenderColuna(coluna+2,3,3); 
      acenderColuna(coluna+2,5,5); 
      break;
    case 'f':
    case 'F':
      acenderColuna(coluna);
      acenderColuna(coluna+1,1,1); 
      acenderColuna(coluna+1,3,3); 
      acenderColuna(coluna+2,1,1); 
      acenderColuna(coluna+2,3,3); 
      break;
    case 'g':
    case 'G':
      acenderSimbolo('6', coluna); 
      break;
    case 'h':
    case 'H':
      acenderColuna(coluna);
      acenderColuna(coluna+1,3,3); 
      acenderColuna(coluna+2); 
      break;
    case 'i':
    case 'I':
      acenderColuna(coluna,1,1);
      acenderColuna(coluna,5,5);
      acenderColuna(coluna+1); 
      acenderColuna(coluna+2,1,1);
      acenderColuna(coluna+2,5,5);
      break;
    case 'j':
    case 'J':
      acenderColuna(coluna,1,1);
      acenderColuna(coluna,4,4);
      acenderColuna(coluna,5,5);
      acenderColuna(coluna+1); 
      acenderColuna(coluna+2,1,1); 
      break;
    case 'k':
    case 'K':
      acenderColuna(coluna);
      acenderColuna(coluna+1,3,3);
      acenderColuna(coluna+2,1,1);
      acenderColuna(coluna+2,2,2); 
      acenderColuna(coluna+2,4,4); 
      acenderColuna(coluna+2,5,5); 
      break;
    case 'l':
    case 'L':
      acenderColuna(coluna);
      acenderColuna(coluna+1,5,5); 
      acenderColuna(coluna+2,5,5); 
      break;
    case 'm':
    case 'M':
      acenderColuna(coluna);
      acenderColuna(coluna+1,2,3); 
      acenderColuna(coluna+2); 
      break;
    case 'n':
    case 'N':
      acenderColuna(coluna);
      acenderColuna(coluna+1,2,4); 
      acenderColuna(coluna+2); 
      break;
    case 'o':
    case 'O':
      acenderColuna(coluna);
      acenderColuna(coluna+1,1,1); 
      acenderColuna(coluna+1,5,5); 
      acenderColuna(coluna+2); 
      break;
    case 'p':
    case 'P':
      acenderColuna(coluna);
      acenderColuna(coluna+1,1,1); 
      acenderColuna(coluna+1,3,3); 
      acenderColuna(coluna+2,1,3); 
      break;
    case 'q':
    case 'Q':
      acenderColuna(coluna,1,3); 
      acenderColuna(coluna+1,1,1);
      acenderColuna(coluna+1,3,3); 
      acenderColuna(coluna+2); 
      break;
    case 'r':
    case 'R':
      acenderColuna(coluna);
      acenderColuna(coluna+1,1,1); 
      acenderColuna(coluna+1,3,4); 
      acenderColuna(coluna+2,1,1); 
      acenderColuna(coluna+2,2,3); 
      acenderColuna(coluna+2,5,5); 
      break;
    case 's':
    case 'S':
      acenderColuna(coluna,1,1); 
      acenderColuna(coluna,2,2); 
      acenderColuna(coluna,3,3); 
      acenderColuna(coluna,5,5); 
      acenderColuna(coluna+1,1,1); 
      acenderColuna(coluna+1,3,3); 
      acenderColuna(coluna+1,5,5); 
      acenderColuna(coluna+2,1,1); 
      acenderColuna(coluna+2,3,3); 
      acenderColuna(coluna+2,4,4); 
      acenderColuna(coluna+2,5,5); 
      break;
    case 't':
    case 'T':
      acenderColuna(coluna,1,1);
      acenderColuna(coluna+1); 
      acenderColuna(coluna+2,1,1);
      break;
    case 'u':
    case 'U':
      acenderColuna(coluna);
      acenderColuna(coluna+1,5,5);
      acenderColuna(coluna+2); 
      break;
    case 'v':
    case 'V':
      acenderColuna(coluna,1,4);
      acenderColuna(coluna+1,5,5);
      acenderColuna(coluna+2,1,4); 
      break;
    case 'w':
    case 'W':
      acenderColuna(coluna);
      acenderColuna(coluna+1,3,4); 
      acenderColuna(coluna+2); 
      break;
    case 'x':
    case 'X':
      acenderColuna(coluna,1,2);
      acenderColuna(coluna,4,5); 
      acenderColuna(coluna+1,3,3);
      acenderColuna(coluna+2,1,2);
      acenderColuna(coluna+2,4,5); 
      break;
    case 'y':
    case 'Y':
      acenderColuna(coluna,1,2);
      acenderColuna(coluna+1,3,5);
      acenderColuna(coluna+2,1,2);
      break;
    case 'z':
    case 'Z':
      acenderColuna(coluna,1,1); 
      acenderColuna(coluna,4,5); 
      acenderColuna(coluna+1,1,1); 
      acenderColuna(coluna+1,3,3); 
      acenderColuna(coluna+1,5,5); 
      acenderColuna(coluna+2,1,2); 
      acenderColuna(coluna+2,5,5); 
      break;
    case ' ':
      delay(delayRolar);
      delay(delayRolar);
      break;
    case '!':
      acenderColuna(coluna,1,3); 
      acenderColuna(coluna,5,5); 
      break;
    case '<':
      acenderColuna(coluna+2,1,1); 
      acenderColuna(coluna+1,2,2); 
      acenderColuna(coluna,3,3); 
      acenderColuna(coluna+1,3,3); 
      acenderColuna(coluna+2,3,3); 
      acenderColuna(coluna+3,3,3); 
      acenderColuna(coluna+1,4,4); 
      acenderColuna(coluna+2,5,5); 
      break;
    default://coracao
      acenderColuna(coluna,2,2); 
      acenderColuna(coluna,3,3); 
      acenderColuna(coluna+1,1,1); 
      acenderColuna(coluna+1,4,4); 
      acenderColuna(coluna+2,2,2); 
      acenderColuna(coluna+2,5,5); 
      acenderColuna(coluna+3,1,1); 
      acenderColuna(coluna+3,4,4); 
      acenderColuna(coluna+4,2,2); 
      acenderColuna(coluna+4,3,3); 
  }
}


void acenderPonto(int linha, int coluna) {
  digitalWrite(linha,HIGH); // Enable entire ROW
  digitalWrite(coluna,LOW); // gets turned on
  delayMicroseconds(delayGeral); // for a moment
  digitalWrite(coluna,HIGH); // then OFF
  digitalWrite(linha, LOW); // We're done with this row 
}  

