/*
    Author: Bloodwyn http://steamcommunity.com/profiles/76561198055205907/

    Description:
    handler while dragging.
*/
BW_draggingData params[
	["_obj", objNull, [objNull]],
	["_startanims", [], [[]]],
	["_startpos", [0,0,0], [[]]],
	["_animSel", [], [[]]],
	["_positionSel", "", [""]],
	["_modelPosSelStart", [], [[]]]
];

private _pos = _obj modelToWorldVisual (_obj selectionPosition _positionSel);

drawIcon3D ["\BW_sail\icon\hand_closed_f.paa", [1,1,1,1],_pos,  2.5, 2.5, 1,"", .05,.05, "TahomaB", "right", true];

private _posStart = _obj modelToWorldVisual _modelPosSelStart;
private _cpos = WorldToScreen _posStart;

private _anim = aimmode*(_startanims#0)+_startpos#1-_cpos#1;
if (_anim<-1)then{_anim=-1};
if (_anim>1)then{_anim=1};


if (count _startanims == 2)then{
	_anim2 = aimmode*(_startanims#1)+_startpos#0-_cpos#0;
	if (_anim2<-1)then{_anim2=-1};
	if (_anim2>1)then{_anim2=1};
	_obj animateSource [_animSel#1,aimmode*_anim2,true];
};

_obj animateSource [_animSel#0,aimmode*_anim,true];