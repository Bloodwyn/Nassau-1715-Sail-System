params[
	["_ship",BW_cship,[objNull]],
	["_actionMemPos","",[""]],
	["_flagMemPos","ensign",[""]]
];

private _oldFlag = [_ship,_flagMemPos] call BW_sail_fnc_getFlagObj;

if(isNull _oldFlag)exitWith{};

private _parentFlagClassName = configName (inheritsFrom (configFile >> "CfgVehicles" >> (typeof _oldFlag)));

private _flagCandidates = ((format ["configName (inheritsFrom _x) isEqualTo %1",str _parentFlagClassName]) configClasses (configFile >> "CfgVehicles")) apply {configName _x};

if(count _flagCandidates <= 1)exitWith{};


private _availableFlags = _ship getVariable["1715_availableFlags",[]];

if(_availableFlags isEqualTo [])then{
	_availableFlags = getArray (configFile >> "CfgVehicles" >> typeof _ship >> "1715_flags" >> _flagMemPos >> "availableFlags");
};

private _flags = [];

if("all" in _availableFlags)then{
	_flags = _flagCandidates;
}else{
	if !(_availableFlags isEqualTo [])then{
		_flagCandidates apply {

			if(_x in _availableFlags)then{
				_flags pushBackUnique _x;
			}else{
				_categoriesOfCurrentFlag = getArray(configFile >> "CfgVehicles" >> _x >> "flagCategories");
				// if they share at least one category
				if!((_categoriesOfCurrentFlag arrayIntersect _availableFlags) isEqualTo [])then{
					_flags pushBackUnique _x;
				};
			};
		};
	}else{
		_flags = _availableFlags;
	};
};


private _count = count _flags;
private _rowCount = ceil sqrt(_count);

private _view = getCameraViewDirection player;

private _right = _view vectorCrossProduct [0,0,1];
private _down = _view vectorCrossProduct _right;

private _startPos = _ship modelToWorldVisual (_ship selectionPosition _actionMemPos);

private _itemDistance = 0.3;

private _halfway = sqrt(_count)*.5*_itemDistance;

_startPos = _startPos vectoradd (_right vectorMultiply -_halfway) vectoradd (_down vectorMultiply -_halfway);

BW_sail_changeFlagData = [_ship, _flagMemPos];

private _flagIndex = 0;
for "_y" from 0 to (_rowCount-1) step 1 do {
	for "_x" from 0 to (_rowCount-1) step 1 do {
		if(_flagIndex >= _count)exitWith{};
		_additionalOffset = if(_y%2 == 0)then{0}else{_itemDistance/2};
		private _pos = _startPos vectoradd (_right vectorMultiply (_x*_itemDistance+_additionalOffset)) vectoradd (_down vectorMultiply (_y*_itemDistance));
		private _currentFlagConfig = configFile >> "cfgVehicles" >> (_flags#_flagIndex);

		[
			_ship,
			getText (_currentFlagConfig >> "displayName"),
			getText (_currentFlagConfig >> "Icon"),
			"true",
			format ["BW_sail_changeFlagData pushBack %1;",str configName _currentFlagConfig],			
			_ship worldToModelVisual _pos,
			5
		] call BW_sail_fnc_addAction;
		_flagIndex = _flagIndex + 1;
	};
};

["changeFlag",{

	if(isNil "BW_sail_changeFlagData")exitWith{
		["changeFlag",{}] call BW_sail_fnc_stackOnEachFrame;
	};
	BW_sail_changeFlagData params ["_ship","_flagMemPos"];

	if((count BW_sail_changeFlagData) > 2)exitWith{
		_newType = BW_sail_changeFlagData#2;

		[_ship, _flagMemPos, _newType] remoteExecCall ["BW_sail_fnc_changeFlag",2];

		_actions = _ship getVariable ["BW_actions",[]];
		_ship setVariable ["BW_actions", _actions select {(_x#4) find "BW_sail_changeFlagData" < 0}];
		BW_sail_changeFlagData = nil;
	};
	if((getposasl player) distance (_ship modelToWorldVisualWorld (_ship selectionPosition _actionMemPos)) > 6)exitWith{
		_actions = _ship getVariable ["BW_actions",[]];
		_ship setVariable ["BW_actions", _actions select {(_x#4) find "BW_sail_changeFlagData" < 0}];
		BW_sail_changeFlagData = nil;
	};
}] call BW_sail_fnc_stackOnEachFrame;