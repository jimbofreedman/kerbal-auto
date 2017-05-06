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

LOCK h TO SHIP:ALTITUDE.
SET h_end TO 71000.
SET h_start TO 0.
LOCK h_peri TO SHIP:ORBIT:PERIAPSIS.
LOCK h_apo TO SHIP:ORBIT:APOAPSIS.
SET v_end TO 2293.8.

LOCK z TO (h_end - h_apo)/(h_end - h_start).
LOCK z_2 TO (h_end - h)/(h_end - h_start).
FUNCTION GET_V_IDEAL {
  IF h >= h_end {
    RETURN v_end.
  } ELSE {
    RETURN v_end * (1 - (z_2 ^ 2)).
  }
}
LOCK v_ideal TO GET_V_IDEAL().
LOCK v TO SHIP:VELOCITY:ORBIT:MAG.


// circularization burn
LOCK cb_v TO v_end - v.
LOCK cb_a TO SHIP:AVAILABLETHRUST / SHIP:MASS.
LOCK cb_t TO cb_v / cb_a.
LOCK cb_total_degrees TO SHIP:ORBIT:PERIOD / cb_t.
//LOCK cb_start_degrees TO 180 - cb_degrees // apoapsis is at 180 degrees

SET downrange_distance TO 2 * CONSTANT:PI * KERBIN:RADIUS / 4.

LOCK time_to_fake_apo TO SHIP:ORBIT:PERIOD * (180 - SHIP:ORBIT:MEANANOMALYATEPOCH) / 360.
LOCK height_to_apoapsis TO h_end - h_apo.
LOCK height_to_altitude TO h_end - h.
LOCK velocity_to_apoapsis TO v_end - v.

SET surf_v_turn_start TO 50.
LOCK surf_v TO SHIP:VELOCITY:SURFACE:MAG.
LOCK actual_aoa TO SHIP:FACING:YAW - 180.

FUNCTION GET_AOA {
  IF (h_apo >= h_end AND SHIP:VERTICALSPEED > 0) {
    // we need to kill vertical velocity
    SET vert_v TO SHIP:VERTICALSPEED.
    //SET inner_aoa TO -(h_end - h-).
    SET h_overshoot TO h_end - h_apo.
    SET v_overshoot TO vert_v + (h_overshoot / time_to_fake_apo).
    SET inner_aoa TO -min(10 * v_overshoot ^ 3, 90).
    PRINT ROUND(h) + " APO OVERSHOOT " + ROUND(h_apo) + " " + ROUND(h_overshoot) + " " + ROUND(v_overshoot, 5) + " " + ROUND(inner_aoa, 5).
    RETURN inner_aoa.
  } ELSE {
    SET ratio1 TO ((h_end - h) / h_end).
    IF (ratio1 >= 0) {
      SET ratio TO ratio1 ^ 5.
    } ELSE {
      SET ratio TO ratio1.
    }
    PRINT ROUND(h) + " " + ROUND(h_end - h) + " " + ROUND(ratio, 5) + " " + ROUND(ratio * 90, 5) + " " + ROUND(actual_aoa, 5) + " " + ROUND(actual_aoa - (ratio * 90)).
    RETURN ratio * 90.
  }
}
LOCK aoa TO GET_AOA().
LOCK aoa_diff TO ABS(aoa - actual_aoa).

FUNCTION GET_STEERING {
  IF surf_v < surf_v_turn_start {
    RETURN HEADING(90, 90).
  } ELSE IF h = h_end {
    RETURN HEADING(90, 0).
  } ELSE {
    RETURN HEADING(90, aoa).
  }
}
LOCK STEERING TO GET_STEERING().

FUNCTION GET_THROTTLE {
  IF (time_to_fake_apo = 0) {
    RETURN 0.
  }

  SET accel_required TO MAX(1, (velocity_to_apoapsis / time_to_fake_apo)).
  SET thrust_required TO (accel_required * SHIP:MASS).
  SET throt TO thrust_required / SHIP:AVAILABLETHRUST.
  PRINT ROUND(h) + " " + ROUND(SHIP:ORBIT:MEANANOMALYATEPOCH) + " " + ROUND(SHIP:ORBIT:PERIOD) + " " + ROUND(time_to_fake_apo) + " " + ROUND(height_to_apoapsis) + " " + ROUND(height_to_altitude) + " " + ROUND(velocity_to_apoapsis) + " " + ROUND(accel_required, 2) + " " + ROUND(thrust_required, 2) + " " + ROUND(throt, 2).
  IF (throt > 1) {
    RETURN 1.
  } ELSE IF (throt < 0) {
    RETURN 0.
  } ELSE {
    RETURN throt.
  }
}
LOCK THROTTLE TO GET_THROTTLE().

FUNCTION DISABLEDAA {
  LOCK THROTTLE TO 0.02.
  STAGE.

  WHEN STAGE:SOLIDFUEL < 0.05 THEN {
    PRINT "BOOSTERS EMPTY".
    UNLOCK THROTTLE.
    LOCK THROTTLE TO GET_THROTTLE().
    WAIT 0.3.
    STAGE.

    WHEN STAGE:LIQUIDFUEL < 0.05 THEN {
      STAGE.
    }
  }
}

WAIT UNTIL (h_peri = h_end AND h_apo = h_end AND v = v_end).
LOCK THROTTLE TO 0.
PRINT "IN ORBIT".
