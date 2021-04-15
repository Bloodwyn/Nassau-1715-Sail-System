/*
	Author: Bloodwyn http://steamcommunity.com/profiles/76561198055205907/

	retuns:
	"" when no spot is available, "memoryPoint", [position in modelspace]
*/

params [
	["_boat", objNull, [objNull]],
	["_ship", BW_cship, [objNull]]
];

if(isNull _boat)exitWith{"";};
if(isNull _ship)exitWith{"";};

if !(isNull (attachedTo _boat))exitWith{""};

private _cfg = configFile >> "CfgVehicles" >> typeOf _ship >> "BoatAttachPositions";
if(isNull _cfg)exitWith{""};
private _attachedBoats = (attachedObjects _ship) select {_x isKindOf "ship"};
private _points = _cfg call BIS_fnc_getCfgSubClasses;


//find all points where no boat is attached
private _freePoints = _points select {
	private _pos = [_cfg,_x] call BW_sail_fnc_getBoatPos;
	[_cfg,_x] call BW_sail_fnc_getBoatPos;
	({									
		(_ship worldToModelVisual (asltoagl getPosWorldVisual _x)) distance _pos < 0.01	//this seems to be the most precise way of finding the attachTo offset
	} count _attachedBoats) isEqualTo 0;//0 boats are nearby
};

private _occupied = _points - _freePoints;

private _availablePoints = _freePoints select {
	private _parent = getText (_cfg >> _x >> "parent");
	if !(_parent isEqualTo "")then{	//there is a parent
		// there is a boat in the parent so the current free point is usable (e.g. boat can be stacked ontop of the other boat)
		if(_parent in _occupied)then{
			_parentPos = [_cfg,_parent] call BW_sail_fnc_getBoatPos;
			private _parentBoatObj = (_attachedBoats select {
				(_ship worldToModelVisual (asltoagl getPosWorldVisual _x)) distance _parentPos < 0.01
			}) # 0;
			getMass _parentBoatObj >= getMass _boat;
		}else{
			false;
		};
	}else{
		true;
	};
};

if(_availablePoints isEqualTo [])then{
	"";
}else{
	_availablePoints#0;
};