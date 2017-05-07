@lazyglobal off.

function collectCrewReport {
    local part_list to 1.
    list parts in part_list.
    for part in part_list {
        if part:title = "Mk1 Command Pod" {
            local module to part:getmodule("ModuleScienceExperiment").
            if not module:deployed {
                print "Performing a crew report".
                module:deploy().
                return.
            }
        }
    }
    return false.
}

function collectTemperature {
    local part_list to 1.
    list parts in part_list.
    for part in part_list {
        if part:title = "2HOT Thermometer" {
            local module to part:getmodule("ModuleScienceExperiment").
            if not module:deployed {
                print "Performing a thermometer reading".
                module:deploy().
                return.
            }
        }
    }
    return false.
}

function collectPressure {
    local part_list to 1.
    list parts in part_list.
    for part in part_list {
        if part:title = "PresMat Barometer" {
            local module to part:getmodule("ModuleScienceExperiment").
            if not module:deployed {
                print "Performing an atmospheric pressure reading".
                module:deploy().
                return.
            }
        }
    }
    return false.
}

function collectGoo {
    parameter num_goos.

    local part_list to 1.
    list parts in part_list.
    for part in part_list {
        if num_goos = 0 {
            return true.
        }

        if part:title = "Mystery Goo™ Containment Unit" {
            local module to part:getmodule("ModuleScienceExperiment").
            if not module:deployed {
                print "Performing a Mystery Goo experiment".
                module:deploy().
                set num_goos to num_goos - 1.
            }
        }
    }
    return false.
}

function listAllScienceModules {
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
}