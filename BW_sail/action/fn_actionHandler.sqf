

/*
(0) screen to center distance

0 posModel
1 image
2 text
3 condition
4 code

5 posworld

*/
if(BW_dragging)exitWith{};
if(BW_blockAction)exitWith{};

if(BW_ActionData isEqualTo [])exitWith{};
private _actionData = BW_ActionData apply {
	_x+[BW_cShip modelToWorldVisual (_x#0)];
};

private _eyepos = eyePos player;
private _nearActions = _actionData select {_x#5 distance _eyepos < BW_actionDis};

if(_nearActions isEqualTo [])exitWith{};

private _trueActions = _nearActions select {BW_cShip call (_x#3)};

private _focusActions = _trueActions apply{
	private _screen = worldToScreen (_x#5);
	if (_screen isEqualTo [])then{
		_screen = [1e10,1e10];
	};
	[_screen distance2D [0.5,0.5]]+_x;};

_focusActions sort true;

if(!(_focusActions isEqualTo []) && {_focusActions#0#0 < BW_actionDis2})then{
	BW_activeExternAction = [];
	private _action = _focusActions#0;
	_action = _action-[_action#0];//clean sorting
	_trueActions = _trueActions-[_action];
	BW_activeAction = _action;
	drawIcon3D [ _action#1, [1,1,1,1],_action#5, 2.5, 2.5, 1,_action#2, .05,.05, "TahomaB", "right", true];
}else{
	BW_activeAction = [];
};

{
	drawIcon3D ["iconExplosiveAT", [1,1,1,.9],_x#5, .7, .75, 1,"", .025,.025, "TahomaB", "right", true];
}foreach _trueActions;