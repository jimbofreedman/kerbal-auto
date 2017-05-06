// take off spaceplane then fly straight and level

@lazyglobal off.

global cruise_altitude to 8000. // highest mountain is 6000m
global aoa to 0.
lock steering to r(aoa, 90, 0).
print "Heading set".
global throt to 0.
lock throttle to throt.
print "Throttle 0".
set brakes to true.
print "Brakes on".
stage.
print "Starting engine".
wait until stage:ready.
print "Engine started".

set throt to 1.0.
print "Throttle up".

wait 10.
print "Engines going".

set brakes to false.

when ship:velocity:surface:mag > 70 then {
    print "AOA 4 degrees".
    set aoa to 4.
}

when ship:altitude > 80 then { // runway at 70m asl
    print "AOA 6 degrees".
    set aoa to 6.
}

when ship:altitude > 90 and ship:velocity:surface:mag > 150 then { // runway at 70m asl
    print "AOA 15 degrees".
    set aoa to 15.
}


wait until ship:altitude > cruise_altitude.
print "At cruise alt".