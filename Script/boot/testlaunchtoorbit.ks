runoncepath("0:lib/launch.ks").
runoncepath("0:lib/deorbit.ks").

set kuniverse:timewarp:mode to "PHYSICS".
set kuniverse:timewarp:warp to 3.

launch(70100).
deorbit().
