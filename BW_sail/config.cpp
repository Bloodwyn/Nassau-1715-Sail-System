class CfgPatches
{
	class BW_sailSystem
	{
		units[]={};
		requiredVersion=1;
		requiredAddons[]={
			"1715_boats",
			"1715_cat_cay",
			"1715_clothing",
			"1715_data",
			"1715_fonts",
			"1715_frigates",
			"1715_gear",
			"1715_high_seas",
			"1715_Sailing_Manual",
			"1715_menu_scenes",
			"1715_missions",
			"1715_navalweapons",
			"1715_objects_barrel",
			"1715_sloops",
			"1715_sounds",
			"1715_Units",
			"1715_weapons",
			"BW_vector",
			"BW_adaptive_roadway"
		};
		weapons[]={};
	};
};

class CfgAmmo
{
	class B_762x51_Ball;
  	class SubmunitionBase;
	class B_12Gauge_Pellets_Submunition;
	
	class 1715_wood_splinter: B_762x51_Ball
	{
		airFriction=-0.025;
		hit=10;
		deflecting=20;
		indirectHit=0;
		indirectHitRange=0;
		caliber=0.1;
		cartridge="";
		visibleFire=5;
		audibleFire=9;
		visibleFireTime=5;
		cost=4;
		typicalSpeed=100;
		soundHitBody1[]=
		{
			"",
			1,
			1
		};
		soundHit[]=
		{
			"",
			1,
			1
		};
	};

	class 1715_wood_splinter_spawner_6pound: B_12Gauge_Pellets_Submunition
	{
		submunition = "1715_wood_splinter";
		triggerTime = 0.005;
		caliber = 11;
		deleteParentWhenTriggered = true;
		submunitionConeType[] = {"randomcenter",40};
		submunitionConeAngle = 120;
		submunitionInitialOffset[] = {0,0,0.1};
		submunitionDirectionType = "SubmunitionModelDirection";
		triggerSpeedCoef = 0.8;
	};
};

class CfgFunctions
{
	class BW_sail
	{
		class BW_sailSystemFunc
		{
			file="\BW_sail";
			class init{preInit=1;};
			class initShip{};
		};
		class damageModel
		{
			file="\BW_sail\damageModel";
			class handleSplinters;
			class addHole;
		};
		class action{
			file="\BW_sail\action";
			class keyDown{};
			class keyUp{};
			class actionHandler{};
			class dragAction{};
			class dropAnchor{};
			class removePlank{};
			class applyPlank{};
			class OnActionKey{};
			class canWaterBoat{};
			class waterBoat{};
			class whereCanLoadBoat{};
			class loadBoat{};
			class getBoatPos{};
			class getShipLight{};
			class createShipLight{};
			class deleteShipLight{};
			class getFlagObj{};
			class addChangeFlagActions{};
			class removeChangeFlagActions{};
			class reloadCannon{};
			class switchCannonAmmo{};
			class addAction{};
			class removeAction{};
			class changeFlag{};
			class pump{};
		};
		class util{
			file="\BW_sail\util";
			class stackOnEachFrame{};
			class enterShip{};
			class setAllSails{};
			class addNPCs{};
			class addCannons{};
			class normalizeDeg{};
			class arrayIntersection{};
			class findStrReversed{};
			class removeAllCannons{};
			class showSailDebug{};
			class cannonParticle{};
			class fireBroadside{};
			class addWaitUntilTime{};
			class waitUntilTime{};
			class parseCSV{};
			class getAttachedObj{};
			class findExtremeArrayIndex{};
			class addOrReplaceKey{};
			class removeKey{};
		};
		class AI{
			file="\BW_sail\ai";
			class astar{};
		};
		class rope
		{
			file="\BW_sail\rope";
			class hasRope{};
			class canAttachRope{};
			class attachRope{};
			class removeRope{};
			class resizeRope{};
			class enterRopeMode{};
			class exitRopeMode{};
		};
		class sail
		{
			file="\BW_sail\sail";
			class simulateSail{};
			class teleportToHelm{};
		};
	};
};
class CfgVehicles
{
	
	class Items_base_F;
	class 1715_sloop_anchor: Items_base_F
	{
		scope=2;
		author="Bloodwyn";
		model="\BW_sail\model\sloop_anchor.p3d";
		displayName="Sloop Anchor";
		editorcategory = "1715_Objects";
		editorSubcategory = "1715_Objects";
		armor=20000;
		icon="iconObject";
		mapSize=0.69999999;
		accuracy=0.2;
	};
	class Buoy_base_F;
	class 1715_plank_4m: Buoy_base_F
	{
		scope=2;
		author="Bloodwyn";
		model="\BW_sail\model\Plank_4m_F.p3d";
		displayName="Plank 4m (PhysiX)";
		editorcategory = "1715_Objects";
		editorSubcategory = "1715_Objects";
		armor=20000;
		icon="iconObject";
		mapSize=0.69999999;
		accuracy=0.2;
		class BW_actions
		{
			class remove
			{
				displayName="pack plank";
				displayNameDefault="\BW_sail\icon\placeholder.paa";
				position="a";
				radius=3;
				onlyForplayer=0;
				condition="!isnull BW_cship";
				statement="_this call BW_sail_fnc_removePlank";
			};
		};
	};
	class 1715_plank_8m: 1715_plank_4m
	{
		model="\BW_sail\model\Plank_8m_F.p3d";
		displayName="Plank 8m (PhysiX)";
	};
	class 1715_ropeLogic: Items_base_F
	{
		scope=1;
		model="\a3\weapons_f\empty.p3d";
		displayName="Rope Logic";
	};
};
class CfgMarkers
{
	class hd_arrow;
	class BW_windIndicator: hd_arrow
	{
		name="wind indicator (Angel)";
		icon="\BW_sail\icon\wind_indicator.paa";
	};
};
