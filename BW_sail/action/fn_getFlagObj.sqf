params [
	["_ship",BW_cship,[objNull]],
	["_memoryPoint","",[""]]
];

private _flagConfig = configFile >> "CfgVehicles" >> typeof _ship >> "1715_Flags";
if(isNull _flagConfig)exitWith{
	["No flag config available for this object: (%1)",typeof _ship] call BIS_fnc_error;
};
private _flagType = getText (_flagConfig >> _memoryPoint >> "flagtype");

if(_flagType isEqualTo "")exitWith{
	["No flag type available for this object: (%1) (%2)",typeof _ship, _memoryPoint] call BIS_fnc_error;
};

private _offset = getArray (_flagConfig >> _memoryPoint >> "offset");
if(_offset isEqualTo [])then{
	_offset = [0,0,0];
};

private _parentClassName = configName (inheritsFrom (configFile >> "CfgVehicles" >> _flagType));

[_ship, _memoryPoint, _offset, (attachedObjects _ship) select {_x isKindOf _parentClassName}] call BW_sail_fnc_getAttachedObj;