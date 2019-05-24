params[
	["_ship", BW_cship, [objNull]],
	["_show", true, [true]]
];

if(isNull _ship)exitWith{};

if(!local _ship)exitWith{
	_this remoteExecCall ["BW_sail_fnc_showSailDebug",_ship];
};

private _handle = _ship getVariable ["sailHandle",-1];
if(_handle == -1)exitWith{diag_log "No Sail FSM to debug anything"};

_handle setFSMVariable ["_debug", _show];