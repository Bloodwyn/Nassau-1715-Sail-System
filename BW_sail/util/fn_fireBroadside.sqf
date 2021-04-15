/*
    Author: Bloodwyn http://steamcommunity.com/profiles/76561198055205907/

    Description:
   	Fires all weapons on the specified side
*/
if!(canSuspend)exitWith{_this spawn BW_sail_fnc_fireBroadside};

params[
	["_ship", BW_anker, [objNull]],
	["_side", true, [true]],	// true is starboard
	["_reload", true, [true]]
];

private _config = (configFile >> "cfgvehicles" >> typeOf _ship >> "SailWeapons") call BIS_fnc_getCfgSubClasses;

(attachedObjects _ship) apply{
	if((typeof _x) in _config)then{
		private _xOffset = (_ship worldToModelVisual (getposasl _x))#0;
		if((_xOffset > 0) isEqualTo _side)then{
			[_x, currentWeapon _x] call BIS_fnc_fire;
			if(_reload)then{
				[_x,[currentWeapon _x,1]] remoteExecCall ["setammo", _x];
			}else{
				_x setVariable ["1715_hasAmmo",false,true];
			};
			sleep (random .2);
		};
	};
};