params[
	["_obj", BW_cship, [objNull]],
	["_point", "", [""]]
];

private _ropes = _obj getVariable ["ropes",[]];

if(_ropes isEqualTo [])exitWith{false};

if({_x#0 isEqualTo _point}count _ropes > 0)exitWith{true;};
false;