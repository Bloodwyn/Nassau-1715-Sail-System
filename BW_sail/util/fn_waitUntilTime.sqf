if(BW_waitUntilTimeData isEqualTo [])exitWith{};
_first = BW_waitUntilTimeData#0;
if(_first#0 <= time)exitWith{
	_first#2 call _first#1;
	BW_waitUntilTimeData deleteAt 0;
};