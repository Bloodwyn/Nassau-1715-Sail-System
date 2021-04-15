params[
	["_cannon", objNull,[objNull]],
	["_newMag", "",[""]]

];

if(isNull _cannon || _newMag isEqualTo "")exitWith{};

player playMoveNow "AinvPknlMstpSnonWnonDnon_medic_1";

BW_blockAction = true;

[4.5,{
	params ["_cannon","_newMag"];
	BW_blockAction=false;
	[_cannon,[currentMagazine _cannon,[0]]] remoteExecCall ["removeMagazinesTurret", _cannon];
	[_cannon,[_newMag,[0],1]] remoteExecCall ["addMagazineTurret", _cannon];
},[_cannon,_newMag]] call BW_sail_fnc_addWaitUntilTime;
