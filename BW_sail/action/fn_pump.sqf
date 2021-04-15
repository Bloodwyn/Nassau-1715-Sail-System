/*
    Author: Bloodwyn http://steamcommunity.com/profiles/76561198055205907/

    Description:
    Reduce weight when pumping and remove holes.
*/

params[
	["_ship", objNull,[objNull]],
	["_amount", 0,[0]]
];

if(isNull _ship)exitWith{};
if(_amount < 1)exitWith{};

_ship setVariable["mass",(_ship getVariable ["mass",0])-_amount,true];

_holes = _ship getVariable["holes",0];

if((random 1)<.04)then{
	_ship setVariable["holes",(_holes-0.2) max 0,true];
};
