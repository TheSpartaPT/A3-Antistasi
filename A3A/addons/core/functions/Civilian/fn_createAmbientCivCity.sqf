/*
    Author: [Hazey]
    Description:
		Create Ambient Civ's within city

    Arguments:
    	<String> City Marker where you would like the Ambient Civilians created.
		Note, the marker must be provided from citiesX

    Return Value:
    	N/A

    Scope: Any
    Environment: Any
    Public: No

    Example: 
		[[_marker], "A3A_fnc_createAmbientCivCity"] call A3A_fnc_scheduler;

    License: MIT License
*/

#include "..\..\script_component.hpp"
FIX_LINE_NUMBERS()
params ["_markerX", ["_maxSpawnedCivilians", 6], ["_civilianPopulation", 4]];

// We only want to run on the server and not on the players
if (!isServer and hasInterface) exitWith{};

private _spawnKey = _markerX + "_civ";
private _civilianGroups = [];
private _soundSources = [];
private _lightSources = [];
private _civilians = [];
private _buildings = [];
private _positionX = getMarkerPos (_markerX);
private _locationRadius = [_markerX] call A3A_fnc_sizeMarker;
private _dayState = [] call A3A_fnc_getDayState;

_buildings = nearestObjects [_positionX, ["House"], _locationRadius];

ServerDebug_2("Spawning City Civilians in %1 with a radius of %2", _markerX, _locationRadius);

private _city = if (_positionX isEqualType "") then {_positionX} else {[citiesX, _positionX] call BIS_fnc_nearestPosition};
private _cityData = server getVariable _city;

_civilianPopulation = round ((sqrt (_cityData#0)) / 2);

// We don't want to add too many civ's.
if (_civilianPopulation > _maxSpawnedCivilians) then {
	_civilianPopulation = _maxSpawnedCivilians;
};

if ((random 100 < ((aggressionOccupants) + (aggressionInvaders))) and (spawner getVariable _spawnKey != 2)) then {
	private _spawnPosition = [_positionX, 10, 50, 10, 0, -1, 0] call A3A_fnc_getSafePos;
	_groupX = createGroup civilian;
	_civilianGroups pushBack _groupX;
	private _civPress = [_groupX, FactionGet(civ, "unitPress"), _spawnPosition, [],0, "NONE"] call A3A_fnc_createUnit;
	[_civPress] spawn A3A_fnc_civilianInitEH;
	_civilians pushBack _civPress;
	[_groupX, "Patrol_Area", 5, 50, 300, false, [], true] call A3A_fnc_patrolLoop;
};

if (spawner getVariable _spawnKey != 2) then {
	for "_i" from 1 to _civilianPopulation do {
		private _posHouse = [];

		while {true} do {
			private _building = selectRandom _buildings;
			private _housePositions = [_building] call BIS_fnc_buildingPositions;

			if !(_housePositions isEqualTo []) exitWith {_posHouse = selectRandom _housePositions};
		};

		private _groupX = createGroup civilian;
		private _civUnit = [_groupX, FactionGet(civ, "unitMan"), _posHouse, [],0, "NONE"] call A3A_fnc_createUnit;
		_civUnit setPosATL _posHouse;
		_civUnit setVariable ["isScared", false];

		_civilianGroups pushBack _groupX;
		_civilians pushBack _civUnit;

		[_civUnit] spawn A3A_fnc_civilianInitEH;

		// Actions to do during the evening hours of spawn.
		if (_dayState == "EVENING" || {_dayState == "NIGHT"}) then {
			private _building = _posHouse nearestObject "House";
			_light = [_building] call A3A_fnc_createRoomLight;
			_lightSources pushBack _light;
		};

		// Actions to do during the morning hours of spawn.
		if (_dayState == "MORNING") then {
			if (4 > random 10) then {
				private _building = _posHouse nearestObject "House";
				private _soundSource = [_building] call A3A_fnc_createMusicSource;
				_soundSources pushBack _soundSource;
			};
			_light = [_building] call A3A_fnc_createRoomLight;
			_lightSources pushBack _light;
		};

		// Actions to do during the day hours of spawn
		if (_dayState == "DAY") then {
			if (7 > random 10) then {
				private _building = _posHouse nearestObject "House";
				private _soundSource = [_building] call A3A_fnc_createMusicSource;
				_soundSources pushBack _soundSource;
			};

			[_groupX] call A3A_fnc_patrolLoop;
		};
	};
};

// Handle removal of civ's.
waitUntil {sleep 1;(spawner getVariable _spawnKey == 2)};
{
	if (alive _x) then {deleteVehicle _x};
} forEach _civilians;

{
	_x setVariable ["PATCOM_Controlled", false];
	deleteGroup _x;
} forEach _civilianGroups;

{deleteVehicle _x} forEach _soundSources;
{deleteVehicle _x} forEach _lightSources;