@lazyglobal off.
print "Launching LAUNCHER 3".

runoncepath("0:lib/experiments.ks").
runoncepath("0:lib/rtb.ks").


lock steering to heading(90, 45).

stage.
print "Taking off".
global elist to 0.
list engines in elist.


wait until elist[0]:flameout.
print "Ditching engine".
stage.

when ship:altitude < 50 then {
    print "At 50m descending, performing low flying ocean science".
    collectCrewReport().
    collectTemperature().
    collectPressure().
}

wait until ship:verticalspeed < 0.
print "Deploying chute".
stage.
wait until ship:status = "SPLASHED".
print "Performing ocean science".
collectGoo(3).

//returnControlToBase().

print "Before you recover me, please take a landed EVA report, a landed thermometer reading, a landed pressure reading, and a landed crew report".
//print "Then research survivability and launch launcher 2 MANUALLY".
//print "For launcher 2, take and store a barometer reading on the launch pad before take-off, then run launcher2.ks".
// todo: EVA (and therefore storage), ocean crew report (landed @ocean crew report?)