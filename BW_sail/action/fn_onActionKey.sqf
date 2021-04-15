if(BW_dragging)exitWith{};
if(BW_blockAction)exitWith{};
if!(BW_activeAction isEqualTo [])exitWith{

	 _obj = BW_activeAction#0;
	 _position = BW_activeAction#1;
	 _statement = BW_activeAction#2;
	 _drag = BW_activeAction#3;

	BW_activeExternAction params[
	 "_obj",
	 "_position",
	 "_statement",
	 "_drag"
	];

	if(_drag isEqualTo [])then{
		_obj call compile _statement;
	}else{
		BW_dragging = true;
		BW_draggingData = [
			_obj,
			_drag apply{_obj animationSourcePhase _x},
			worldToScreen (_obj modelToWorldVisual (_obj selectionPosition _position)),
			_drag,
			_position,
			_obj selectionPosition _position
		];
		[_obj,clientOwner] remoteExecCall ["setOwner",2];
		["dragAction",BW_sail_fnc_dragAction] call BW_sail_fnc_stackOnEachFrame;
	};
};