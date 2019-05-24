/*
    Author: Bloodwyn http://steamcommunity.com/profiles/76561198055205907/
    This is heavy wip. Beware of ugly code, strange math and cruel variable names.


if(!canSuspend)exitWith{
	_this spawn BW_sail_fnc_mainSail;
};
_ship = param [0, objNull, [objNull]];

if!(local _ship)exitWith{};
if!(_ship isKindOf "ship")exitWith{};


while {!(isNull _ship) && (local _ship) && (alive _ship)} do
{
    {
        _setAnim =       _x param [0, "", [""]];
        _pos =           _x param [1, "", [""]];
        _sideTurnAnim =  _x param [2, "", [""]];
        _sideSwitchStar =_x param [3, "", [""]];
        _sideSwitchLar = _x param [4, "", [""]];
        _size =          _x param [5,  0, [0]]; // in square meters (estimation)
        _turnDeg =       _x param [6,  0, [0]]; //https://i.imgur.com/zY8ijJa.png
        _selection =     _x param [7,  0, [0]]; //hiddenSelection
        _texture =       _x param [8, "", [""]];

    	if(_ship animationPhase(_setAnim)<0.01)then{//sail is set
            _windFrom = (winddir-(direction _ship)-180);
            _windFrom=_windFrom call BW_sail_fnc_normalizeDeg;
            if!(_sideSwitchStar isEqualTo "")then{
                _moveIt = _turnDeg*(_ship animationPhase _sideTurnAnim);
                _test = (_windFrom+_moveIt) call BW_sail_fnc_normalizeDeg;
               // if(_sideTurnAnim != "")then{hintSilent format["%1\n%2\n%3\n%4",_test>180,_back,_windFrom,"?"];};
                if(_test<180)then{
                    if (_ship animationPhase _sideSwitchStar == 1)then{
                        hint _sideSwitchStar;
                        _ship setObjectTextureGlobal [_selection,""];
                        _ship animate[_sideSwitchLar,1,true];
                        _ship animate[_sideSwitchStar,0,true];
                    };
                }else{
                    if (_ship animationPhase _sideSwitchLar == 1)then{
                        hint _sideSwitchLar;
                        _ship setObjectTextureGlobal [_selection,""];
                        _ship animate[_sideSwitchStar,1,true];
                        _ship animate[_sideSwitchLar,0,true];
                    };
                };
            };
            _sideTurn = 0;
            if(_sideTurnAnim isEqualTo "")then{
                _sideTurn = (-1*(_ship animationPhase _sideSwitchLar)+((_ship animationPhase (_sideSwitchStar))));
            }else{
                _sideTurn = _ship animationPhase (_sideTurnAnim);
            };
            _effect =_size*Power*(vectorMagnitude wind)*((-sin deg(0.05235*_windFrom-7.85398)*(0.4-0.4*abs(_sideTurn))+1.2)*(-0.0000308*(_windFrom-180)^(2)+1)+(rad atan(0.1*_windFrom-18+1.5*_sideTurn)*_sideTurn*0.3-0.7));
            _force = ((vectordir _ship)vectorMultiply _effect);
            _ship addForce [((vectordir _ship)vectorMultiply _effect),(_ship selectionPosition "zamerny")];
            _ship addForce [(wind vectorMultiply _effect*sideForce),(_ship selectionPosition _pos)];
            //_ship addForce [wind vectorMultiply (vectorMagnitude _force * windp),(_ship selectionPosition "zamerny") vectoradd [0,0,15]];
            //hintSilent format["sail debug\nwind: %1\nsail:%2\neffect: %3",_windFrom,_sideTurn,_effect];
        }else{
            if!(_sideSwitchStar isEqualTo "")then{
                _ship animate[_sideSwitchStar,1];
                _ship animate[_sideSwitchLar,1];
                _ship setObjectTextureGlobal [_selection,_texture];
            };
        };
    }forEach sails;
    _ship addTorque[0,0,(_ship animationPhase "rudder") * speed _ship * sidePower];
    sleep sleepTime;
};
if!(isNull ship)then{
	[_ship] remoteExec["BW_sail_fnc_mainSail",_ship];
};



(findDisplay 46) displayAddEventHandler ["keydown",{
    _key = param [1, 0, [0]];
    if(_key in [30,32] && (player distance (BW_anker modelToWorld (BW_anker selectionPosition "pos_helm"))<2) && {"rudder" in (animationNames BW_anker)})then{
        if(_key isEqualTo 32 && (BW_anker animationPhase "wheel" < 1))then{
            BW_anker animate ["wheel", (BW_anker animationphase "wheel") + .1];
            BW_anker animate ["drumrope", (BW_anker animationphase "drumrope") + .05];
            BW_anker animate ["rudder", (BW_anker animationphase "rudder") + .1];
        };
        if(_key isEqualTo 30 && (BW_anker animationPhase "wheel" > -1))then{
            BW_anker animate ["wheel", (BW_anker animationphase "wheel") - .1];
            BW_anker animate ["drumrope", (BW_anker animationphase "drumrope") - .05];
            BW_anker animate ["rudder", (BW_anker animationphase "rudder") - .1];
        };
        true;
    }else{
        false;
    };
}];


["sail_topsail_clew_lar","sail_topsail_clew_star","yard_topsail_halliard"]apply{cursorObject animate [_x,0]};

//BW_anker animate ["rudder",(BW_anker animationPhase "rudder")+(_key-31)*0.1];


                statement="";
            };
            class helm_lar
            {
                displayName="Helm to Larboard";
                displayNameDefault="<img image='\1715_sloops\icons\icon_helmtolar_ca.paa' size='3' />";
                position="pos_helm";
                hideOnUse=0;
                shortcut="user1";
                radius=1.5;
                onlyForplayer=0;
                condition="this animationPhase ""helm"" > -1";
                statement="this animate [""wheel"", (this animationphase ""wheel"") - .1],this animate [""drumrope"", (this animationphase ""drumrope"") - .05],this animate [""rudder"", (this animationphase ""rudder"") - .1]";
            };


            */