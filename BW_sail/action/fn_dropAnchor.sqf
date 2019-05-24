params[
	["_ship", BW_anker, [objNull]],
	["_star", true,[true]]
];

if(_star && (!isnull ((_ship getVariable["anchorobjs",[objNull,objNull,objNull,objNull]])#0)))exitWith{};
if(!_star && (!isnull ((_ship getVariable["anchorobjs",[objNull,objNull,objNull,objNull]])#2)))exitWith{};

private _anchPos = [-2.8,4.2,-12.6];
private _ropePos = [-0.88,4.5,-11.5];
private _dir = -110;
if(_star)then{
	_anchPos = [2.8,4.2,-12.6];
	_ropePos = [0.88,4.5,-11.5];
	_dir = -_dir;
};

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