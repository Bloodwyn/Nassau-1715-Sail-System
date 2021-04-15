private _boat = param [0, objNull, [objNull]];

if(isNull _boat)exitWith{false};
private _ship = attachedTo _boat;
if(isNull _ship)exitWith{false;};

// is the child slot occupied by another boat?
private _cfg = configFile >> "CfgVehicles" >> typeOf _ship >> "BoatAttachPositions";
if(isNull _cfg)exitWith{true;}; // seems to be a custom position
private _attachedBoats = (attachedObjects _ship) select {_x isKindOf "ship"};
private _points = _cfg call BIS_fnc_getCfgSubClasses;

private _boatInModelSpace = _ship worldToModelVisual (asltoagl getPosWorldVisual _boat);	//this seems to be the most precise way of finding the attachTo offset

private _possiblePoints = _points select {
	private _pos = [_cfg,_x] call BW_sail_fnc_getBoatPos;
	_boatInModelSpace distance _pos < 0.01;	// boat is nearby a defined memory point
};

if(_possiblePoints isEqualTo [])exitWith{true;}; // seems to be a custom position

private _point = _possiblePoints#0;

private _childs = _points select {
	(getText (_cfg >> _x >> "parent")) isEqualTo _point;
};

if !(_childs isEqualTo [])then{
	private _child = _childs#0;
	private _pos = [_cfg,_child] call BW_sail_fnc_getBoatPos;
	(({									
		(_ship worldToModelVisual (asltoagl getPosWorldVisual _x)) distance _pos < 0.01;
	} count _attachedBoats) isEqualTo 0);
}else{
	true;
};