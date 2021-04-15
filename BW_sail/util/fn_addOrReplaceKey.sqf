params [
	["_array",[],[[]]],
	["_newElement",[],[[]]],
	["_keyIndex",0,[0]]
];

if(_array isEqualTo [])exitWith{
	_array = [_newElement];
	_array;
};

if(_keyIndex<0)exitWith{_array;};

if((count _newElement)-1 < _keyIndex)exitWith{_array;};

_index = _array findIf {(_x#_keyIndex) isEqualTo (_newElement#_keyIndex)};

if(_index ==  -1)exitWith{
	_array pushBack _newElement;
	_array;
};

_array set [_index, _newElement];

_array;