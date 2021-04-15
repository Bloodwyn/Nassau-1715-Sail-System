params[
	["_boat", objNull, [objNull]],
	["_side", true, [true]]	// true is starboard
];

if !([_boat] call BW_sail_fnc_canWaterBoat)exitWith{};

private _ship = attachedTo _boat;
private _attachPos = _ship worldToModelVisual (getpos _boat);
private _bb = 0 boundingBoxReal _ship;



_x = if(_side)then{1;}else{-1;};
private _startpos = _ship modelToWorldVisualWorld ([_x*15,0,0] vectoradd _attachPos);
private _endpos = getposasl _boat;
_startpos set [2,0];
_endpos set [2,0];


private _line = (lineIntersectsSurfaces [_startpos,_endpos]) select {(_x#3) isEqualTo _ship};

if(_line isEqualto [])exitWith{
	_boat setposasl _startpos;
};

_pos =(_line#0#0) vectoradd ((_line#0#1)vectorMultiply 2.5);
_pos set [2,2];

detach _boat;
_boat setposasl _pos;