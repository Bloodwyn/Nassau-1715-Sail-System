params [   
  ["_array", [], [[]]],   
  ["_getMax", true, [true]], 
  ["_compareIndex", 0, [0]] 
]; 
if(_array isEqualTo [])exitWith{-1}; 
if((count (_array#0)-1) < _compareIndex )exitWith{-1}; 
 
_extremeIndex = 0; 
 
if(_getMax)then{ 
  for "_i" from 1 to (count _array)-1 step 1 do { 
    if((_array#_i#_compareIndex) > (_array#_extremeIndex#_compareIndex))then{ 
      _extremeIndex = _i; 
    }; 
  }; 
}else{ 
  for "_i" from 1 to (count _array)-1 step 1 do { 
    if((_array#_i#_compareIndex) < (_array#_extremeIndex#_compareIndex))then{ 
      _extremeIndex = _i; 
    }; 
  }; 
}; 
_extremeIndex;