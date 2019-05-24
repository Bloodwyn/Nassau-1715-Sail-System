params[
	["_obj", BW_cship, [objNull]],
	["_point", "", [""]]
];

private _ropes = _obj getVariable ["ropes",[]];

if(_ropes isEqualTo [])exitWith{};

private _index = -1;
{
	if(_x#0 isEqualTo _point)exitWith{_index = _foreachindex};
} forEach _ropes;

if(_index<0)exitWith{};

private _ropeData = _ropes#_index;
ropeDestroy (_ropedata#1);

private _otherObj = _ropeData#2;
_otherPoint = _ropeData#3;

_ropes deleteAt _index;
_obj setVariable ["ropes",_ropes,true];

private _ropesOther = _otherObj getVariable ["ropes",[]];
if(_ropesOther isEqualTo [])exitWith{};
_index = -1;
{
	if(_x#0 isEqualTo _otherPoint)exitWith{_index = _foreachindex};
} forEach _ropesOther;

_ropesOther deleteAt _index;
_otherObj setVariable ["ropes",_ropesOther,true];