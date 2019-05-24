params[
	"",
 	["_key", 0, [0]],
	["_shift", false, [true]],
	["_strg", false, [true]],
	["_alt", false, [true]]
];

private _akeys = actionKeys "User17";
private _actionKey = if(_akeys isEqualTo [])then{33}else{_akeys#0};

switch (_key) do
{
	case _actionKey:
	{
		BW_actionKey = false;
		if(BW_dragging)then{
			[BW_draggingData#0,2] remoteExecCall ["setOwner",2];
			["dragAction",{}] call BW_sail_fnc_stackOnEachFrame;
			BW_draggingData = [];
			BW_dragging = false;
		};
	};
};