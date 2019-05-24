if(BW_sail_ropeMode isEqualTo [])exitWith{};
params[
	["_obj", objNull, [objNull]],
	["_point", "", [""]]
];

if!(isNull _obj)then{
	private _otherObj = BW_sail_ropeMode#0;
	_otherPoint = BW_sail_ropeMode#1;
	if(getMass _otherObj > getMass _obj)then{
		[_otherObj,_otherPoint,_obj,_point] call BW_sail_fnc_attachRope;
	}else{
		[_obj,_point,_otherObj,_otherPoint] call BW_sail_fnc_attachRope;
	};
};

ropeDestroy (BW_sail_ropeMode#3);
deleteVehicle (BW_sail_ropeMode#2);

BW_sail_ropeMode = [];