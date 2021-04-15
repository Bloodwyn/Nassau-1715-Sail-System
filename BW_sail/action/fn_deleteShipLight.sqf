params[
	["_ship",objNull,[objNull]],
	["_mempos","",["",[]]]
];

([_ship,_mempos] call BW_sail_fnc_getShipLight) apply {
	deleteVehicle _x;
};