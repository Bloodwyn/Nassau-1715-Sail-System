params [
	["_parent",BW_cship,[objNull]],
	["_memoryPoint","",[""]],
	["_attachOffset",[0,0,0],[[]],3],
	["_objCandidates",attachedObjects BW_cship,[[]]]
];

private _pos = (_parent selectionPosition _memoryPoint) vectoradd _attachOffset;

private _objs = _objCandidates select {
	(_parent worldToModelVisual (asltoagl getPosWorldVisual _x)) distance _pos < 0.1
};
if(_objs isEqualTo [])exitWith{objNull;};
_objs#0;
