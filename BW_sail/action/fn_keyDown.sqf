params[
	"",
 	["_key", 0, [0]],
	["_shift", false, [true]],
	["_strg", false, [true]],
	["_alt", false, [true]]
];

private _shipleft = actionKeys "User1";
_shipleft = if(_shipleft isEqualTo [])then{30}else{_shipleft#0};

private _shipright = actionKeys "User2";
_shipright = if(_shipright isEqualTo [])then{32}else{_shipright#0};

private _akeys = actionKeys "User17";
_actionKey = if(_akeys isEqualTo [])then{33}else{_akeys#0};

switch (_key) do
{
	case _actionKey:
	{
		call BW_sail_fnc_OnActionKey;
		BW_actionKey = true;
		false;
	};
	case _shipleft:
	{
		if((_shipleft!=30 || _strg) && !isNull BW_cShip && {player distance (BW_cShip modelToWorld (BW_cShip selectionPosition "pos_helm"))<2 && "rudder" in (animationNames BW_anker)})then{
			_anim = (BW_cShip animationphase "wheel") - .1;
			if(_anim<-1)then{
				_anim = -1;
			};
			BW_cShip animate ["wheel", _anim];
            BW_cShip animate ["drumrope", _anim];
            BW_cShip animate ["rudder", _anim];
            true;
		};
	};
	case _shipright:
	{
		if((_shipright!=32 || _strg) && !isNull BW_cShip && {player distance (BW_cShip modelToWorld (BW_cShip selectionPosition "pos_helm"))<2 && "rudder" in (animationNames BW_anker)})then{
			_anim = (BW_cShip animationphase "wheel") + .1;
			if(_anim>1)then{
				_anim = 1;
			};
			BW_cShip animate ["wheel", _anim];
            BW_cShip animate ["drumrope", _anim];
            BW_cShip animate ["rudder", _anim];
            true;
		};
	};
	case 35:
	{
		if(_shift)then{
			player action ["SwitchWeapon", player, player, 100];
            true;
		};
	};
	default
	{
		false;
	};
};

/* Ich wusste man braucht logik noch für iwas
32 strg
0 0 1
0 1 1
1 0 0
1 1 1


!a!b + !ab + ab
!a + ab
!a + b

Test
0 0 1
0 1 1
1 0 0
1 1 1

yay
*/