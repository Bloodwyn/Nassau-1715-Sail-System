/*
	Author: Bloodwyn http://steamcommunity.com/profiles/76561198055205907/
*/

#define tri 0
#define jib 1
#define quad 2

#define txt(X) (getText   (_sailConfig >> X))
#define num(X) (getNumber (_sailConfig >> X))

params [
	["_ship", objNull, [objNull]],
	["_sailName", "", [""]],
	["_sideArrow", objNull, [objNull]],
	["_forwardArrow", objNull, [objNull]]
];

private _shipConfig = (configFile >> "cfgvehicles" >> (typeOf _ship) >> "CfgBWSailSystem");
if(isNull _shipConfig)exitWith{"";};

private _sailConfig = _shipConfig >> _sailName;
private _sailType = num("type");

// sail is not set
// Not all animations are in a "SET" state
if !({!(_ship animationPhase(_x)<0.01)} count (getArray (_sailConfig >> "set")) isEqualTo 0)exitWith{
	//hide both side switch pieces
	_ship animate[txt("inflateStar"),1];
	_ship animate[txt("inflateLar"),1];
	_ship animate[txt("inflate"),1];
    _ship animate[txt("noinflate"),1];
	//show triangle mesh again
	_ship setObjectTextureGlobal [num("hiddenSel"),txt("hiddenSelTexture")];
	//_forwardArrow hideObjectGlobal true;
	//_sideArrow hideObjectGlobal true;
	"";
};

private _windToShip = (winddir-(direction _ship)-180) call BW_sail_fnc_normalizeDeg;
private _sideTurn = ((_ship animationPhase txt("sideSwing")) min 1) max -1;	// clamp the values between -1 and 1 for matrix access

