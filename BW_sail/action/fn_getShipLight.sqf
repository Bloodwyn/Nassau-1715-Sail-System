/*
    Author: Bloodwyn http://steamcommunity.com/profiles/76561198055205907/

    Description:
    Returns the lightsource object(s) (returns array) at the given mrmory point(s)
*/

params[
	["_ship",objNull,[objNull]],
	["_mempos","",["",[]]],
	["_outputNullObj",false,[true]]
];

if(isNull _ship)exitWith{};
if(_mempos isEqualType "" or {count _mempos > 0 and {(_mempos#0) isEqualType 0}})then{
	_mempos = [_mempos];
};
private _lights = _mempos apply {
	private ["_worldPos"];
	if(_x isEqualType "")then{
		_worldPos = _ship modelToWorldVisualWorld (_ship selectionPosition _x);
	}else{
		_worldPos = _ship modelToWorldVisualWorld _x;
	};
	private _l = nearestObject [_worldPos,"#lightpoint"];
	if(isNull _l)then{
		objNull;
	}else{
		if((getposworld _l) distance _worldPos > 0.8)then{
			objNull;
		}else{
			_l;
		};
	};
};
if(_outputNullObj)exitWith{_lights;};
_lights select {!isNull _x;};