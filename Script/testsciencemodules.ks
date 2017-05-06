// loop through all science modules - run them if we can

@lazyglobal off.

local partlist to 1.
list parts in partlist.
for part in partlist {
    local modulelist to part:modules.
    for module in modulelist {
        if (module = "ModuleScienceExperiment") {
            print part:title.
        }
    }
}