	//init cam -----------------

	BW_climbCam = "camera" camcreate [0,0,0];

	BW_climbCam attachto [player,conClimbCamOff];
	//BW_climbCam cameraeffect ["internal", "back"];
	showCinemaBorder false;

	BW_climbCamDirX = 0;
	BW_climbCamDirY = 0;

	BW_climbCamEvh = (findDisplay 46) displayAddEventHandler ["MouseMoving",{
		_posx = param[1,0,[0]]*.5;
		_posy = param[2,0,[0]]*-.5;
		BW_climbCamDirX = BW_climbCamDirX+_posx;
		BW_climbCamDirY = BW_climbCamDirY+_posy;
		if(abs BW_climbCamDirY>65)then{
			BW_climbCamDirY = BW_climbCamDirY-_posy;
		};
		_vecDir = [sin BW_climbCamDirX,cos BW_climbCamDirX,sin BW_climbCamDirY];
		BW_climbCam setVectorDirAndUp [_vecDir,(_vecDir vectorCrossProduct [0,0,1])vectorCrossProduct _vecDir];
	}];


			_testsP = getposasl BW_climbCam;
		_testeP = _testsP vectoradd ((vectordir BW_climbCam) vectorMultiply 20);

		_l = lineIntersectsSurfaces [_testsP,_testeP, objNull, objNull, true, 1, "GEOM", "VIEW"]select{!(_x#2 isEqualTo player)};
		//systemChat str _l;
		if!(_l isEqualTo [])then{
			sphere setposasl (_l#0#0);
		};
