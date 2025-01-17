#include "..\..\script_component.hpp"
FIX_LINE_NUMBERS()
params ["_unit", "_player", "_actionID"];

/*  The action of interrogating a surrendered unit.
*   Params:
*       _unit : OBJECT : The unit which will be interrogated
*       _player : OBJECT : The unit which is interrogating
*       _unused : NOT USED
*       _actionID : NUMBER : The ID of the interrogate action
*
*   Returns:
*       Nothing
*/

//Removing action
[_unit, _actionID] remoteExec ["removeAction", [teamPlayer, civilian], _unit];

if (!alive _unit) exitWith {};
if (_unit getVariable ["interrogated", false]) exitWith {};
_unit setVariable ["interrogated", true, true];

_player globalChat "You imperialist! Tell me what you know!";
private _side = side (group _unit);
private _chance = 120 - ([aggressionOccupants, aggressionInvaders] select (_side == Invaders));

sleep 5;

if (random 100 < _chance) then
{
    if((_unit getVariable "unitType") in FactionGet(all,"SquadLeaders")) then
    {
        _unit globalChat "Okay, I'll tell you what I know";
        ["Medium", _side] remoteExec ["A3A_fnc_selectIntel", 2];
    }
    else
    {
        _unit globalChat "I don't know anything. Maybe my squad leader does.";
    };
}
else
{
    _unit globalChat "Screw you, I am not telling anything!";
};
