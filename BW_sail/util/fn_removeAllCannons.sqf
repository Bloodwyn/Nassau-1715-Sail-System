/*
    Author: Bloodwyn http://steamcommunity.com/profiles/76561198055205907/

    Description:
    Removes all weapons defined in the "sailWeapons" config that are currently attached to the object.
*/
private _ship = param [0, BW_anker, [objNull]];
private _config = (configFile >> "cfgvehicles" >> typeOf _ship >> "SailWeapons") call BIS_fnc_getCfgSubClasses;

(attachedObjects _ship) apply{if((typeof _x) in _config)then{deleteVehicle _x};};