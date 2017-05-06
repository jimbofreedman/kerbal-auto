CLEARSCREEN.
PRINT "HELLO".

//SAS OFF.
SAS ON.
SET SASMODE TO "STABILITYASSIST".

//PRINT "Counting down:".
//FROM {local countdown is 3.} UNTIL countdown = 0 STEP {SET countdown to countdown - 1.} DO {
//    PRINT "..." + countdown.
//    WAIT 1. // pauses the script here for 1 second.
//}.

PRINT "LIFTOFF".
STAGE.

SET endAlt TO 71000.
SET startAlt TO 0.
//SET endSpeed TO 2290.

//WAIT UNTIL SHIP:ALTITUDE > startAlt.

//PRINT "1000m - START TO STEER".
LOCK z TO (endAlt - SHIP:APOAPSIS)/(endAlt - startAlt).
LOCK angleOfAttack TO z * z * 90.
LOCK STEERING TO HEADING(90, angleOfAttack).
//LOCK STEERING TO HEADING(90, 90).

LOCK THROTTLE TO 0.

WHEN STAGE:SOLIDFUEL < 0.05 THEN {
  PRINT "BOOSTERS EMPTY".
  LOCK THROTTLE TO 0.6.
  WAIT 0.3.
  STAGE.

  WHEN STAGE:LIQUIDFUEL < 0.05 THEN {
    PRINT "STAGE 1 EMPTY".
    WAIT 0.3.
    STAGE.
  }
}

UNTIL SHIP:ALTITUDE > 70000 {
  PRINT angleOfAttack.
  WAIT 1.
}

WAIT UNTIL SHIP:ALTITUDE > 70000.
PRINT "IN ORBIT".
//LOCK THROTTLE TO 0.
