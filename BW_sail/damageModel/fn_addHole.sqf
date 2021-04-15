params ["_target","_position","_vector","_surfaceType"];

_dist = (_position select 2) max 0.5;
_holeWeight = (0.5/_dist)^2;
//hintsilent str _holeWeight;
//systemChat format ["distance: %1 holeWeight: %2 holes: %3 runs: %4", _dist, _holeWeight, (_target getVariable ["holes",0]), (_target getVariable ["runs",0])];

_target setVariable["holes",(_target getVariable ["holes",0]) + _holeWeight,true];