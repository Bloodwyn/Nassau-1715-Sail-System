params [
	["_obj", objNull, [objNull]],
	["_displayName", "Action", [""]],
	["_picture", "", [""]],
	["_condition", "true", [""]],
	["_statement", "", [""]],
	["_position", "", ["",[]], 3],
	["_radius", 3, [0]],
	["_drag", [], [[]], [0,2]],
	["_key", format["%1%2%3",diag_frameno, diag_tickTime, random 1], [""]]
];

if(isNull _obj)exitWith{};


private _actions = _obj getVariable ["BW_actions",[]];

private _newAction = [_key,_displayName,_picture,_condition,_statement,_position,_radius,_drag];

_actions = [_actions,_newAction] call BW_sail_fnc_addOrReplaceKey;

_obj setVariable ["BW_actions",_actions];
