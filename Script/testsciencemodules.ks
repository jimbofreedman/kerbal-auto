// take an eva report, reset instruments, take data from pod, store data in pod

@lazyglobal off.

//local partlist to 1.
//list parts in partlist.
//for part in partlist {
//    local modulelist to part:modules.
//    for module in modulelist {
//        if (module = "ModuleScienceExperiment") {
//            print part:title.
//            print module.
//        }
//    }
//}

for module in ship:modulesnamed("ModuleScienceContainer") {
    print "- " + module.
    for event in module:alleventnames {
        print "  - E " + event.
    //module:doevent(event).
    }
    for action in module:allactionnames {
        print "  - A " + action.
        //module:doaction(action, false).
    }
    if module:hasaction("Take Data") {
        print "go go action".
    //module:doaction("Take Data").
    }
    if module:hasevent("Take Data") {
        print "go go event".
    //module:doevent("Take Data").
    }

}
for part in ship:parts {
    for module_name in part:modules {
        local module to part:getmodule(module_name).
        print "- " + module.
        for event in module:allevents {
            print "- E " + event.
        }
        for action in module:allactions {
            print "- A " + action.
        }
    }
}