@lazyglobal on.


sas on.
set sasmode to "STABILITYASSIST".

global waypoint to latlng(-0.092057853937149, -74.6620864868164).

stage.

set steeringmanager:rolltorquefactor to 500.
lock steering to heading(waypoint:heading, 0).
lock throttle to 1.
wait until ship:velocity:surface:mag > 5.
lock throttle to 0.02.

wait until waypoint:distance < 20.

lock throttle to 0.00.
set brakes to true.

local partlist to 1.
list parts in partlist.
for part in partlist {
    local modulelist to part:modules.
    for module in modulelist {
        if (module = "ModuleScienceExperiment") {
            local science_module to part:getmodule("ModuleScienceExperiment").
            science_module:deploy().
        }
    }
}

wait until ship:altitude > 10000.