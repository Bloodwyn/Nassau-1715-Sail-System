if(BW_dragging)exitWith{};
if(BW_blockAction)exitWith{};

private _refPos = (asltoagl (eyepos player));

private _objs = _refPos nearEntities BW_actionDistanceObjSearch;

if(!isNull BW_anker)then{
	_objs pushBackUnique BW_anker;
};

if(!isNull cursorTarget)then{
	_objs pushBackUnique cursorTarget;
};

if(!isNull cursorObject)then{
	_objs pushBackUnique cursorObject;
};

private _actions = [];

_objs = _objs select {!(_x getVariable ["BW_blockAction",false])};

_objs apply {
	_obj = _x;
	private _cfg = configFile >> "cfgvehicles">> typeOf _obj>> "BW_actions";

	if(!isNull _cfg)then{
		_actions append ((_cfg call BIS_fnc_getCfgSubClasses) apply {
		 	_subcfg = _cfg >> _x;
		 	_pos = if(isArray (_subcfg >>"position"))then{getArray (_subcfg >>"position")}else{getText (_subcfg >>"position")};
		 	_radius = ((getNumber (_subcfg >> "radius")) min BW_actionDistanceObjSearch) max 3;
		 	[
		 		_obj,
		 		_x,
		 		getText (_subcfg >> "displayName"),
		 		getText (_subcfg >> "displayNameDefault"),
		 		getText (_subcfg >> "condition"),
				getText (_subcfg >> "statement"),						
				_pos,
				_radius,
				getArray (_subcfg >> "drag")
		 	];
		});
	};
	_actions append ((_obj getVariable ["BW_actions", []]) apply {[_obj]+_x});
};

_actions = _actions apply {
	_modelPos = (_x#6);
	if(_modelPos isEqualType "")then{
		_modelPos = (_x#0) selectionPosition _modelPos;
	};
	_worldPos = (_x#0) modelToWorldVisual _modelPos;

	_x+[_worldPos];
};

_actions = _actions select {((_x#9) distance _refPos) < (_x#7)};

_actions = _actions select {(_x#0) call compile (_x#4)};

_actions = _actions select {
	_toPos = aglToasl (_x#9);
    _line = lineIntersectsSurfaces [aglToasl _refPos, _toPos, player, objNull, true, -1, "VIEW", "GEOM"];
    _line = _line select {!isNull (_x#3)};
    _line isEqualTo [] || {((_line#0#0) distance _toPos) < .5};
};

private _allWorldPoses = [];

_actions = _actions apply {
	_worldPos = (_x#9);
	while{{_x isEqualTo _worldPos} count _allWorldPoses > 0}do{
		_worldPos = _worldPos vectorAdd [0,0,0.2];
	};
	_allWorldPoses pushBack _worldPos;
	_x set [9, _worldPos];
	_x;
};

_actions = _actions apply {
	_x+[worldToScreen (_x#9)]
};

_actions = _actions select {!((_x#10) isEqualTo [])};

_actions = _actions apply {
	_x+[(_x#10) distance2d [.5,.5]]
};

_focusActionIndex = [_actions, false, 11] call BW_sail_fnc_findExtremeArrayIndex;

if(_focusActionIndex != -1 && {(_actions#_focusActionIndex#11) < BW_actionDistanceFocus})then{

	_focusAction = _actions deleteAt _focusActionIndex;


	BW_action_sizeLerpStart = missionNamespace getVariable ["BW_action_sizeLerpStart", diag_tickTime];

	_newActiveAction = [_focusAction#0,_focusAction # 6,_focusAction # 5,_focusAction # 8];

	if(! (BW_activeAction isEqualTo _newActiveAction))then{
		BW_action_sizelerp = diag_tickTime;
	};

	BW_activeAction = [_focusAction#0,_focusAction # 6,_focusAction # 5,_focusAction # 8];

	private _t = (((diag_tickTime - BW_action_sizelerp)*8) min 1) ^ 3;

	private _iconsize = [0,2.5,_t] call BIS_fnc_lerp;
	private _textsize = [0,.06,_t] call BIS_fnc_lerp;

	//drawIcon3D [_focusAction # 3, [1,1,1,1], _focusAction # 9, _iconsize, _iconsize, 0,_focusAction # 2, 2,_textsize, "Caveat", "center", false];

	drawIcon3D [_focusAction # 3, [1,1,1,1], _focusAction # 9, _iconsize, _iconsize, 0,"", 0,_textsize, BW_action_font, "center", false];
	drawIcon3D ["", [1,1,1,1], _focusAction # 9, _iconsize, _iconsize, 0,_focusAction # 2, true,_textsize, BW_action_font, "center", false];
}else{
	BW_activeAction = [];
};

_actions apply {
	drawIcon3D ["BW_sail\icon\action_dot.paa", [1,1,1,BW_actionMinAlpha + sunormoon*(BW_actionMaxAlpha-BW_actionMinAlpha)],_x # 9, .7, .75, 1,"", .025,.025, "TahomaB", "right", false];
};