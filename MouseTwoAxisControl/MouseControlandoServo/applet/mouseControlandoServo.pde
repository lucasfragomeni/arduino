#include <ps2.h>
#include <Servo.h>

/*
 * an arduino sketch to interface with a ps/2 mouse.
 * Also uses serial protocol to talk back to the host
 * and report what it finds.
 */

/*
 * Pin 5 is the mouse data pin, pin 6 is the clock pin
 * Feel free to use whatever pins are convenient.
 */
PS2 mouse(6, 5);

Servo servoX;
Servo servoY;

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
  mouse_init();
  servoX.attach(9);
  servoY.attach(10);
}

int xGlobal = 0;
int yGlobal = 0;
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

  xGlobal = xGlobal + mx;
  yGlobal = yGlobal + my;
  
  int valX = map(xGlobal, 50, -50, 0, 179);
  servoX.write(valX);
    
  delay(20);
   
  int valY = map(yGlobal, 50, -50, 60, 179);
  servoY.write(valY);
  
  /* send the data back up */
  Serial.print(mstat, BIN);
  Serial.print("\tX=");
  Serial.print(xGlobal, DEC);
  Serial.print("\tY=");
  Serial.print(yGlobal, DEC);
  Serial.println();
//  delay(20);  /* twiddle */
}
