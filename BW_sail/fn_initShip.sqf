/*
    Author: Bloodwyn http://steamcommunity.com/profiles/76561198055205907/

    Description:
    What does an init do?
*/
if(is3DEN)exitWith{};

params[
	["_ship",objNull, [objNull]],
	["_ai",false, [true]]
];

if(isServer)then{
	if(_ship getVariable ["init",false])exitWith{};
	_ship setVariable ["init",true,true];

	_ship setOwner 2;

	//_ship call BW_sail_fnc_addCannons;
	//wtf
	[1,BW_sail_fnc_addCannons,[_ship]]call BW_sail_fnc_addWaitUntilTime;

	if(_ship isKindOf "1715_frigate_greyhound" )then{
		_ship setVariable ["planks",6,true];

		private _config = (configFile >> "cfgvehicles" >> typeOf _ship >> "SailWeapons") call BIS_fnc_getCfgSubClasses;
		(attachedObjects _ship) apply{
 			if((typeof _x) in _config)then{_x animate ["maingun",-0.5]};
		};

        _ship animate ["anchor_hide_star",0];
        _ship animate ["cable_stowed_star",0];
        _ship animate ["anchor_rot_star",0];
        _ship animate ["shankpainter_star",0];
        _ship animate ["anchor_hide_lar",0];
        _ship animate ["cable_stowed_lar",0];
        _ship animate ["anchor_rot_lar",0];
        _ship animate ["shankpainter_lar",0];

        _ship setVariable ["pos_sail_jib_off",[0,-10,0]]; 
		_ship setVariable ["pos_sail_fore_topmaststaysail_off",[0,-10,0]];
		_ship setVariable ["pos_sail_fore_course_off",[0,-5,0]]; 
		_ship setVariable ["pos_sail_fore_topsail_off",[0,-5,0]]; 
		_ship setVariable ["pos_sail_fore_tgallant_off",[0,-5,0]]; 
		_ship setVariable ["pos_sail_main_topmaststaysail_off",[0,-5,0]]; 
		_ship setVariable ["pos_sail_main_tgallantstaysail_off",[0,-5,0]];
		_ship setVariable ["pos_sail_main_course_off",[0,-11,0]]; 
		_ship setVariable ["pos_sail_main_topsail_off",[0,-11,0]]; 
		_ship setVariable ["pos_sail_main_tgallant_off",[0,-11,0]]; 
		_ship setVariable ["pos_sail_mizzen_topmaststaysail_off",[0,0,0]];
		_ship setVariable ["pos_sail_mizzen_topsail_off",[0,-4,0]]; 
		_ship setVariable ["pos_sail_mizzen_lateen_sheet_off",[-2.15,0,0]];
		_ship setVariable ["pos_sail_bowsprit_spritsail_off",[0,-12,0]];
	};

	if(_ship isKindOf "1715_sloop_base")then{
		_ship setCenterOfMass ((getCenterOfMass _ship) vectoradd [0,.2,-.5]); // temp
		_ship animate ["anchor_hide_star",0];
		_ship animate ["anchor_hide_star",0];
		_ship animate ["cable_stowed_star",0];
		_ship animate ["anchor_rot_star",0];
		_ship animate ["shankpainter_star",0];
		_ship animate ["anchor_hide_lar",0];
		_ship animate ["cable_stowed_lar",0];
		_ship animate ["anchor_rot_lar",0];
		_ship animate ["shankpainter_lar",0];
		_ship setVariable ["planks",2,true];

		if(_ai)then{
			private _handle = _ship execFSM "BW_sail\sailAI_arma.fsm";
			_ship setVariable ["aihandle",_handle];

			//private _handle = _ship execFSM "BW_sail\sailAI.fsm";
			//_ship setVariable ["aihandle",_handle];
		};

		_ship setVariable ["pos_sail_gaff_off",[0,-4,0]];
	};

	private _flagClass = configFile >> "CfgVehicles" >> (typeOf _ship) >> "1715_Flags";
	if(!isnull _flagClass)then{
		[_flagClass] call BIS_fnc_getCfgSubClasses apply {
			_flagtype = getText (_flagClass >> _x >> "flagtype");
			_offset = getArray (_flagClass >> _x >> "offset");
			if(_offset isEqualTo [])then{_offset = [0,0,0];};
			_flag = _flagtype createVehicle [0,0,0];
			_flag attachto [_ship,_offset,_x];
			_up = getArray (_flagClass >> _x >> "vectorUp");
			if(_up isEqualTo [])then{_up = [0,0,1];};
			_flag setVectorUp _up;

			if(_x find "ensign" > -1)then{
				_flag hideObjectGlobal true;
			};
			
			if(_x find "jack" > -1)then{
				_flag hideObjectGlobal true;
			};
		};
	};

	private _handle = _ship execFSM "BW_sail\mainSail.fsm";

	_ship setVariable ["sailHandle",_handle];

	_ship setVariable["mass",getMass _ship,true];

	/*_ship addMPEventHandler ["MPHit", {
		params ["_unit", "_source", "_damage", "_instigator"];
		private _parent = attachedTo _source;
		if(local _unit && _parent != _unit && !isnull (configFile >> "cfgvehicles" >> typeOf _parent >> "SailWeapons" >> typeOf _source))then{
			_unit setVariable["holes",(_unit getVariable ["holes",0]) + 1,true];
			//systemChat format["Added hole: %1",_this];
		};
	}];*/

	_ship addEventHandler ["HitPart", {
		(_this select 0) params ["_target", "_shooter", "_projectile", "_position", "_velocity", "_selection", "_ammo", "_vector", "_radius", "_surfaceType", "_isDirect"];
		//systemChat format ["Hit! Ammo: %1",_ammo];
		_processedProjectiles = (_target getVariable["1715_processedProjectiles",[]]) select {!isNull _x};	

		if (!(_projectile in _processedProjectiles) && {_ammo select 4 == "1715_6pound_shot"}) then {
				_processedProjectiles pushBack _projectile;
				//should add check for wooden surface + && (local _unit && _parent != _unit && !isnull (configFile >> "cfgvehicles" >> typeOf _parent >> "SailWeapons" >> typeOf _source))
				//systemChat format["Calling with params: Target: %1 Projectile: %2",_target,_projectile];
				//systemChat format["Debug: _canDamage: %1 %2 time: %3_lasttime: %4 _position; %5 _lasthit: %6, distance: %7 ",_canDamage, ((time - _lasttime)>0.1 || _position distance _lasthit > 0.5), time, _lasttime, _position, _lasthit, (_position distance _lasthit)];
				//_target setVariable["runs",(_target getVariable["runs",0])+1];
				[_target,_projectile] call BW_sail_fnc_handleSplinters;
				[_target,_position,_vector,_surfaceType] call BW_sail_fnc_addHole;
				_target setVariable ["lasttime",time];
				_target setVariable ["lasthit",_position];
		};
		_target setVariable["1715_processedProjectiles",_processedProjectiles];		
	}];

	_ship addEventHandler ["HandleDamage", {
		_unit = param [0, objNull, [objNull]];
		_damage = param [2, 0, [0]];
		params["_unit","","_damage"];
		if(_damage >= 1)then{
			.9;
		}else{
			_damage;
		};
	}];

	_ship addEventHandler ["Deleted", {
		params ["_entity"];
		(attachedObjects _entity) apply{
 			deleteVehicle _x;
		};
	}];

}else{
	if(local _ship)then{
		_ship spawn{
			sleep 2;
			_this remoteExecCall["BW_sail_fnc_initShip",2];
		};
	};
};