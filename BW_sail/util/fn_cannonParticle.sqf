/*
    Author: Bloodwyn http://steamcommunity.com/profiles/76561198055205907/

    Description:
   	Needs some Love.
*/
private _projectile = _this#6;
if!(isNull _projectile)then{
	private _s = "#particlesource" createVehicleLocal (eyePos player);
	_s setParticleParams[
		["\A3\data_f\ParticleEffects\Universal\Universal.p3d",16,8,32,1],"",//Sprite
		"Billboard",//Type
		1,//TimmerPer
		4,//Lifetime
		[0,0,0],//Position
		[0,0,0],//MoveVelocity
		1,1.30,1,1,//rotationVel,weight,volume,rubbing//Simulation
		[1,.9,1,.9],//Scale
		[[.7,.7,.7,.1]],//Color
		[1.5,0.5],//AnimSpeed
		0.01,//randDirPeriod
		0.08,//randDirIntesity
		"",//onTimerScript
		"",//DestroyScript
		_projectile,//Follow
		0,	//Angle
		false,//onSurface
		-1,//bounceOnSurface
		[[1,.5,.5,1]]//emissiveColor
	];
	_s setDropInterval 0.003;
	[_projectile,_s] spawn{
		waitUntil {sleep 1;isNull (_this#0);};
		deleteVehicle (_this#1);
	};
};