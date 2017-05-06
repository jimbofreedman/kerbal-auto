// holds a circular orbit

@lazyglobal off.

lock h_orbit to 75000.
lock v_orbit to (kerbin:mu / (kerbin:radius + h_orbit)) ^ 0.5.
lock h to ship:altitude.

lock d_to_apoapsis to 30.
lock t_to_apoapsis to ship:orbit:period * d_to_apoapsis.
lock a_vert to ship:prograde:upvector * 2 * (h_orbit - h - (ship:verticalspeed * t_to_apoapsis)) / t_to_apoapsis ^ 2.
lock a_fwd to ship:prograde:forevector * (v_orbit - ship:velocity:orbit:mag) / t_to_apoapsis.
lock a_total to a_fwd + a_vert.

function getP4ThrustDirection {
    return a_total:direction.
}
function getP4Throttle {
    local ret to min(1, a_total:mag * ship:mass / ship:availablethrust).
    print round(h) + " " + round(d_to_apoapsis, 4) + " " + round(t_to_apoapsis, 2) + " " + round(ship:orbit:apoapsis) + " "
            + round(ship:orbit:periapsis) + " " + round(ship:velocity:orbit:mag, 2) + " "
            + round(v_orbit - ship:velocity:orbit:mag, 2) + " " + round(a_fwd:mag, 2) +  " " + round(a_vert:mag, 2)
            + " " + round(a_total:mag, 2) + " " + round(ret, 2).
    return ret.
}

global elist to 1.
list engines in elist.

lock steering to getP4ThrustDirection().
lock throttle to getP4Throttle().

print "Orbiting".

function chargeUp {
    print "Engine running".
    elist[0]:activate().
    wait until ship:orbit:periapsis >= h_orbit * 0.99 and ship:orbit:apoapsis >= h_orbit * 0.99 and ship:electriccharge > 49.9.
    print "Orbit stable and battery charged - shutting down engine".
    runDown().
}

function runDown {
    elist[0]:shutdown().
    wait until ship:electricharge < 10.
    print "Low battery - starting engine".
    chargeUp().
}

chargeUp().