power = 1;
sidepower = 1;

lastWind = windDir;
["gen",{
	0 setWindDir lastWind;
	0 setWindStr 7;
	forceWeatherChange;
	lastWind = lastWind+.2;
}] call BW_sail_fnc_stackOnEachFrame;

call BW_sail_fnc_setallsails;
call BW_sail_fnc_showsaildebug;

BW_sail_fnc_simulateSailt = compile preprocessFileLineNumbers "fn_simulateSail.sqf";





0 setwaves 1; 0 setOvercast 1; 0 setrain 1; forceWeatherChange; setViewDistance 1500; power = .5; sideforce = .5;



valor_intro_cam = "camera" camCreate [0, 0, 0];
valor_intro_cam cameraEffect ["Internal", "BACK"];
valor_intro_cam camSetFocus [-1, -1];
showCinemaBorder false;

["cam",{
	valor_intro_cam camSetPos (BW_cship modelToWorldVisualWorld [30,0,5]);
	valor_intro_cam camSetTarget  (BW_cship modelToWorldVisualWorld [0,0,0]);
	valor_intro_cam camCommit 1;
}] call BW_sail_fnc_stackOnEachFrame;