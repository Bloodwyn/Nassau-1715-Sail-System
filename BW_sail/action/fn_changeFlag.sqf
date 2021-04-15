if(!isServer)exitWith{_this remoteExecCall ["BW_sail_fnc_changeFlag",2];};

params [
	["_ship",objNull,[objNull]], 
	["_flagMemPos", "", [""]], 
	["_newType", "", [""]]
];

if(isNull _ship)exitWith{diag_log "Nassau 1715 :: BW_sail :: changeFlag :: No Ship given";};
if(_flagMemPos isEqualTo "")exitWith{diag_log "Nassau 1715 :: BW_sail :: changeFlag :: No memory pos given";};

private _cfg = configFile >> "CfgVehicles" >> typeof _ship >> "1715_flags" >> _flagMemPos;

if(isNull _cfg)exitWith{diag_log "Nassau 1715 :: BW_sail :: changeFlag :: Invalid memory pos";};

if(!isClass (configFile >> "cfgVehicles" >> _newType))exitWith{diag_log "Nassau 1715 :: BW_sail :: changeFlag :: Invalid new flag classname given";};


private _offset = getArray (_cfg >> "offset");

if(_offset isEqualTo [])then{_offset = [0,0,0];};

private _oldFlag = [_ship,_flagMemPos] call BW_sail_fnc_getFlagObj;

if(isNull _oldFlag)then{diag_log "Nassau 1715 :: BW_sail :: changeFlag :: Cant find old flag. Creating one";}else{
	detach _oldFlag;
	hideObjectGlobal _oldFlag;
	deleteVehicle _oldFlag;
};

_flag = _newType createVehicle [0,0,0];
_flag attachto [_ship,_offset,_flagMemPos];

_up = getArray (_cfg >> "vectorUp");
if(_up isEqualTo [])then{_up = [0,0,1];};
_flag setVectorUp _up;
