params[
	["_unit",objNull,[objNull]],
	["_ship",objNull,[objNull]]
];

if(isNull _unit || isNull _ship)exitWith{};
if(!local _unit)exitWith{
	_this remoteExecCall ["BW_sail_fnc_teleportToHelm",_unit];
};

_unit setposasl (_ship modelToWorldVisualWorld ((_ship selectionPosition "pos_helm") vectoradd [-1.3,0,0]));