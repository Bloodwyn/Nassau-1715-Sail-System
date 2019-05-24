params[
	["_obj", objNull, [objNull]],
	["_point", "", [""]]
];

if(isNull _obj)exitWith{};
if!(BW_sail_ropeMode isEqualTo [])exitWith{};

private _ropes = _obj getVariable ["ropes",[]];
{
	if(_x#0 isEqualTo _point)exitWith{
		[_obj,_point] call BW_sail_fnc_removeRope;
		_obj = _x#2;
		_point = _x#3;
	};
} count _ropes;

private _logic = "1715_ropeLogic" createVehicle [0,0,0];
_logic attachTo [player,[0,0,0], "righthand"];

private _length = ((_obj modelToWorldVisual (_obj selectionPosition _point)) distance _logic) + 10;

private _rope = ropeCreate[_obj,_point,_logic,[0,0,0],_length];

BW_sail_ropeMode = [_obj,_point,_logic,_rope];