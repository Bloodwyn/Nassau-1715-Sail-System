_cannon = param [0, objNull,[objNull]];

if(isNull _cannon)exitWith{};

BW_blockAction = true;

[4.5,{(_this#0) setVariable ["BW_blockAction",false,true]},[_cannon]] remoteExecCall ["BW_sail_fnc_addWaitUntilTime",2];
_cannon setVariable ["BW_blockAction",true,true];

player playMoveNow "AinvPknlMstpSnonWnonDnon_medic_1";

[4.5,{
	params ["_cannon"];
	BW_blockAction=false;
	[_cannon,[currentWeapon _cannon,1]] remoteExecCall ["setammo", _cannon];
	_cannon setVariable ["1715_hasAmmo",true,true];
},[_cannon]] call BW_sail_fnc_addWaitUntilTime;

player playaction "gestureGoB";
[1.5,{
	params ["_cannon"];
	_cannon animateSource ["recoilSource",0];
	player playAction "gestureGo";
},[_cannon]] call BW_sail_fnc_addWaitUntilTime;