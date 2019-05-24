private _id = toLower param [0, "default", [""]];
private _code = param [1, {}, [{}]];

private _index=-1;
{
	if((_x select 0) isEqualTo _id)exitWith{
		_index = _foreachindex;
	};
}foreach BW_OnEachFrameScripts;

if (_index isEqualTo -1)exitWith{
	if !(_code isEqualTo {})then{
		BW_OnEachFrameScripts pushBack [_id,_code];
	};
};
if (_code isEqualTo {})then{
	BW_OnEachFrameScripts = BW_OnEachFrameScripts - [BW_OnEachFrameScripts select _index];
}else{
	BW_OnEachFrameScripts set [_index,[_id,_code]];
};
