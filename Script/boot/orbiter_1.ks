runoncepath("0:lib/experiments.ks").
runoncepath("0:lib/launch.ks").
runoncepath("0:lib/deorbit.ks").

function longitudeNear {
    parameter lng.
    return abs(lng - ship:longitude) < 0.3.
}

// function setupExperimentTrigger {
//   parameter lng.
//   when ship:altitude > 70000 and longitudeNear(lng) then {
//       collectTemperature().//
//       collectPressure().
//   }
//}


// high altitude
when ship:altitude > 30000 then {
    collectTemperature().
    collectPressure().
    collectGoo(2).
}

// space
when ship:altitude > 70000 then {
    collectTemperature().
    collectPressure().
    collectCrewReport().
    collectGoo(3).
}



launch(70100).
deorbit().
