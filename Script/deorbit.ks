// de-orbits a vessel from cLKO
@lazyglobal off.

lock steering to ship:retrograde.
lock throttle to 0.
local elist to 1.
list engines in elist.
elist[0]:activate().

print "Aligning retrograde for deorbit".

set kuniverse:timewarp:rate to 1.

wait until abs(ship:retrograde:pitch - ship:facing:pitch) < 0.1 and abs(ship:retrograde:yaw - ship:facing:yaw) < 0.1.

print "Waiting for correct longitude for landing".

print "Aligned - performing retrograde burn at longitude " + ship:longitude.

lock throttle to 1.
wait until ship:periapsis < 38000.

print "Periapsis established - shutting down engines".

lock throttle to 0.
elist[0]:shutdown().

print "Dropping stages".

until stage:number = 0 {
    stage.
    wait until stage:ready.
}

set kuniverse:timewarp:rate to 4.

wait until ship:status = "LANDED" or ship:status = "SPLASHED".
print "Landed mass + " + round(ship:mass) + " at longitude " + ship:longitude.
