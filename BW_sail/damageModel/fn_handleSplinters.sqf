params ["_target","_projectile"];

if (!(_projectile isEqualTo objNull)) then {
//hint format ["It's working!, position: %1 velocity: %2",(getposasl _projectile), (velocity _projectile)];
_spawner = createVehicle ["1715_wood_splinter_spawner_6pound", (getposasl _projectile), [], 0, "CAN_COLLIDE"];
_spawner setVelocity (velocity _projectile);
_spawner attachTo [_projectile,[0,0.1,0]];
//player attachTo [_projectile,[0,0.1,0]];
_spawner setVectorDir (vectorDir _projectile);
} else {
//hint "It's not working!";
};