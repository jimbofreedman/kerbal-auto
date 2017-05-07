runoncepath("0:lib/experiments.ks").
runoncepath("0:lib/launch.ks").
runoncepath("0:lib/deorbit.ks").

// high altitude
when ship:altitude > 30000 then {
    collectTemperature().
    collectPressure().
    collectGoo(2). // 20kg overweight to collect the 3rd goo here.
}

// space
when ship:altitude > 70000 then {
    collectTemperature().
    collectPressure().
    collectCrewReport().
    collectGoo(3).
}



launch(70100).

wait until ship:longitude > 150.

deorbit().
