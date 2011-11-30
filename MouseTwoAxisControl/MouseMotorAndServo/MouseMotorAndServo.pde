#include <ps2.h>
#include <Servo.h>

/*
 * an arduino sketch to interface with a ps/2 mouse.
 * Also uses serial protocol to talk back to the host
 * and report what it finds.
 */

/*
 * 
 * Feel free to use whatever pins are convenient.
 */
#define SDIO 5  //Pin 5 is the mouse data pin (laranja)
#define SCLK 6  //pin 6 is the clock pin (branco)

#define SERVO 9 //Saída analógica motor (amarelo)
#define MOTOR 3 //Saída analógica motor

PS2 mouse(SCLK, SDIO);
Servo myservo;

/*
 * initialize the mouse. Reset it, and place it into remote
 * mode, so we can get the encoder data on demand.
 */
void mouse_init()
{
  mouse.write(0xff);  // reset
  mouse.read();  // ack byte
  mouse.read();  // blank */
  mouse.read();  // blank */
  mouse.write(0xf0);  // remote mode
  mouse.read();  // ack
  delayMicroseconds(100);
}

void setup()
{
  Serial.begin(9600);
  myservo.attach(SERVO);
  pinMode(MOTOR, OUTPUT);
  mouse_init();
}

int globalX = 0;
int globalY = 0;

/*
 * get a reading from the mouse and report it back to the
 * host via the serial line.
 */
void loop()
{
  char mstat;
  char mx;
  char my;

  /* get a reading from the mouse */
  mouse.write(0xeb);  // give me data!
  mouse.read();      // ignore ack
  mstat = mouse.read();
  mx = mouse.read();
  my = mouse.read();

  globalX += mx;
  globalY += my;
  
  int valServo = map(globalX, 50, -50, 0, 179);
  myservo.write(valServo);
  int valMotor = map(globalY, -400, 400, 0, 255);
  analogWrite(MOTOR, valMotor);

  /* send the data back up */
  Serial.print(mstat, BIN);
  Serial.print("\tX=");
  Serial.print(globalX, DEC);
  Serial.print("\tY=");
  Serial.print(globalY, DEC);
  Serial.println();
//  delay(20);  /* twiddle */
}
