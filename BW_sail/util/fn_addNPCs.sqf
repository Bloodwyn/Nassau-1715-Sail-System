private _ship = param [0, BW_anker, [objNull]];
	[[0.811523,2.17773,-11.7542], [-2.11328,-6.1582,-12.3462], [-2.22852,-10.71,-12.2648], [-0.719727,-14.7813,-11.3594], [2.25879,-8.38965,-12.4492], [0.164063,-0.417969,-11.5851]] apply {
		private _npc = "1715_brit_soldier" createVehicle [0,0,0];
		_npc attachTo [_ship,_x];
		_npc setdir (random 360);
	};