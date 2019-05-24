/*
    Author: Bloodwyn http://steamcommunity.com/profiles/76561198055205907/

    Description:
    Used to get the maximum value from an array inside an array.
*/

_array = param [0, [], [[]]];
_max = param [1, true, [true]]; // max or min?
_index = param [2, 0, [0]]; // index to compare

if (_array isEqualTo [])exitWith{throw "array is empty"};

_array apply{[_x#_index]+_x};
_array sort _max;

_array deleteAt 0;
_array;