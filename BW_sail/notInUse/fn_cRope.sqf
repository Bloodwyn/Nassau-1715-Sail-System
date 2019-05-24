_ship = param [0, objNull, [objNull]];
_mempos = param [1, "", [""]];

_rope = ropeCreate [player, "righthand", _ship, _mempos, -1, 10];

//_ship setVariable [format["%1_r",_mempos], _rope, true];

_ships = (player nearEntities ["ship", 100])-[_ship];


BW_sail_inRopeMode = true;

waitUntil {!BW_sail_inRopeMode};
deleteVehicle _rope;

