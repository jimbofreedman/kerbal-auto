runoncepath("0:lib/experiments.ks").
runoncepath("0:lib/launch.ks").
runoncepath("0:lib/deorbit.ks").

local ready_to_launch to false.
local desired_thrust_weight_ratio to 1.

function setThrustWeightRatio {
    parameter twr.
    set desired_thrust_weight_ratio to twr.

    local elist to 0.
    list engines in elist.

    set weight to (ship:mass * kerbin:mu / (kerbin:radius * kerbin:radius)).
    local thrust_per_engine to twr * weight / 3.
    local thrust_percent to thrust_per_engine / 197.90.
    set elist[1]:thrustlimit to thrust_percent.
    set elist[2]:thrustlimit to thrust_percent.
    set elist[3]:thrustlimit to thrust_percent.
}

when not ship:messages:empty then {
    local received to ship:messages:pop.
    print "Sent by " + received:sender_name + " at " + received:sentat.
    print received:content.
    if received.content["type"] = "go" {
        set ready_to_launch to true.
    }
    else if received.content["type"] = "set_twr" {
        setThrustWeightRatio(received.content["value"]).
    }
    else if received.content["type"] = "set_name" {
        set ship:name to received.content["value"].
        print "Vessel now called " + received.content["value"].
    }
}



when ship:altitude > 200 then {
    if desired_thrust_weight_ratio > 1.1 {
        for craft in kuniverse:craftlist() {
            if (craft:name = "test_twr") {
                kuniverse:launchcraft(craft).
                local v to vessel("test_twr").
                local c to v:connection.
                local m to lexicon().
                m:add("type", "set_twr").
                m:add("value", desired_thrust_weight_ratio - 0.1).
                c:send(m).
                set m to lexicon().
                m:add("type", "set_name").
                m:add("value", "test.twr." + ((desired_thrust_weight_ratio - 0.1) * 10)).
                c:send(m).
                set m to lexicon().
                m:add("type", "go").
                c:send(m).
            }
        }
    }
}

when ready_to_launch then {
    launch(70100).
    deorbit().
}

