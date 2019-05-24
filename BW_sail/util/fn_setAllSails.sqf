

params[
	["_ship", BW_cship, [objNull]],
	["_set", 0, [0]]	//1 for unsetting
];

if(isNull _ship)exitWith{};

private _windFrom = (winddir-(direction _ship)-180);

_windFrom=_windFrom call BW_sail_fnc_normalizeDeg;

private _t = _windFrom - 180;


private _sel = (round(_windFrom/(sail_steps#1))) mod 64;

private _config=(configFile >> "cfgvehicles" >> typeOf _ship >> "CfgBWSailSystem");
(_config call bis_fnc_getCfgSubclasses) apply {
	_sailc = _config>>_x;
	_type = getNumber (_sailc>>"type");
	switch (_type) do
	{
		case 0:
		{
			private _maxIndex = 0;
			private _maxV = -1e39;
			for "_i" from 0 to 19 step 1 do
			{
				_v = tri_sail_traverse # _i # _sel;
				if(_v>_maxV)then{
					_maxIndex = _i;
					_maxV = _v;
				};
			};

			private _anim = _maxIndex*(sail_steps#0)-1;

			if(_maxV<=0)then{
				_ship animate [getText(_sailc>>"set"),1];
			}else{
				_ship animate [getText(_sailc>>"set"),_set];
			};
			_ship animate [getText(_sailc>>"sideSwing"),_anim];
		};
		case 1:
		{
			if(jib_sail_traverse#_sel <= 0)then{
				_ship animate [getText(_sailc>>"set"),1];
			}else{
				_ship animate [getText(_sailc>>"set"),_set];
			};
		};
		case 2:
		{
			private _maxIndex = 0;
			private _maxV = -1e39;
			for "_i" from 0 to 19 step 1 do
			{
				_v = quad_sail_traverse # _i # _sel;
				if(_v>_maxV)then{
					_maxIndex = _i;
					_maxV = _v;
				};
			};

			private _anim = _maxIndex*(sail_steps#0)-1;

			if(_maxV<=0)then{
				(getArray(_sailc>>"set")) apply {_ship animate [_x,1];};
			}else{
				(getArray(_sailc>>"set")) apply {_ship animate [_x,_set];};
			};
			_ship animate [getText(_sailc>>"sideSwing"),_anim*-1];
		};
	};
};