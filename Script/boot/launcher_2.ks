@lazyglobal off.
print "Launching LAUNCHER 2".

runoncepath("0:lib/experiments.ks").
runoncepath("0:lib/rtb.ks").

collectPressure(). // on launchpad


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
collectTemperature().
collectPressure().

//returnControlToBase().
local crew to ship:crew[0].
addons:eva:goeva(crew).
wait 2.
local crew_vessel to vessel(crew:name).
local crew_conn to crew_vessel:connection.
crew_conn:sendmessage(ship:name).
crew_conn:sendmessage("eva_report").
crew_conn:sendmessage("store_data").
crew_conn:sendmessage("board").
wait 2.
collectCrewReport().
print "Recover me!".