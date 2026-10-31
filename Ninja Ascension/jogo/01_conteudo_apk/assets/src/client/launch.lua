local launch_terminal = {
    _name = "launch_logo",
    _init = function (terminal) print("launch game, show game logo.") end,
    _inited = false,
    _instance = nil,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:open(app.load("client.login.logo"), fwin._screen) 
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
app.state_machine.add(launch_terminal)
app.state_machine.init()
app.state_machine.excute("launch_logo", 0, "show 'logo' for game")