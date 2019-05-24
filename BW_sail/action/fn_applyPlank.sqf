params[
	["_ship", BW_cship, [objNull]],
	["_pos", "", [""]]
];

private _p = "1715_plank_4m" createVehicle [0,0,0];

private _modelPos = [0,0,1.6] vectoradd (_ship selectionPosition _pos);
private _xdis = _modelPos#0;
private _xdir = _xdis/abs(_xdis);
_modelPos set [0,_xdis+_xdir*1];
_p setposworld (_ship modelToWorldVisual  _modelPos);


_p setVectorDir (_ship vectorModelToWorld [_xdir,0,0]);

_p setVectorup (_ship vectorModelToWorld [-_xdir*.5,0,1]);

_p setVelocity (Velocity _ship);

_ship setVariable["planks",(_ship getVariable ["planks",0])-1,true];

WMO_specialobjects pushBackUnique ("1715_plank_4m");