// launches the vessel into orbit with eccentricity 0

@lazyglobal off.
//set steeringmanager:showfacingvectors to true.
//set steeringmanager:showangularvectors to true.
//set steeringmanager:showsteeringstats to true.

global aoa_orbit to 0.
global aoaToDirection to heading@:bind(90).

global h_orbit to 70500.
lock v_orbit to (kerbin:mu / (kerbin:radius + h_orbit)) ^ 0.5.
lock h to ship:altitude.

global v_p2_start to 50.
global h_p2_start to 0.
global h_p3_start to 10000.
global aoa_p2_start to 90.
global aoa_p3_start to 45.
global p23_aoa_power to 2.

function getP2Aoa {
    local progress to h / (h_p3_start - h_p2_start).
    local ratio to 1 - (1 - progress) ^ p23_aoa_power.
    local ret to aoa_p2_start - (ratio * (aoa_p2_start - aoa_p3_start)).
    print round(h) + " " + round(progress * 100) + "% " + round(ratio, 3) + " " + round(ret).
    return ret.
}

function getP3Aoa {
    local progress to h / (h_p3_start - h_p2_start).
    local ratio to 1 - (1 - progress) ^ p23_aoa_power.
    local ret to aoa_p2_start - (ratio * (aoa_p2_start - aoa_p3_start)).
    print round(h) + " " + round(progress * 100) + "% " + round(ratio, 3) + " " + round(ret).
    return ret.
}

lock d_to_apoapsis to (180 - ship:orbit:meananomalyatepoch) / 360.
lock t_to_apoapsis to ship:orbit:period * d_to_apoapsis.
//lock s_latitudinal to ship:latitude * (kerbin:radius + h) / 360.
//global t0 to time:seconds.
//global s_lat0 to ship:latitude.
//lock dt to time:seconds - t0.
//lock v_lat to (ship:latitude - s_lat0) / dt.
//lock a_side to ship:prograde:starvector * 2 * (-s_latitudinal - (v_lat * t_to_apoapsis)) / t_to_apoapsis ^ 2.
lock a_vert to ship:prograde:upvector * 2 * (h_orbit - h - (ship:verticalspeed * t_to_apoapsis)) / t_to_apoapsis ^ 2.
lock a_fwd to ship:prograde:forevector * (v_orbit - ship:velocity:orbit:mag) / t_to_apoapsis.
lock a_total to a_fwd + a_vert.
function getP4ThrustDirection {
    //local dir to a_total:direction.
    //set t0 to time:seconds.
    //set s_lat0 to ship:latitude.
    //print round(dir:pitch, 4) + " " + round(dir:yaw, 4) + " " + round(dir:roll, 4) + " ---- " + dir.
    //return dir.
    return a_total:direction.
}

function getP4Throttle {
    local ret to min(1, a_total:mag * ship:mass / ship:availablethrust).
    print round(h) + " " + round(d_to_apoapsis, 4) + " " + round(t_to_apoapsis, 2) + " " + round(ship:orbit:apoapsis) + " "
          + round(ship:orbit:periapsis) + " " + round(ship:velocity:orbit:mag, 2) + " "
          + round(v_orbit - ship:velocity:orbit:mag, 2)
          + " " + round(a_total:mag, 2) + " " + round(ret, 2) + " " + ship:longitude + " " + ship:latitude + " " + round(a_fwd:mag, 4) + round(a_vert:mag, 4).
    return ret.
}

// todo set twr
// verify crew


function boostersDead {
    for engine in engine_list {
        if engine:ignition and not engine:flameout {
            return false.
        }
    }
    return true.
}

function launch {
    parameter apoapsis.
    set h_orbit to apoapsis.

    print "Heading for a circular orbit at altitude " + round(h_orbit) + "km and velocity " + round(v_orbit, 3) + " m/s".
    lock p1_over to ship:velocity:surface:mag > v_p2_start.
    if not p1_over {
        set steeringmanager:pitchtorquefactor to 20.
        lock steering to aoaToDirection(90).
        lock throttle to 1.
        stage.
    //set kuniverse:timewarp:rate to 3.
        print("Beginning P1 Lift-Off").
        wait until p1_over.
    }

    lock p2_over to true.
    //if not p2_over {
    //    print("v>50m/s - Beginning P2 Tip-Over 1").
    //    lock steering to aoaToDirection(getP2Aoa()).
    //    wait until h > 10000.
    //}

    global engine_list to 1.
    list engines in engine_list.

    lock boosters_dead to boostersDead().
    lock p3_over to p2_over and (stage:number = 1 or boosters_dead).
    if not p3_over {
        print("h=10km - Beginning P3 Tip-Over 2").
        lock steering to aoaToDirection(getP3Aoa()).
        wait until boosters_dead.
        print "h=" + round(h) + " v=" + round(ship:velocity:orbit:mag) + " - boosters empty".
        lock throttle to 0.2.
        stage.
        wait until stage:ready.
        wait until ship:availablethrust > 0.
        wait until p3_over.
    }

    lock p4_over to ship:orbit:periapsis >= 70000 and ship:orbit:apoapsis >= 70000.
    if not p4_over {
        print("Boosters empty - Beginning P4 Circularization").
        set kuniverse:timewarp:rate to 4.
        lock steering to getP4ThrustDirection().
        lock throttle to getP4Throttle().

//        when (stage:liquidfuel < 0.05) then {
//            lock throttle to 0.1.
//            stage.
//            wait until stage:ready.
//            lock throttle to getP4Throttle().
//        }

        wait until p4_over.
    }

    print("Launch complete").
}