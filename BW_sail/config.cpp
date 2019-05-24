class CfgPatches
{
	class BW_sailSystem
	{
		units[]={};
		requiredVersion=1;
		requiredAddons[]={};
		weapons[]={};
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
		class action{
			file="\BW_sail\action";
			class keyDown{};
			class keyUp{};
			class actionHandler{};
			class externalAction{};
			class dragAction{};
			class dropAnchor{};
			class removePlank{};
			class applyPlank{};
			class OnActionKey{};
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
		vehicleClass="Objects";
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
		vehicleClass="Objects";
		armor=20000;
		icon="iconObject";
		mapSize=0.69999999;
		accuracy=0.2;
		class SailActionsExternal
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
		class UserActions
		{
			class sail_action
			{
				displayName="";
				displayNameDefault="";
				position="";
				radius=6;
				condition="[this] call BW_sail_fnc_externalAction;false";
				statement="hint ""yay""";
				onlyForplayer=0;
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
		icon="\BW_sail\icon\placeholder.paa";
	};
};
