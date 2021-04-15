private _ship = param [0, objNull, [objNull]];


if(isNull (configFile >> "cfgvehicles" >> typeOf _this >> "CfgBWSailSystem"))exitWith{};

BW_cShip = _ship;

private _cfg = configfile >> "cfgvehicles">> typeof _ship >> "RopeAttach";

if(isNull _cfg)exitWith{};

private _ropePoints = getArray _cfg;
if(_ropePoints isEqualTo [])exitWith{};

private _img = "BW_sail\icon\placeholder.paa";

_ropePoints apply {

	//	has a rope in hand AND is not on the ship where the rope starts AND the current ropepoint has no rope yet
	[
		_ship,
		"attach rope",
		"\1715_sloops\actionicons\rope_attach_ca.paa",
		format ["!(BW_sail_ropeMode isEqualTo []) &&
				{!((BW_sail_ropeMode#0) isEqualTo BW_cShip)} &&
				({_x#0 isEqualTo ""%1""} count (_this getVariable [""ropes"",[]]) isEqualTo 0)",_x],
		format ["[_this,""%1""] call BW_sail_fnc_exitRopeMode;", _x],
		_x,
		3,
		[],
		_x+"attach"
	] call BW_sail_fnc_addAction;

	// rope in hand && rope in hand is attached to point
	[
		_ship,
		"stow rope",
		"\1715_sloops\actionicons\rope_dettach_ca.paa",
		format ["!(BW_sail_ropeMode isEqualTo []) && {BW_sail_ropeMode#0 isEqualTo _this && BW_sail_ropeMode#1 isEqualTo ""%1""}",_x],
		"[OBJNULL, ''] call BW_sail_fnc_exitRopeMode;",
		_x,
		3,
		[],
		_x+"stow"
	] call BW_sail_fnc_addAction;

	[
		_ship,
		"take rope",
		"\1715_sloops\actionicons\rope_dettach_ca.paa",
		format ["_ropesAtPoint = ((_this getVariable [""ropes"",[]]) select {_x#0 isEqualTo ""%1""});
				BW_sail_ropeMode isEqualTo [] && {_ropesAtPoint isEqualTo [] || {!((_ropesAtPoint#0#3) isEqualTo """")}}",_x],
		format ["[_this,""%1""] call BW_sail_fnc_enterRopeMode;", _x],
		_x,
		3,
		[],
		_x+"take"
	] call BW_sail_fnc_addAction;

	//	the current ropepoint HAS a rope AND has NO rope in hand
	[
		_ship,
		"delete rope",
		"\1715_sloops\actionicons\rope_dettach_ca.paa",
		format ["({_x#0 isEqualTo ""%1""} count (_this getVariable [""ropes"",[]]) > 0) && BW_sail_ropeMode isEqualTo []",_x],
		format ["[_this,""%1""] call BW_sail_fnc_removeRope;", _x],
		_x,
		3,
		[],
		_x+"delete"
	] call BW_sail_fnc_addAction;

	//	has NO rope in hand AND the current ropepoint HAS a rope
	[
		_ship,
		"shorten rope",
		"\1715_sloops\actionicons\rope_dettach_ca.paa",
		format ["BW_sail_ropeMode isEqualTo [] &&
				({_x#0 isEqualTo ""%1""} count (_this getVariable [""ropes"",[]]) > 0)",_x],
		format ["[_this,""%1"",false] call BW_sail_fnc_resizeRope;", _x],
		_x,
		3,
		[],
		_x+"shorten"
	] call BW_sail_fnc_addAction;

	//	has NO rope in hand AND the current ropepoint HAS a rope
	[
		_ship,
		"lengthen rope",
		"\1715_sloops\actionicons\rope_dettach_ca.paa",
		format ["BW_sail_ropeMode isEqualTo [] &&
				({_x#0 isEqualTo ""%1""} count (_this getVariable [""ropes"",[]]) > 0)",_x],
		format ["[_this,""%1"",true] call BW_sail_fnc_resizeRope;", _x],
		_x,
		3,
		[],
		_x+"lengthen"
	] call BW_sail_fnc_addAction;
};
