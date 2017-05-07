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

when ship:altitude > 2300 then {
    collectPressure().
}

when ship:altitude < 50 then {
    print "At 50m descending, performing low flying ocean science".
    collectCrewReport().
    collectTemperature().
}

wait until ship:verticalspeed < 0.
print "Deploying chute".
stage.
wait until ship:status = "SPLASHED".
print "Performing ocean science".
collectGoo(3).
collectTemperature().
collectPressure().
wait 3.
//returnControlToBase().
local crew to ship:crew[0].
addons:eva:goeva(crew).
wait 2.
local crew_vessel to vessel(crew:name).
local crew_conn to crew_vessel:connection.
crew_conn:sendmessage(ship:name).
wait 1.
crew_conn:sendmessage("eva_report").
wait 1.
crew_conn:sendmessage("store_data").
wait 1.
crew_conn:sendmessage("board").
wait 2.
collectCrewReport().
print "Recover me!".


//returnControlToBase().

//print "Then research survivability and launch launcher 2 MANUALLY".
//print "For launcher 2, take and store a barometer reading on the launch pad before take-off, then run launcher2.ks".
// todo: EVA (and therefore storage), ocean crew report (landed @ocean crew report?)