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
	_ship setVariable ["init",true];

	if(_ship isKindOf "1715_frigate_persephone")then{
		private _rig = "1715_frigate_1_rigging" createVehicle [0,0,0];
		_rig attachto [_ship,[0,4.585,15.47]];
		_rig setdir 180;
		_ship setVariable ["rigging",_rig];
		_ship setVariable ["planks",6,true];
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

		private _f1 = "sloop_pennonhalliard" createvehicle  [0,0,0];
		_f1 attachto [_ship,[0,0,0],"pennant"];
		private _f2 = "sloop_ensign" createvehicle  [0,0,0];
		_f2 attachto [_ship,[0,0,-1.5],"pos_ensign"];

		_f2 hideObjectGlobal true;

		if(_ai)then{
			private _handle = _ship execFSM "BW_sail\sailAI.fsm";
			_ship setVariable ["aihandle",_handle];
		};
	};

	_ship call BW_sail_fnc_addCannons;
	_ship setOwner 2;
	private _handle = _ship execFSM "BW_sail\mainSail.fsm";

	_ship setVariable ["sailHandle",_handle];

	_ship setVariable["mass",getMass _ship,true];

	_ship addMPEventHandler ["MPHit", {
		params ["_unit", "_source", "_damage", "_instigator"];
		private _parent = attachedTo _source;
		if(local _unit && _parent != _unit && !isnull (configFile >> "cfgvehicles" >> typeOf _parent >> "SailWeapons" >> typeOf _source))then{
			_unit setVariable["holes",(_unit getVariable ["holes",0]) + 1,true];
			//systemChat format["Added hole: %1",_this];
		};
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
}else{
	if(local _ship)then{
		_ship spawn{
			sleep 2;
			_this remoteExecCall["BW_sail_fnc_initShip",2];
		};
	};
};