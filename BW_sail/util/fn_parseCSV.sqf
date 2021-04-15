private _csv = param [0, "",[""]];
if(_csv isEqualTo "")exitWith{["CSV Parser :: string is empty"] call BIS_fnc_error;};

_matrix = (_csv splitString (toString [10])) select {
	count _x > 1;
} apply {
	(_x splitString ";") apply {
		parseNumber _x;
	};
};

if(count _matrix isEqualTo 1)then{
	_matrix#0;
}else{
	_matrix;
};