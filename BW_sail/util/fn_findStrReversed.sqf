/*
    Author: Bloodwyn http://steamcommunity.com/profiles/76561198055205907/

    Description:
    returns the postion of the required element, starting searching from the end of the string.
*/
params[
	["_str", "", [""]],
	["_f", "", [""]]
];

private _l = count _str;

private _r = _str find _f;
while {_r != -1} do{
	_str = _str select [_r+1,_l];
	_r = _str find _f;
};
_l-(count _str)-_r-2;