params [
	["_cfg", configNull, [configNull]],
	["_entry", "", [""]]
];

private _queryResult = getArray (_cfg >> _entry >> "offset");
private _offset = if(_queryResult isEqualTo [])then{[0,0,0];}else{_queryResult;};
(_ship selectionPosition _entry) vectoradd _offset;