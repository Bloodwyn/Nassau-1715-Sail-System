params[
	["_ship", BW_anker, [objNull]],
	["_star", true,[true]],
	["_anchPos","",[[],""],3],
	["_ropePos","",[[],""],3]
];

if(_star && (!isnull ((_ship getVariable["anchorobjs",[objNull,objNull,objNull,objNull]])#0)))exitWith{};
if(!_star && (!isnull ((_ship getVariable["anchorobjs",[objNull,objNull,objNull,objNull]])#2)))exitWith{};

if(_anchPos isEqualType "")then{
	_anchPos = _ship selectionPosition _anchPos;
};

if(_ropePos isEqualType "")then{
	_ropePos = _ship selectionPosition _anchPos;
};

if((_anchPos distance [0,0,0]) < 0.1)then{
	private _f = [-1,1] select _star;
	_anchPos = [_f * 2.8,4.2,-12.6];
};

if((_ropePos distance [0,0,0]) < 0.1)then{
	private _f = [-1,1] select _star;
	_ropePos = [_f * 2.8,4.2,-12.6];
};

private _dir = -110;

private _anch = "1715_sloop_anchor" createVehicle [0,0,0];
private _anchStartWeight = getMass _anch;

_anch disableCollisionWith _ship;
[_ship, _anch] remoteExecCall ["disableCollisionWith", _ship];
_anch setposasl (_ship modelToWorldVisual _anchPos);
_anch setdir (direction _ship +_dir);
_anch setVelocity (velocity _ship vectorMultiply 2);

private _rope = ropeCreate [_ship, _ropePos,_anch, "strap", 2];

[_anch, 2] remoteExecCall ["setOwner", _ship];
[_rope, 2] remoteExecCall ["setOwner", _ship];

private _toSet = _ship getVariable["anchorobjs",[objNull,objNull,objNull,objNull]];
if(_star)then{
	_toSet set [0,_anch];
	_toSet set [1,_rope];
}else{
	_toSet set [2,_anch];
	_toSet set [3,_rope];
};

_ship setVariable["anchorobjs",_toSet,true];

while{ropelength _rope < ( (5 + 3*-(getTerrainHeightASL (getposworld _anch))) min 100 )}do{
	if((getPosatl _anch)#2 > 1)then{ //simulate dragging on seafloor
		_anch setMass _anchStartWeight;
	}else{
		_anch setMass 40000;
	};
	ropeUnwind [_rope,8,1,true];
	sleep .1;
};