@lazyglobal on.


sas on.
set sasmode to "STABILITYASSIST".


global aoa to 5.
global roll to 0.
lock steering to r(aoa, 90, roll).
global throt to 1.
lock throttle to throt.

global cruise_altitude to 5000.
global level_kp to 0.01.
global level_ki to 0.001.
global level_kd to 0.01.
global level_pid to pidloop(level_kp, level_ki, level_kd).
set level_pid:setpoint to ship:altitude. // vert speed

global turn_kp to 0.01.
global turn_ki to 0.001.
global turn_kd to 0.01.
global turn_pid to pidloop(turn_kp, turn_ki, turn_kd).
global heading_target to 0.
set turn_pid:setpoint to 0. // vert speed

when ship:altitude > cruise_altitude then {
    print "Cruising at " + round(ship:altitude).
    set aoa to aoa + level_pid:update(time:seconds, ship:altitude).
    //set roll to roll + level_pid:update(time:seconds, ship:facing:roll).
}
print "DONE".


function fly_to_waypoint {
    parameter waypoint.

    //lock steering to r(aoa, 0, 0).

    until false {
        print round(aoa) + " " + round(ship:verticalspeed) + " " + round(roll).
        //round(waypoint:heading) + round(ship:facing:yaw) + " " + round(waypoint:distance) + " " +
        set aoa to max(-15, min(aoa + level_pid:update(time:seconds, ship:altitude), 45)).
        set roll to max(-15, min(roll + level_pid:update(time:seconds, ship:facing:roll), 15)).
        wait 0.01.
    }
}


fly_to_waypoint(latlng(30.226, -50.4128)).

wait until ship:altitude > 100000.
