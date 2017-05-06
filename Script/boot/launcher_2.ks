@lazyglobal off.
print "Launching LAUNCHER 2".

runoncepath("0:lib/experiments.ks").
runoncepath("0:lib/rtb.ks").


lock steering to heading(270, 45).

stage.
print "Taking off".
global elist to 0.
list engines in elist.


wait until elist[0]:flameout.
print "Ditching engine".
stage.

when ship:altitude < 50 then {
    print "At 50m descending, performing low flying grassland science".
    collectCrewReport().
    collectTemperature().
    collectPressure().
}

wait until ship:verticalspeed < 0.
print "Deploying chute".
stage.
wait until ship:status = "LANDED".
print "Performing landed science".
collectGoo(3).

//returnControlToBase().

print "Before you recover me, please take a splashed EVA report, a splashed thermometer reading, a splashed pressure reading, and a splashed crew report".
print "Then basic rocketry, general rocketry and stability".
print "Then take contracts to escape the atmosphere and orbit Kerbin".