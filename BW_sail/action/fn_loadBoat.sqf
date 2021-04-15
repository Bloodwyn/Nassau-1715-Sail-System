private _boat = param [0, objNull, [objNull]];
private _ship = param [1, BW_cship, [objNull]];

private _point =  [_boat,_ship] call BW_sail_fnc_whereCanLoadBoat;
if(_point isEqualTo "")exitWith{};

private _cfg = configFile >> "CfgVehicles" >> typeOf _ship >> "BoatAttachPositions";

private _queryResult = getArray (_cfg >> _point >> "offset");
private _offset = if(_queryResult isEqualTo [])then{[0,0,0];}else{_queryResult;};

_boat attachTo [_ship,_offset,_point];