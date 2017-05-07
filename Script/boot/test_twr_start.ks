for craft in kuniverse:craftlist() {
    if (craft:name = "test_twr") {
        kuniverse:launchcraft(craft).
        local v to vessel("test_twr").
        local c to v:connection.
        local m to lexicon().
        m:add("type", "set_twr").
        m:add("value", 2).
        c:send(m).
        set m to lexicon().
        m:add("type", "set_name").
        m:add("value", "test.twr.20").
        c:send(m).
        set m to lexicon().
        m:add("type", "go").
        c:send(m).
    }
}