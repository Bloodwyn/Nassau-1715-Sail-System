_offset = param [0, 0, [0]];	//in s
_code = param [1, {}, [{}]];
_params = param [2, [], [[]]];

if(_code isEqualTo {})exitWith{};
if(_offset <= 0)exitWith{_params call _code};

BW_waitUntilTimeData pushBack [time + _offset, _code, _params];
BW_waitUntilTimeData sort true;