conClimbDis = .4;
conClimbCamOff = [0,-2,1.6];
conClimbPower = 0.55;

checkDis = 0.05;

fnc_anim = {
	_anim = param [0, "", [""]];

	if!(animationState player isEqualTo _anim)then{
		player playMoveNow _anim;
	};
};

initClimb={

	sloop enableSimulation true;
	player disableCollisionWith sloop;

	_startPos = positionCameraToWorld [0,0,0];
	_endPos = positionCameraToWorld [0,0,10];
//ar setposasl _endPos;
	_line = lineIntersectsSurfaces [_startPos,_endPos, player, objNull, true, 1, "GEOM", "NONE"];
	if(_line isEqualTo [])exitWith{systemchat "1";};
	(_line#0)params["_intersectPos","_nom","","_obj"];
	BW_climbObj = _obj;

	_line2 = [BW_climbObj,"GEOM"]intersect[_startPos,_endPos] select {(_x#0) find "ladder_" > -1};

	if(_line2 isEqualTo [])exitWith{systemchat "2";};
	BW_currentClimbSel = _line2#0#0;


	BW_normalWorldInit = _nom;
	BW_climbNormal = _obj worldToModelVisual ((_obj modelToWorldVisualWorld [0,0,0])vectoradd _nom);

	_nomI = _nom vectorMultiply -1;
	//_nomI = _nom;

	BW_climbNormalUp = _obj worldToModel ((_obj modelToWorldVisualWorld [0,0,0])vectoradd ((_nomI vectorCrossProduct [0,0,1])vectorCrossProduct _nomI));
	BW_climbNormalInv = _obj worldToModel ((_obj modelToWorldVisualWorld [0,0,0])vectoradd _nomI);

	BW_climbPos = _obj worldToModelVisual ((asltoagl _intersectPos) vectoradd (_nom vectorMultiply conClimbDis));
	BW_climbUp = vectorNormalized((BW_climbNormal vectorCrossProduct[0,0,1])vectorCrossProduct BW_climbNormal);
	BW_climbLeft = vectorNormalized(BW_climbNormal vectorCrossProduct[0,0,1]);



	//init key evhs

	BW_KeysD = [];
	BW_climbKeydownEvh = (findDisplay 46) displayAddEventHandler ["keyDown",{
		_key = param [1,0, [0]];
		if (_key in [17,30,31,32])then{
			BW_KeysD pushBackUnique _key;
		};
		if(_key isEqualTo 1)then{
			//call exitClimb;
		};
	}];

	BW_climbKeyupEvh = (findDisplay 46) displayAddEventHandler ["keyUp",{
		_key = param [1,0, [0]];
		BW_KeysD = BW_KeysD - [_key];
	}];

	sphere = "Sign_Sphere10cm_F" createVehicle [0,0,0];

	add = 0.1;

	onEachFrame{


		_dirWorld = (sloop modelToWorldVisualWorld BW_climbNormalInv) vectorDiff (sloop modelToWorldVisualWorld [0,0,0]);
		_upWorld = (sloop modelToWorldVisualWorld BW_climbNormalUp) vectorDiff (sloop modelToWorldVisualWorld [0,0,0]);

		//check if player is still attached

		if!(count BW_KeysD isEqualTo 0)then{
			if(30 in BW_KeysD && !(32 in BW_KeysD))then{
				_ls = (player modelToWorldVisual [-checkDis,0,1])vectoradd (velocity sloop vectorMultiply add);
				_line = [BW_climbObj,"GEOM"]intersect[_ls,_ls vectoradd (vectorDir player)]select {(_x#0) isEqualTo BW_currentClimbSel};
				if!(_line isEqualTo [])then{
					BW_climbPos = BW_climbPos vectoradd (BW_climbLeft vectorMultiply (conClimbPower/diag_fps));
					"ladderrifleuploop" call fnc_anim;
				};
			};
			if(32 in BW_KeysD && !(30 in BW_KeysD))then{
				_ls = (player modelToWorldVisual [checkDis,0,1]) vectoradd (velocity sloop vectorMultiply add);
				_line = [BW_climbObj,"GEOM"]intersect[_ls,_ls vectoradd (vectorDir player)]select {(_x#0) isEqualTo BW_currentClimbSel};
				if!(_line isEqualTo [])then{
					BW_climbPos = BW_climbPos vectoradd (BW_climbLeft vectorMultiply -(conClimbPower/diag_fps));
					"ladderrifleuploop" call fnc_anim;
				};
			};
			if(17 in BW_KeysD && !(31 in BW_KeysD))then{
				_ls = (player modelToWorldVisual [0,0,checkDis+1]) vectoradd (velocity sloop vectorMultiply add);
				_line = [BW_climbObj,"GEOM"]intersect[_ls,_ls vectoradd (vectorDir player)]select {(_x#0) isEqualTo BW_currentClimbSel};
				if!(_line isEqualTo [])then{
					BW_climbPos = BW_climbPos vectoradd (BW_climbUp vectorMultiply (conClimbPower/diag_fps));
					"ladderrifleuploop" call fnc_anim;
				};
			};
			if(31 in BW_KeysD && !(17 in BW_KeysD))then{
				_ls = (player modelToWorldVisual [0,0,-checkDis+1]) vectoradd (velocity sloop vectorMultiply add);
				_line = [BW_climbObj,"GEOM"]intersect[_ls,_ls vectoradd (vectorDir player)]select {(_x#0) isEqualTo BW_currentClimbSel};
				if!(_line isEqualTo [])then{
					BW_climbPos = BW_climbPos vectoradd (BW_climbUp vectorMultiply -(conClimbPower/diag_fps));
					"ladderrifledownloop" call fnc_anim;
				};
			};

		}else{
			"ladderriflestatic" call fnc_anim;
		};




		hintSilent str BW_climbPos;
		player setPosWorld (sloop modelToWorldVisualWorld BW_climbPos);



		_startpos = (player modelToWorldVisual [0,0,0]);

		drawLine3D[_startpos, _startpos vectoradd (_dirWorld vectorMultiply 5),[1,0,0,1]];
		drawLine3D[_startpos, _startpos vectoradd (_upWorld vectorMultiply 5),[1,1,0,1]];
		player setVectorDirAndUp[_dirWorld,_upWorld];
		//player attachto [BW_climbObj,BW_climbPos];
		//player setVectorDirAndUp [BW_climbNormalInv,(BW_climbNormalInv vectorCrossProduct[0,0,1])vectorCrossProduct BW_climbNormalInv];
		if(getposatl player#2 < -0.1)then{
			//call exitClimb;
		};
		//detach player;
	};
	sloop setposasl [0,0,0];

};


exitClimb = {
	detach player;
	player switchMove "";
	_pos = getPosWorld player;
	_pos set [2,0];
	player setposatl _pos;
	BW_climbCam cameraeffect ["terminate", "back"];
	camDestroy BW_climbCam;
	(findDisplay 46) displayRemoveEventHandler ["MouseMoving",BW_climbCamEvh];
	(findDisplay 46) displayRemoveEventHandler ["keyDown",BW_climbKeydownEvh];
	(findDisplay 46) displayRemoveEventHandler ["keyUp",BW_climbKeyupEvh];
	onEachFrame{};
};

call initClimb;