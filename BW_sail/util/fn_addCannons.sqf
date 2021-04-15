/*
    Author: Bloodwyn http://steamcommunity.com/profiles/76561198055205907/

    Description:
    Adds specified Cannons to the ship

    [obj] call BW_sail_fnc_addCannons -> adds all possible weapons

	[obj,"1715_exp_brit_6pounder"] call BW_sail_fnc_addCannons -> adds 6 pounder to all possible slots
	[obj,"1715_eng_1pdrswivel_exp"] call BW_sail_fnc_addCannons -> adds swifel to all possible slots
	[obj,"1715_exp_brit_6pounder",[2,4,6]] call BW_sail_fnc_addCannons -> adds 6 pounder to the slots 2 4 and 6

	[obj,"1715_exp_brit_6pounder",[2,4,6],"1715_eng_1pdrswivel_exp"] call BW_sail_fnc_addCannons
	-> adds 6 pounder to the slots 2 4 and 6 and all possible swifel guns
*/
private _ship = param [0, objNull, [objNull]];
if(isnull _ship)exitWith{["No object given"] call BIS_fnc_error;};
if(typeName _this != "ARRAY")then{_this = [_this]};

if(!local _ship)exitWith{_this remoteExecCall ["BW_sail_fnc_addCannons",_ship];};

_ship call BW_sail_fnc_removeAllCannons;

private _config = (configFile >> "cfgvehicles" >> typeOf _ship >> "SailWeapons");
if(isnull _config)exitWith{["No Nassau Weapons available for this object (%1)",_ship] call BIS_fnc_error;};

private _requiredWeapons = [];
private _requiredPostions = [];

private _max = (count _this)-1;
for "_i" from 1 to _max step 1 do{
	private _e = _this#_i;
	if(typeName _e isEqualTo "STRING")then{
		private _slots = [];
		if(_i+1<=_max)then{
			private _next = _this#(_i+1);
			if(typeName _next isEqualTo "ARRAY")then{
				_slots = _next;
				_i = _i+1;
			};
		};
		_requiredWeapons pushBack _e;
		_requiredPostions pushBack _slots;
	}else{
		["%1 has to be a string",_e] call BIS_fnc_error;
	};
};

private _availableWeapons = [_config]call BIS_fnc_getCfgSubClasses;
private _availablePostions = _availableWeapons apply{getArray (_config >> _x >> "positions")};

if(_requiredWeapons isEqualTo [])then{
	_requiredWeapons = _availableWeapons;
};

{
	private _weaponClass = _x;
	if(_weaponClass in _availableWeapons)then{
		private _positions = getArray (_config >> _weaponClass >> "positions");
		private _directions = getArray (_config >> _weaponClass >> "directions");
		private _offset = getNumber (_config >> _weaponClass >> "offset");

		private _requiredPos = [];
		if(_foreachindex < count _requiredPostions)then{
			_requiredPos = _requiredPostions#_foreachindex;
		};
		if(_requiredPos isEqualTo [])then{
			{_requiredPos pushBack _foreachindex;} forEach _positions;
		};
		if(selectMax  _requiredPos >= count _positions)then{
			["%1 postion not available for this ship (%2)",selectMax  _requiredPos,_ship] call BIS_fnc_error;
			_requiredPos = [];
		};
		_requiredPos apply{
			private _can = ([[0,0,0],0,_weaponClass,side _ship] call BIS_fnc_spawnVehicle)#0;
			private _pos = _ship selectionPosition (_positions#_x);
			private _dir =
			if(count _directions >= count _positions)then{
				vectorNormalized (_pos vectorDiff (_ship selectionPosition (_directions#_x)));
			}else{
				_dir = +_pos; // https://i.imgur.com/j1wv9VX.png
				_dir set[1,0];
				_dir set[2,0];
				_dir;
			};
			private _offsetVec = _dir vectorMultiply _offset;

			_can attachto[_ship,_offsetVec, (_positions#_x)];
			_can setVectorDirAndUp [_dir, [0, 0, 1]];

		};
	}else{
		["%1 not available for this ship (%2)",_weaponClass,_ship] call BIS_fnc_error;
	};
}foreach _requiredWeapons;