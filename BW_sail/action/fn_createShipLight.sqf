/*
    Author: Bloodwyn http://steamcommunity.com/profiles/76561198055205907/

    Description:
    Creates light sources and attaches them at the given memory point(s)

    Returns array of created light sources
*/

params[
	["_ship",objNull,[objNull]],
	["_mempos","",["",[]]],

	["_color",[1,.8,.7],[[]],3],
	["_brightness",.085,[0]],
	["_useFlare",false,[false]],
	["_dayLight",true,[true]],
	["_flareSize",.46,[0]],
	["_flareMaxDistance",200,[0]]
];

if(isNull _ship)exitWith{};

if(_mempos isEqualType "" or {count _mempos > 0 and {(_mempos#0) isEqualType 0}})then{
	_mempos = [_mempos];
};

_mempos apply {
	_l = "#lightpoint" createVehicleLocal [0,0,0];
	_l setLightColor _color;
	_l setLightBrightness _brightness;
	if(_x isEqualType "")then{
		_l attachTo [_ship,[0,0,0],_x]; //lightAttachObject is very jittery
	}else{
		_l attachTo [_ship,_x];
	};
	//_l setLightAttenuation [0.181, 0, 1000, 130];
	_l setLightFlareMaxDistance _flareMaxDistance;
	_l setLightUseFlare _useFlare;
	_l setLightDayLight _dayLight;
	_l setLightFlareSize _flareSize;
	_l;
};