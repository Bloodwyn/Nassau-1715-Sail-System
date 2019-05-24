private _ship = param [0, objNull, [objNull]];

if(isNull (configFile >> "cfgvehicles" >> typeOf _this >> "CfgBWSailSystem"))exitWith{};

BW_cShip = _ship;


private _con = (configfile >> "cfgvehicles">> typeof _ship >> "SailActions");

private _allposes = []; //wip should be removed
BW_ActionData = ((_con call BIS_fnc_getCfgSubClasses) apply{
  private _aclass = _x;
  private _img = getText(_con >> _aclass >> "displayNameDefault");
  private _pos = _ship selectionPosition (getText(_con >> _aclass >> "position"));
  while{{_x distance _pos<0.1} count _allposes > 0}do{
    _pos = _pos vectorAdd [0,0,0.2];
  };
  _allposes pushBack _pos;
  if(_img isEqualTo "")then{_img = "BW_sail\icon\placeholder.paa"}else{_img};
  [
    _pos,
    _img,
    getText(_con >> _aclass >> "displayName"),
    compile getText(_con >> _aclass >> "condition"),
    compile getText(_con >> _aclass >> "statement")
  ];
});


private _con2 = (configfile >> "cfgvehicles">> typeof _ship >> "RopeAttach");
if(isNull _con2)exitWith{};
private _a = getArray _con2;
if(_a isEqualTo [])exitWith{};
private _img = "BW_sail\icon\placeholder.paa";
_a apply {
  private _pos = _ship selectionPosition _x;
  while{{_x distance _pos<0.1} count _allposes > 0}do{
    _pos = _pos vectorAdd [0,0,0.2];
  };
  _allposes pushBack _pos;
  BW_ActionData pushBack
    [
      _pos,
      "\1715_sloops\actionicons\rope_attach_ca.paa",
      "attach rope",
      /*  has a rope in hand AND is not on the ship where the rope starts AND the current ropepoint has no rope yet */
      compile format ["!(BW_sail_ropeMode isEqualTo []) &&
          {!((BW_sail_ropeMode#0) isEqualTo BW_cShip)} &&
          ({_x#0 isEqualTo ""%1""} count (_this getVariable [""ropes"",[]]) isEqualTo 0)",_x],
      compile format ["[_this,""%1""] call BW_sail_fnc_exitRopeMode;", _x]
    ];
  BW_ActionData pushBack
    [
      _pos,
      "\1715_sloops\actionicons\rope_dettach_ca.paa",
      "take rope",
      compile format ["
          _ropesAtPoint = ((_this getVariable [""ropes"",[]]) select {_x#0 isEqualTo ""%1""});
          BW_sail_ropeMode isEqualTo [] && {_ropesAtPoint isEqualTo [] || {!((_ropesAtPoint#0#3) isEqualTo """")}}",_x],
      compile format ["[_this,""%1""] call BW_sail_fnc_enterRopeMode;", _x]
    ];
  BW_ActionData pushBack
    [
      _pos vectoradd [0,0,.2],
      "\1715_sloops\actionicons\rope_dettach_ca.paa",
      "shorten rope",
      /*  has NO rope in hand AND the current ropepoint HAS a rope */
      compile format ["BW_sail_ropeMode isEqualTo [] &&
                       ({_x#0 isEqualTo ""%1""} count (_this getVariable [""ropes"",[]]) > 0)"
                      ,_x],
      compile format ["[_this,""%1"",false] call BW_sail_fnc_resizeRope;", _x]
    ];
  BW_ActionData pushBack
    [
      _pos vectoradd [0,0,.4],
      "\1715_sloops\actionicons\rope_dettach_ca.paa",
      "lengthen rope",
      /*  has NO rope in hand AND the current ropepoint HAS a rope */
      compile format ["BW_sail_ropeMode isEqualTo [] &&
                       ({_x#0 isEqualTo ""%1""} count (_this getVariable [""ropes"",[]]) > 0)"
                      ,_x],
      compile format ["[_this,""%1"",true] call BW_sail_fnc_resizeRope;", _x]
    ];
  BW_ActionData pushBack
    [
      _pos vectoradd [0,0,.6],
      "\1715_sloops\actionicons\rope_dettach_ca.paa",
      "delete rope",
      /*  the current ropepoint HAS a rope AND has NO rope in hand */
      compile format ["({_x#0 isEqualTo ""%1""} count (_this getVariable [""ropes"",[]]) > 0) && BW_sail_ropeMode isEqualTo []",_x],
      compile format ["[_this,""%1""] call BW_sail_fnc_removeRope;", _x]
    ];
    BW_ActionData pushBack
    [
      _pos,
      "\1715_sloops\actionicons\rope_dettach_ca.paa",
      "stow rope",
      /* rope in hand && rope in hand is attached to point */
      compile format ["!(BW_sail_ropeMode isEqualTo []) && {BW_sail_ropeMode#0 isEqualTo _this && BW_sail_ropeMode#1 isEqualTo ""%1""}",_x],
      {[OBJNULL, ""] call BW_sail_fnc_exitRopeMode;}//WTF MAN this didnt work without
    ];
};

//({_x#0 isEqualTo ""%1""} count (_this getVariable [""ropes"",[]]) isEqualTo 0)

// || {!((BW_sail_ropeMode#0) isEqualTo BW_cShip)}