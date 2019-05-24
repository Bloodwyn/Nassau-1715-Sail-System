#define TXT 0
#define ICON 1
#define RESCODE 2
#define CONDITION 3
#define MPOS 4
#define DRAG 5
#define RADIUS 6
#define WPOS 7

if(BW_dragging)exitWith{};
if(BW_blockAction)exitWith{};

_obj = param [0, objNull, [objNull]];

private _actions = _obj getVariable ["BW_sail_ExternalActions",[]];

if(_actions isEqualTo [])then{
	private _config = configFile >> "cfgvehicles">> typeOf _obj>> "SailActionsExternal";

	_actions = (_config call BIS_fnc_getCfgSubClasses) apply{
		[
			getText (_config >> _x >> "displayName"),
			getText (_config >> _x >> "displayNameDefault"),
			getText (_config >> _x >> "statement"),
			compile(getText(_config >> _x >> "condition")),
			getText (_config >> _x >>"position"),
			getArray (_config >> _x >> "drag"),
			getNumber (_config >> _x >> "radius")
		];
	};
	_obj setVariable ["BW_sail_ExternalActions",_actions];
};

private _pos = getposasl player;
private _trueActions = _actions select {
	(_obj call _x # CONDITION) &&
	(_pos distance (_obj modelToWorldVisualWorld (_obj selectionPosition (_x#MPOS))) <= (_x # RADIUS))
};

private _bestCenteredActionIndex = -1;
private _bestDisToCenter = 1e10;

{
	private _world = _obj modelToWorldVisual (_obj selectionPosition (_x#MPOS));
	private _screen = worldToScreen _world;

	if (_screen isEqualTo [])then{_screen = [1e10,1e10];};

	private _disToCenter = _screen distance2D [0.5,0.5];

	if(_disToCenter<BW_actionDis2 && _disToCenter<_bestDisToCenter)then{
		_bestCenteredActionIndex = _foreachIndex;
		_bestDisToCenter = _disToCenter;
	};

	_trueActions set [_foreachIndex,_x+[_world]];
}foreach _trueActions;

private _focusAction = _trueActions deleteAt _bestCenteredActionIndex;


if(!isnil "_focusAction" && BW_activeAction isEqualTo [])then{
	BW_activeExternAction = [_obj,_focusAction # MPOS,_focusAction # RESCODE,_focusAction # DRAG];
	drawIcon3D [_focusAction # ICON, [1,1,1,1], _focusAction # WPOS, 2.5, 2.5, 1,_focusAction # TXT, .05,.05, "TahomaB", "right", true];
}else{
	BW_activeExternAction = [];
};

_trueActions apply{drawIcon3D ["iconExplosiveAT", [1,1,1,.9],_x # WPOS, .7, .75, 1,"", .025,.025, "TahomaB", "right", true];};

false;