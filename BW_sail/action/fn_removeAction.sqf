params [
	["_obj", objNull, [objNull]],
	["_key", "NullKey", [""]]
];

if(isNull _obj)exitWith{};

private _actions = _obj getVariable ["BW_actions",[]];

_actions = [_actions,_key,1] call BW_sail_fnc_removeKey;

_obj setVariable ["BW_actions",_actions];