@lazyglobal off.
print "Launching LAUNCHER 1".

runoncepath("0:lib/experiments.ks").
runoncepath("0:lib/rtb.ks").


lock steering to heading(90, 45).

stage.
print "Taking off".
global elist to 0.
list engines in elist.

when ship:altitude > 700 then {
    print "At 700m, performing low flying science".
    collectCrewReport().
    collectGoo(4).
    collectTemperature().
}

wait until elist[0]:flameout.
print "Ditching engine".
stage.
wait until ship:verticalspeed < 0.
print "Deploying chute".
stage.
wait until ship:status = "SPLASHED".
print "Performing splashed science".

collectGoo(3).
collectTemperature().
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
print "Then research survivability and launch launcher 2 MANUALLY".
print "For launcher 2, take and store a barometer reading on the launch pad before take-off, then run launcher2.ks".
// todo: EVA (and therefore storage), ocean crew report (landed @ocean crew report?)