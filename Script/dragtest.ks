// an attempt to calculate the drag coefficient of a vessel
// from the difference between expected and actual acceleration


SAS ON.
SET SASMODE TO "STABILITYASSIST".

//LOCK THROTTLE TO 1.
STAGE.

SET t_last TO TIME:SECONDS.
LOCK t_delta TO TIME:SECONDS - t_last.

LOCK aim TO SHIP:FACING:FOREVECTOR.
SET v_last TO SHIP:VELOCITY:ORBIT.
LOCK radius TO SHIP:ALTITUDE + KERBIN:RADIUS.
LOCK f_gravity TO KERBIN:MU * SHIP:MASS / (radius * radius).
LOCK a_rocket TO (SHIP:AVAILABLETHRUST * THROTTLE/ SHIP:MASS).
LOCK a_gravity TO (f_gravity / SHIP:MASS).
LOCK a_expected TO (aim * a_rocket) - (SHIP:UP:FOREVECTOR * a_gravity).
//SET p_0 TO KERBIN:ATM:SEALEVELPRESSURE.
//SET H TO 5600.
//SET p TO p_0 * CONSTANT:E ^ (-SHIP:ALTITUDE / H).
LOCK v_expected TO v_last + (a_expected * t_delta).
LOCK v_actual TO SHIP:VELOCITY:ORBIT.
LOCK v_delta TO v_actual - v_last.
LOCK a_actual TO v_delta / t_delta.
//SET k TO (v_expected - v_actual) / (p * v_actual * v_actual * t_delta).
LOCK a_diff TO (a_expected - a_actual):MAG.

UNTIL SHIP:ALTITUDE > 1000000 {
  PRINT ROUND(SHIP:ALTITUDE, 0) + "|" + ROUND(t_delta, 4) + "|" + ROUND(f_gravity, 4) + "|" + ROUND(v_expected:MAG, 4) + "|" + ROUND(v_actual:MAG, 4) + "|" + ROUND(v_delta:MAG, 4) + "|" + ROUND(a_expected:MAG, 4) + "|" + ROUND(a_actual:MAG, 4) + "|" + ROUND(a_rocket, 4) + "|" + ROUND(a_diff, 4).
  SET v_last TO SHIP:VELOCITY:ORBIT.
  SET t_last TO TIME:SECONDS.
  //SET p TO p_0 * CONSTANT:E ^ (-SHIP:ALTITUDE / H).
  WAIT 0.
}
