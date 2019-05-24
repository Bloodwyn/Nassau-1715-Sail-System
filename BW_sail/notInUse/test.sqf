0 spawn{
_maxDistance = 130;
_minDistance = _maxDistance*.85;
_count = 200;
_allPuddles = [];
for "_i" from 1 to 200 step 1 do
{
	_temp = "Land_Puddle_01_F" createvehiclelocal [0,0,0];
	_dir = (random 360);
	_temp setpos (getpos player vectoradd [cos _dir * (random _maxDistance),sin _dir * (random _maxDistance),0]);
	_allPuddles pushBack _temp;
};

while {true} do
{
	sleep .01;
	{
		if (_x distance vehicle player > _maxDistance)then{
			_vel = vectornormalized (velocity player);
			_x setpos (getpos player vectoradd ((_vel)vectorMultiply(_minDistance + random (_maxDistance - _minDistance))) vectoradd ([_vel select 1,(_vel select 0)*-1,0]vectorMultiply (_maxDistance/2 - random (_maxDistance))));
		};
	} forEach _allPuddles;
};

};



vectorUpToDegree={
acos (surfaceNormal _this vectorDotProduct [0,0,1])
};

vecDirToDegree={
if (_this select 0 > 0)then{
    acos(_this select 1);
}else{
    360-acos(_this select 1);
};
};

vecDirToDegree2={
_v = vectorNormalized [_this select 0,_this select 1,0];
if (_this select 0 > 0)then{
    acos(_this select 1);
}else{
    360-acos(_this select 1);
};
};




comment "for testing";
0 spawn{
	while {true} do
	{
		hintSilent str call vectorUpToDegree;
	};
}


vectorUpToDegree={
_u = surfaceNormal position player;
_v = [_u select 0,_u select 1, 0];
acos((abs(_u vectorDotProduct _v))/(([0,0,0] vectorDistance _u)*([0,0,0] vectorDistance _v)));
};

_u = surfaceNormal position player;
_v = [_u select 0,_u select 1, 0];
acos((abs(_u vectorDotProduct _v))/(([0,0,0] vectorDistance _u)*([0,0,0] vectorDistance _v)));


comment "Related vehicle classes:";
comment "C_Van_02_medevac_F";
comment "C_IDAP_Van_02_medevac_F";

_veh = createVehicle ["C_Van_02_medevac_F",position player,[],0,"NONE"];
[
	_veh,
	["CivAmbulance",1],
	["reflective_tape_hide",0,"LED_lights_hide",0,"sidesteps_hide",0,"rearsteps_hide",0,"front_protective_frame_hide",0,"beacon_front_hide",0,"beacon_rear_hide",0]
] call BIS_fnc_initVehicle;



};


0 spawn{
    _dir = 0;
    while {true} do
    {
        setWind[(sin _dir)*20,(cos _dir)*20,true];
        _dir=_dir+1;
        sleep 0.1;
    };
};
