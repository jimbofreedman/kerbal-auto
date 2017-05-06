@lazyglobal off.
print "Launching LAUNCHER to get science from pad".

runoncepath("0:lib/experiments.ks").
runoncepath("0:lib/rtb.ks").


collectCrewReport().
collectGoo(4).

returnControlToBase().

// todo: EVA (and therefore storage)