params[
	["_obj1", BW_cship, [objNull]],
	["_point1", "", [""]],
	["_obj2", BW_cship, [objNull]],
	["_point2", "", [""]]
];

if([_obj1,_point1]call BW_sail_fnc_hasRope)exitWith{false};
if([_obj2,_point2]call BW_sail_fnc_hasRope)exitWith{false};

if( (_obj1 modelToWorldVisual (_obj1 selectionPosition _point1)) distance (_obj2 modelToWorldVisual (_obj2 selectionPosition _point2)) >= 100)exitWith{false};	//rope would be too long
true;