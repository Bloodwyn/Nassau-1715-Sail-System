		_xp = _this#0;
		_yp = _this#1;
		_mat = _this#2;
		_text1 = "<t color='#FFFFFF' shadow='2'>";

		{
			_xc = _foreachindex;
			{

				if(_xc == _xp && _foreachindex == _yp)then{
					_text1 = _text1 + format ["</t><t color='#FF0000' shadow='2'>%1</t><t color='#FFFFFF' shadow='2'>",_x];
				}else{
					_text1 = _text1 + format ["%1",_x];
				};
				if(_x < 10)then{
					_text1 = _text1 + "  ";
				};
				if(_x < 100)then{
					_text1 = _text1 + "  ";
				}
			}foreach _x;
			_text1 = _text1 + "<br/>";
		}foreach quad_sail_traverse;

		_text1 = _text1 + "</t>";

		_ctrl = findDisplay 46 ctrlCreate ["RscStructuredText", -1];

		//_ctrl ctrlSetPosition [0,0,0,0.1];
		_ctrl ctrlSetStructuredText parseText _text1;
		_ctrl ctrlSetPosition [-.5,-.15,109,ctrlTextHeight _ctrl];
		_ctrl ctrlCommit 0;

		waitUntil {ctrlCommitted _ctrl};
		sleep 0.4;
		ctrlDelete _ctrl;
