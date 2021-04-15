params [
	["_array",[],[[]]],
	["_key",[],[[]]],
	["_keyIndex",0,[0]]
];

if(_array isEqualTo [])exitWith{_array;};

_index = _array findIf {(_x#_keyIndex) isEqualTo _key};

if(_index > -1)then{
	_array deleteAt _index;
};

_array;