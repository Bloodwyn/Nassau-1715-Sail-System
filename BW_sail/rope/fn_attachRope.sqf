params[
	["_obj1", BW_cship, [objNull]],
	["_point1", "", [""]],
	["_obj2", BW_cship, [objNull]],
	["_point2", "", [""]]
];

if(!(_this call BW_sail_fnc_canAttachRope))exitWith{};

private _r = ropeCreate [_obj1,_point1,_obj2,_point2];

private _ropedata = _obj1 getVariable ["ropes",[]];
_ropedata pushBack [_point1,_r,_obj2,_point2];
_obj1 setVariable ["ropes",_ropedata,true];

_ropedata = _obj2 getVariable ["ropes",[]];
_ropedata pushBack [_point2,_r,_obj1,_point1];
_obj2 setVariable ["ropes",_ropedata];