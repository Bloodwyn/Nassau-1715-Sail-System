/*
	Author: Bloodwyn http://steamcommunity.com/profiles/76561198055205907/
	This is heavy wip. Beware of ugly code, strange math and cruel variable names.
*/

BW_customMapMarker = createMarkerLocal ["customMap", [worldSize/2,worldSize/2]];

Power = 1;
staticPower = 0; //50
sidePower = 1;
sideForce = 1;

sleepTime = 0.1;
waterrate = 100;

aimmode = 1;

BW_activeAction = [];
BW_activeExternAction = [];
BW_action_font = "Dominican";

BW_cShip = objNull;

BW_actionDistanceObjSearch = 10;
BW_actionDistanceFocus = 0.1;

BW_actionKey = false;
BW_dragging = false;
BW_blockAction = false;
BW_sail_inRopeMode = false;
BW_sail_ropeMode = [];

BW_debugFontSize = .9;

BW_actionMinAlpha = 0.5;
BW_actionMaxAlpha = 0.9;

BW_OnEachFrameScripts = [];
addMissionEventHandler ["EachFrame", {BW_OnEachFrameScripts apply {call (_x # 1)};}];

["action",BW_sail_fnc_actionHandler] call BW_sail_fnc_stackOnEachFrame;

BW_waitUntilTimeData = [];
["waitUntilTime",BW_sail_fnc_waitUntilTime] call BW_sail_fnc_stackOnEachFrame;

0 spawn{
	waitUntil {!isNull (findDisplay 46)};
	if(isnull (configfile >> "CfgPatches" >> "cba_keybinding"))then{
		(findDisplay 46) displayAddEventHandler ["keydown",BW_sail_fnc_keyDown];
		(findDisplay 46) displayAddEventHandler ["keyup",BW_sail_fnc_keyUp];
	}else{
		["Nassau 1715", "actionKey", "Action Key", {
			call BW_sail_fnc_OnActionKey;
			BW_actionKey = true;
			false;
		},{
			BW_actionKey = false;
			if(BW_dragging)then{
				[BW_draggingData#0,2] remoteExecCall ["setOwner",2];
				["dragAction",{}] call BW_sail_fnc_stackOnEachFrame;
				BW_draggingData = [];
				BW_dragging = false;
			};
		},[33,[false,false,false]],true,0,false
		] call CBA_fnc_addKeybind;

		["Nassau 1715", "shipleft", "Helm to larboard", {
			if(!isNull BW_cShip && {player distance (BW_cShip modelToWorld (BW_cShip selectionPosition "pos_helm"))<2 && "rudder" in (animationNames BW_anker)})then{
				_anim = (BW_cShip animationphase "wheel") - .1;
				if(_anim<-1)then{
					_anim = -1;
				};
				BW_cShip animate ["wheel", _anim];
            	BW_cShip animate ["drumrope", _anim];
            	BW_cShip animate ["rudder", _anim];
            	BW_cShip animate ["tiller", _anim];
            	true;
			};
		},{},[30,[false,true,false]],true,0,false
		] call CBA_fnc_addKeybind;

		["Nassau 1715", "shipright", "Helm to starboard", {
			if(!isNull BW_cShip && {player distance (BW_cShip modelToWorld (BW_cShip selectionPosition "pos_helm"))<2 && "rudder" in (animationNames BW_anker)})then{
				_anim = (BW_cShip animationphase "wheel") + .1;
				if(_anim>1)then{
					_anim = 1;
				};
				BW_cShip animate ["wheel", _anim];
            	BW_cShip animate ["drumrope", _anim];
            	BW_cShip animate ["rudder", _anim];
            	BW_cShip animate ["tiller", _anim];
            	true;
			};
		},{},[32,[false,true,false]],true,0,false
		] call CBA_fnc_addKeybind;

		["Nassau 1715", "noweapon", "holster weapon", {
			player action ["SwitchWeapon", player, player, 100];
            true;
		},{},[35,[true,false,false]],false,0,false
		] call CBA_fnc_addKeybind;
	};
	if !(BW_customMapMarker in allMapMarkers)then{
		BW_customMapMarker = createMarkerLocal ["customMap", [worldSize/2,worldSize/2]];
	};

	private _customMap = getText(configfile >> "CfgWorlds" >> worldName >> "1715_customMap");
	//_customMap = "1715_custom_map_cat_cay";
	if !(_customMap isEqualTo "")then{
		BW_customMapMarker setMarkerTypeLocal _customMap;
		BW_customMapMarker setMarkerColorLocal "ColorWhite";

		private _m = createMarkerLocal ["windIndicator", [worldSize/9,worldSize/8]];
		_m setMarkerTypeLocal "BW_windIndicator";
		_m setMarkerSizeLocal [3, 3];
		_m setMarkerColorLocal "ColorWhite";

		["customMap",{
			private _control = (findDisplay 12) displayCtrl 51;
			if(isNull _control)exitWith{};
			private _zoom = ctrlMapScale _control;
			private _size = (1/_zoom) * 20;
			BW_customMapMarker setMarkerSizeLocal [_size,_size];
			"windIndicator" setMarkerSizeLocal [_size*.15,_size*.15];
			"windIndicator" setMarkerDirLocal (windDir + 180);
		}] call BW_sail_fnc_stackOnEachFrame;
	};


	["windIndicator",{
		private _ppos = getpos player;
		_ppos set [2,0];
		private _pos = _ppos vectoradd (wind vectorMultiply -10000);
		drawIcon3D ["\1715_data\actionicons\wind_ca.paa", [1,1,1,0.2],asltoagl _pos, 2, 2, 0, "", .05,.05, "TahomaB", "right", true];		
	}] call BW_sail_fnc_stackOnEachFrame;


	player addEventHandler ["FiredMan", {

	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_vehicle"];
	if(!isnull BW_cship && _muzzle isEqualTo "1715_grapplinghook_Muzzle")then{
		private _hook = "1715_objects_grappling_hook_F" createVehicle [0,0,0];

		private _pos = getposasl _projectile;
		private _vel = (velocity _projectile) vectoradd (velocity BW_cship);
		deleteVehicle _projectile;
		_hook setposasl (_pos);
		_hook setVelocity _vel;
		_hook addTorque [150,0,0];
		private _posM = BW_cship worldToModel (position player);
		private _con = getArray(configfile >> "cfgvehicles">> typeof BW_cship >> "RopeAttach");
		if(_con isEqualTo [])then{
			_con = [0,BW_cship worldToModel (position player vectoradd (vectordir player))];
		}else{
			_con = _con apply {
				_pos = (BW_cship selectionPosition _x);
				[_pos distance _posM,_x];
			};
			_con sort true;
		};
		private _r = ropeCreate [BW_cship,_con#0#1,_hook,"rope_attach",30];
		_hook setVariable ["rope",_r];
		_hook setVariable ["ropeStart",_con#0#1];
		_hook addEventHandler ["EpeContact",{
			params ["_hook", "_obj2", "", "", "_force"];
			if(_obj2 isKindOf "ship" && _obj2 != BW_cship)then{
				_hook removeAllEventHandlers "EpeContact";
				//hint str _this;
				private _r = _hook getVariable ["rope",objNull];
				if(isNull _r)exitWith{};
				private _pos1 = (ropeEndPosition _r)#0;
				ropeDestroy _r;
				deleteVehicle _r;
				_hook attachTo [_obj2];
				private _pos2 = position _hook;

				//hint format ["aa%1\n%2",BW_cship worldToModel _pos1,_pos1];
				//_r = ropeCreate[BW_cship, BW_cship worldToModel _pos1,_obj2,_obj2 worldToModel _pos2,2*(_pos2 distance _pos1)];

				private _r = ropeCreate[_obj2,_obj2 worldToModel _pos2,BW_cship, BW_cship worldToModel _pos1,30];

				private _otherRopes = BW_cship getVariable ["ropes",[]];
				_otherRopes pushBack [_hook getVariable ["ropeStart",""],_r,_obj2,""];
				BW_cship setVariable ["ropes",_otherRopes];

				//[_obj2, _obj2 worldToModel (position _hook)] ropeAttachTo _r;
			}else{
				[_r,_hook] spawn{sleep 5; ropeDestroy (_this#0); deleteVehicle (_this#1);};
			};
		}];
		[_r,_obj] spawn{sleep 8; ropeDestroy (_this#0); deleteVehicle (_this#1);};
	};
}];
};


0 spawn{
	waitUntil {!isNil "BW_WMO_exit" && !isNil "BW_WMO_exit"};
	if(!isNil "BW_anker" && {!isNull BW_anker})then{
		BW_anker call BW_sail_fnc_enterShip;
	};
	BW_WMO_enter pushBack {
		_this call BW_sail_fnc_enterShip;
	};
	BW_WMO_exit pushback {BW_cShip = objNull;};
};

private _findmax = {
	private _max = -1e10;
	private _maxindex = -1;
	{
		if(_x>_max)then{
			_max = _x;
			_maxindex = _foreachindex;
		};
	}foreach _this;
	_maxindex;
};


sloop_tri_sail_traverse =  (loadFile "BW_sail\matrix\sloop_tri_sail_traverse.csv") 	call BW_sail_fnc_parseCSV;
sloop_tri_sail_side = 	   (loadFile "BW_sail\matrix\sloop_tri_sail_side.csv") 		call BW_sail_fnc_parseCSV;
sloop_quad_sail_traverse = (loadFile "BW_sail\matrix\sloop_quad_sail_traverse.csv") call BW_sail_fnc_parseCSV;
sloop_quad_sail_side =	   (loadFile "BW_sail\matrix\sloop_quad_sail_side.csv") 	call BW_sail_fnc_parseCSV;
sloop_jib_sail_side = 	   (loadFile "BW_sail\matrix\sloop_jib_sail_side.csv") 		call BW_sail_fnc_parseCSV;

frig_tri_sail_traverse =  (loadFile "BW_sail\matrix\frig_tri_sail_traverse.csv") 	call BW_sail_fnc_parseCSV;
frig_tri_sail_side = 	  (loadFile "BW_sail\matrix\frig_tri_sail_side.csv") 		call BW_sail_fnc_parseCSV;
frig_quad_sail_traverse = (loadFile "BW_sail\matrix\frig_quad_sail_traverse.csv") 	call BW_sail_fnc_parseCSV;
frig_quad_sail_side =  	  (loadFile "BW_sail\matrix\frig_quad_sail_side.csv") 		call BW_sail_fnc_parseCSV;
frig_jib_sail_side = 	  (loadFile "BW_sail\matrix\frig_jib_sail_side.csv") 		call BW_sail_fnc_parseCSV;


sloop_jib_sail_traverse = [];
{
	private _a = sloop_tri_sail_traverse apply {_x#_foreachindex};
	private _maxIndex = _a call _findmax;
	sloop_jib_sail_traverse pushback (_a#_maxindex);
}foreach (sloop_tri_sail_traverse#0);

frig_jib_sail_traverse = [];
{
	private _a = frig_tri_sail_traverse apply {_x#_foreachindex};
	private _maxIndex = _a call _findmax;
	frig_jib_sail_traverse pushback (_a#_maxindex);
}foreach (frig_tri_sail_traverse#0);

sail_steps = [0.1,5.625];

_packed = parseNumber (getText (configFile >> "cfgMods" >> "timepacked"));

// seconds since 08/26/2020 @ 12:00am (UTC)
_s = _packed-1598400000;
_h = _s / (60*60);
diag_log format["Pack time hours since 08/26/2020 @ 12:00am (UTC): %1", _h];
PACKTIME_1715 = _h;

if(isServer)then{
	PACKTIME_1715_SERVER = _h;
	publicVariable "PACKTIME_1715_SERVER";
};

if(!isNil "PACKTIME_1715_SERVER" && {PACKTIME_1715_SERVER != PACKTIME_1715})then{
	onEachFrame{hintSilent "VERSION MISMATCH!"};
};