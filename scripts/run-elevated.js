var args = WScript.Arguments;
if(args.length == 0){
    WScript.Echo("nothing to run");
    WScript.Quit(0);
}

var quoted_args = [];
for(var i = 1; i < args.length; ++i){
    var arg = args(i); // it's a callable, not array like
    if(arg.indexOf(" ") != -1){
        arg = "\"" + arg + "\"";
    }
    quoted_args.push(arg);
}

var SHAPP = WScript.CreateObject("shell.application");
SHAPP.ShellExecute(args(0), quoted_args.join(" "), "", "runas", 1);