private _column = _windToShip/(sail_steps#1);
private _lowerIndex = (floor _column) mod 64 max 0;
private _upperIndex = ceil (_column+.000001) mod 64 max 0;


private["_lowerValueTraverse","_upperValueTraverse","_lowerValueSide","_upperValueSide"];


private _matVars = getArray(_shipConfig>>"matrices");
if(_matVars isEqualTo [])then{
	_matVars = [
		"sloop_tri_sail_traverse","sloop_tri_sail_side",
		"sloop_jib_sail_traverse","sloop_jib_sail_side",
		"sloop_quad_sail_traverse","sloop_quad_sail_side"
	];
};

private _matrix_traverse =  missionNamespace getVariable (_matVars#(_sailType*2));
private _matrix_side = 		missionNamespace getVariable (_matVars#(_sailType*2+1));

/*
switch (_sailType) do { 
	case tri : {_matrix_traverse = tri_sail_traverse; _matrix_side = tri_sail_side;}; 
	case jib : {_matrix_traverse = jib_sail_traverse; _matrix_side = jib_sail_side;}; 
	case quad : {_matrix_traverse = quad_sail_traverse; _matrix_side = quad_sail_side;}; 
	default {systemChat "Nassau :: Sail type does not exist";};
};
*/

if(_sailType isEqualTo jib)then{
	_lowerValueTraverse = _matrix_traverse # _lowerIndex;
	_upperValueTraverse = _matrix_traverse # _upperIndex;
	_lowerValueSide = _matrix_side # _lowerIndex;
	_upperValueSide = _matrix_side # _upperIndex;
}else{	
	if(_sailType isEqualTo quad)then{_sideTurn = _sideTurn*-1};
	_row = round ((_sideTurn+1)/(sail_steps#0));
	_lowerValueTraverse = _matrix_traverse # _row # _lowerIndex;
	_upperValueTraverse = _matrix_traverse # _row # _upperIndex;
	_lowerValueSide = _matrix_side # _row # _lowerIndex;
	_upperValueSide = _matrix_side # _row # _upperIndex;
};

private _part = _column - _lowerIndex;
private _matrixValueTraverse = _lowerValueTraverse*(1-_part) + _upperValueTraverse*_part;
private _matrixValueSide = 	   _lowerValueSide*(1-_part) + _upperValueSide*_part;

//private _matrixValueTraverse = _lowerValueTraverse;
//private _matrixValueSide = _lowerValueSide;

private _dmgFac = -((_ship getHitPointDamage txt("hitPoint")) - 1);

private _mulForward = _dmgfac * num("size") * power 	* getNumber(_shipConfig>>"power")     * (_ship getVariable ["BW_sail_power",1]) *	(vectorMagnitude wind) * _matrixValueTraverse;
private _mulSide = 	  _dmgfac *	num("size") * sideForce * getNumber(_shipConfig>>"sideForce") * (_ship getVariable ["BW_sail_sideForce",1]) * (vectorMagnitude wind) * _matrixValueSide;

// https://i.imgur.com/Ndfo0Ek.jpg this or the other way round depening on the wind direction in world space
private _sideForceVec = _ship vectormodeltoworld vectornormalized [_windToShip-180,0,0];

private _effectPositionModel = _ship selectionPosition txt("position");
private _effectPositionModelOffset = _effectPositionModel vectorAdd (_ship getVariable [txt("position")+"_off",[0,0,0]]);

if( (speed _ship) > (getNumber(_shipConfig>>"maxSpeed")) )then{
	_mulForward = 0;
};
_ship addForce [(vectordir _ship) vectorMultiply _mulForward,getCenterOfMass _ship];
_ship addForce [_sideForceVec 	  vectorMultiply _mulSide   ,_effectPositionModelOffset];	//TODO remove hardcoded offset


if(_sailType in [tri,jib])then{	
	if(abs(_matrixValueTraverse)<5)then{
		// [sailName0,sailName1],[timeitstarted0,timeitstarted1]
		private _currentSounds = _ship getVariable ["BW_sail_soundData",[[],[]]];

		private _index = (_currentSounds#0) find _sailName;
		if(_index > -1)then{
			if((time - (_currentSounds#1#_index)) > 8)then{
				//sound is done
				(_currentSounds#0) deleteAt _index;
				(_currentSounds#1) deleteAt _index;
			};
		}else{
			private _snds = ["1715_data\sounds\flapping1.ogg","1715_data\sounds\flapping2.ogg"];
			[selectRandom _snds, objNull, false, _ship modelToWorldWorld _effectPositionModelOffset,5,.9,130] spawn { 
				sleep random 5;
				playSound3D _this;
			};
			(_currentSounds#0) pushBack _sailName;
			(_currentSounds#1) pushBack time+ (random 3);
		};
		_ship setVariable ["BW_sail_soundData",_currentSounds];
	};

	//hide triangle mesh
	_ship setObjectTextureGlobal [num("hiddenSel"),""];
	private _windToSail = _windToShip;
	if(_sailType isEqualTo tri)then{
		private _sailAngle = num("sideSwingDeg") * (_ship animationPhase txt("sideSwing"));
		_windToSail = (_windToSail + _sailAngle) call BW_sail_fnc_normalizeDeg;
	};
	
	if (_windToSail<180)then{
		_ship animate[txt("inflateLar"),1,true];
		_ship animate[txt("inflateStar"),0,true];
	}else{
		_ship animate[txt("inflateStar"),1,true];
		_ship animate[txt("inflateLar"),0,true];
	};
}else{
	//hide triangle mesh
	_ship setObjectTextureGlobal [num("hiddenSel"),""];
	if(_matrixValueTraverse>0)then{
		_ship animate[txt("inflate"),0,true];
		_ship animate[txt("noinflate"),1,true];
	}else{
		_ship animate[txt("noinflate"),0,true];			
		_ship animate[txt("inflate"),1,true];
	};
};

_debughint = "";

if(!isNull _sideArrow && !isNull _forwardArrow)then{
	switch (_sailType) do { 
		case tri :  {
			_debughint = format["tri<br/>side:%1 | MatrixFront:%2 | ForceFront:%3<br/>MatrixSide:%4 | ForceSide:%5<br/>",
				[_sideTurn,1] call BIS_fnc_cutDecimals,
				[_matrixValueTraverse,1] call BIS_fnc_cutDecimals,
				[_mulForward,1] call BIS_fnc_cutDecimals,
				[_matrixValueSide,1] call BIS_fnc_cutDecimals,
				[_mulSide,1] call BIS_fnc_cutDecimals
			];
		}; 
		case jib :  {
			_debughint = format["jib<br/>MatrixFront:%1 | ForceFront:%2<br/>MatrixSide:%3 | ForceSide:%4<br/>",
				[_matrixValueTraverse,1] call BIS_fnc_cutDecimals,
				[_mulForward,1] call BIS_fnc_cutDecimals,
				[_matrixValueSide,1] call BIS_fnc_cutDecimals,
				[_mulSide,1] call BIS_fnc_cutDecimals
			];
		}; 
		case quad : {
			_debughint = format["quad<br/>side:%1 | MatrixFront:%2<br/>ForceFront:%3<br/>MatrixSide:%4 | ForceSide:%5<br/>",
				[_sideTurn,1] call BIS_fnc_cutDecimals,
				[_matrixValueTraverse,1] call BIS_fnc_cutDecimals,
				[_mulForward,1] call BIS_fnc_cutDecimals,
				[_matrixValueSide,1] call BIS_fnc_cutDecimals,
				[_mulSide,1] call BIS_fnc_cutDecimals
			];
		}; 
	};

	if (!(attachedTo _forwardArrow isEqualTo _ship) || !(_effectPositionModel isEqualTo _effectPositionModelOffset))then{
		_forwardArrow attachto [_ship, _effectPositionModelOffset];
	};
	
	if(_mulForward>0)then{
		_forwardArrow setVectorUp (_ship vectorWorldToModel (vectordir _ship));
  		_forwardArrow animate ["length",_mulForward/100-1,true];
  	}else{
  		_forwardArrow setVectorUp ((_ship vectorWorldToModel (vectordir _ship))vectorMultiply -1);
  		_forwardArrow animate ["length",(abs _mulForward)/100-1,true];
  	};

	if (!(attachedTo _sideArrow isEqualTo _ship) || !(_effectPositionModel isEqualTo _effectPositionModelOffset))then{
		_sideArrow attachto [_ship, _effectPositionModelOffset];
	}; 	

	if(_mulSide>0)then{
		_sideArrow setVectorUp (_ship vectorWorldToModel _sideForceVec);
  		_sideArrow animate ["length",_mulSide/100-1,true];
  	}else{
  		_sideArrow setVectorUp ((_ship vectorWorldToModel _sideForceVec)vectorMultiply -1);
  		_sideArrow animate ["length",(abs _mulSide)/100-1,true];
  	};
};

_debughint;