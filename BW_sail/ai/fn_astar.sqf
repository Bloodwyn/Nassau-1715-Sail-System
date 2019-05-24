/*
	Node
	{
		fGlobalGoal;				// Distance to goal so far
		fLocalGoal;				// Distance to goal if we took the alternative route
		[x,y]
		Node* parent;					// Node connecting to this node that offers shortest parent
		bool visit;	// Connections to neighbours
	};
*/

BW_intoWindDotBorder = -.8;

_startPos = param [0, [0,30000], [[]]];
_startPos resize 2;

_endPos = param [1, [0,0], [[]]];
_endPos resize 2;

_gridSize = param [2, 1000, [0]];

_handle = param [3, 0, [0]];

_var = param [4, "path", [""]];

_startpos = _startpos 	apply {(round ((_x) / _gridSize))*_gridSize};
_endPos = 	_endPos 	apply {(round ((_x) / _gridSize))*_gridSize};

systemChat format ["%1 %2",_startpos,_endPos];

_wind = (vectorNormalized wind);

/*
_m = createMarker [format ["start%1", diag_frameno], _startpos];
_m setMarkerShape "RECTANGLE";
_m setMarkerSize [_gridSize/2, _gridSize/2];
_m setMarkerColor "ColorGreen";

_m = createMarker [format ["end%1", diag_frameno], _endPos];
_m setMarkerShape "RECTANGLE";
_m setMarkerSize [_gridSize/2, _gridSize/2];
_m setMarkerColor "ColorGreen";
*/

_nodes = [
	[_startPos distance2D _endPos,0,_startPos,-1,false]
];


_current = 0;	//"pointer" to the first node;

_notTested = [0];

while {!(_notTested isEqualTo []) && !(_nodes#_current#2 isEqualTo _endPos)}do{

	_notTested = [_notTested, [], {_nodes#_x#0}, "ASCEND"] call BIS_fnc_sortBy;

	while {!(_notTested isEqualTo []) && {(_nodes#(_notTested#0)#4)}}do{
		_notTested deleteAt 0;
	};

	if(_notTested isEqualTo []) exitwith{};

	_current = _notTested#0;
	_nodes#_current set [4,true];
	_currentPos = _nodes#_current#2;
	_currentPosAsl = [_currentPos#0,_currentPos#1,0];

/*
		_m = createMarker [format["m%1%2a",_current,diag_frameno], _nodes#_current#2];
		_m setMarkerShape "RECTANGLE";
		_m setMarkerSize [_gridSize/2, _gridSize/2];
		_m setMarkerColor "ColorBlue";
		_m setMarkerAlpha .2;
*/

	/*	XXX
		XOX
		XXX	*/
	[[1,1],[1,-1],[-1,1],[-1,-1],
	[1,0],[0,1],[-1,0],[0,-1]] apply {	//loop through neigs
		_checkPos = [[_x,_gridSize] call BIS_fnc_vectormultiply, _currentPos] call BIS_fnc_vectorAdd; // (_x*_gridSize) + _currentpos
		_checkPosAsl = [_checkPos#0,_checkPos#1,0];

		_dot = _wind vectorDotProduct ((vectorNormalized [_x#0,_x#1,0]));

		if(
			_dot >= BW_intoWindDotBorder &&
			{getTerrainHeightASL _checkPos < -5} &&
			{(_checkPos#0)>=0} &&
			{(_checkPos#1)>=0} &&
			{(_checkPos#0)<worldSize} &&
			{(_checkPos#1)<worldSize} &&
	    	{!(terrainIntersectASL [_currentPosAsl, _checkPosAsl])}
		)then{ // is no obstacle
			_nodeNeighbour = -1;
			{
				if((_x#2) isEqualTo _checkPos)exitWith{
					_nodeNeighbour = _foreachindex;
				};
			}foreach _nodes;

			if(_nodeNeighbour == -1)then{
				_nodes pushBack [1e39,1e39, _checkPos,-1,false];
				_nodeNeighbour = (count _nodes)-1;
				_notTested pushBack _nodeNeighbour;
			};

			_w = 0.75*((_dot - 0.1547)^2)+1;

			_possiblyLowerGoal = _nodes#_current#1 + (((_nodes#_current#2) distance2d _checkPos) * _w);
			if (_possiblyLowerGoal < _nodes#_nodeNeighbour#1)then{
				(_nodes#_nodeNeighbour) set [3,_current];
				(_nodes#_nodeNeighbour) set [1, _possiblyLowerGoal];
				(_nodes#_nodeNeighbour) set [0, _possiblyLowerGoal + ((_nodes#_nodeNeighbour#2) distance2d _endPos)];
			};
		};
	};
};

if(!(_nodes#_current#2 isEqualTo _endPos))then{	//end was never reached, search for closest node instead
	_current = 0;
	_minValue = 1e39;
	{
		if(_x#0<_minValue)then{
			_minValue = _x#0;
			_current =	_foreachindex;
		};
	}foreach _nodes;
};

_path = [];
while{_current > 0}do{
	_path pushBack (_nodes#_current#2);

	_m = createMarker [format["m%1%2",_current,diag_frameno], _nodes#_current#2];
	_m setMarkerShape "RECTANGLE";
	_m setMarkerSize [_gridSize/2, _gridSize/2];
	_m setMarkerColor "ColorRed";

	_current = _nodes#_current#3;
};

//reverse _path;

_handle setFSMVariable [_var,_path];

hint "finished a star";

systemChat "finished a star";