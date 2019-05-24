params[
	["_obj", BW_cship, [objNull]],
	["_point", "", [""]],
	["_lengthen", true, [true]]
];
private _v = if(_lengthen)then[{1},{-1}];

private _ropes = _obj getVariable ["ropes",[]];
{
	if(_x#0 isEqualTo _point)exitWith{
		ropeUnwind[_x#1,1,_v*2,true];
	};
} count _ropes;