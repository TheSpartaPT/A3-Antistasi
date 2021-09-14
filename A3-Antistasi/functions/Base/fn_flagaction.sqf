private ["_flag","_typeX"];

 // TODO UI-update: replace create dialog lines with new UI stuff

if (!hasInterface) exitWith {};

_flag = _this select 0;
_typeX = _this select 1;

switch _typeX do
{
    case "take":
    {
        removeAllActions _flag;
        _actionX = _flag addAction ["<t>Take the Flag<t> <img image='\A3\ui_f\data\igui\cfg\actions\takeflag_ca.paa' size='1.8' shadow=2 />", A3A_fnc_mrkWIN,nil,6,true,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])",4];
        _flag setUserActionText [_actionX,"Take the Flag","<t size='2'><img image='\A3\ui_f\data\igui\cfg\actions\takeflag_ca.paa'/></t>"];
    };
    case "unit":
    {
        // Open unit recruitment dialog
        _flag addAction ["Unit Recruitment", {if ([player,300] call A3A_fnc_enemyNearCheck) then {["Unit Recruitment", "You cannot recruit units while there are enemies near you"] call A3A_fnc_customHint;} else {createDialog "A3A_RecruitDialog";};},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])",4];
        // Open squad recruitment dialog
        // TODO UI-update: Add commander check for squad recruitment / only show addAction for commander if possible?
        _flag addAction ["Squad Recruitment", {if ([player,300] call A3A_fnc_enemyNearCheck) then {["Squad Recruitment", "You cannot recruit squads while there are enemies near you"] call A3A_fnc_customHint;} else {createDialog "A3A_RecruitSquadDialog";};},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])",4];
    };
    case "vehicle":
    {
        // Open buy vehicle dialog
        _flag addAction ["Buy Vehicle", {if ([player,300] call A3A_fnc_enemyNearCheck) then {["Buy Vehicle", "You cannot buy vehicles while there are enemies near you"] call A3A_fnc_customHint;} else {createDialog "A3A_BuyVehicleDialog"}},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])",4]
    };
    case "mission":
    {
        // Open HQ Management dialog
        petros addAction ["HQ Management", {createDialog "A3A_HqDialog"},nil,2,false,true,"","(_this == theBoss) and (petros == leader group petros)", 4];
        // Open mission request dialog
        petros addAction ["Mission Request", {createDialog "A3A_RequestMissionDialog";},nil,1,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull]) and ([_this] call A3A_fnc_isMember) and (petros == leader group petros)",4];
        petros addAction ["Move this asset", A3A_fnc_moveHQObject,nil,0,false,true,"","(_this == theBoss)"];
    };
    case "truckX":
    {
        actionX = _flag addAction ["<t>Transfer Ammobox to Truck<t> <img image='\A3\ui_f\data\igui\cfg\actions\unloadVehicle_ca.paa' size='1.8' shadow=2 />", A3A_fnc_transfer,nil,6,true,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"]
    };
    //case "heal": {if (player != _flag) then {_flag addAction [format ["Revive %1",name _flag], { _this spawn A3A_fnc_actionRevive; },nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"]}};
    case "heal":
    {
        if (player != _flag) then
        {
            if ([_flag] call A3A_fnc_fatalWound) then
            {
                _actionX = _flag addAction [format ["<t>Revive %1 </t> <img size='1.8' <img image='\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa' />",name _flag], A3A_fnc_actionRevive,nil,6,true,true,"","!(_this getVariable [""helping"",false]) and (isNull attachedTo _target)",4];
                _flag setUserActionText [_actionX,format ["Revive %1",name _flag],"<t size='2'><img image='\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa'/></t>"];
            }
            else
            {
                _actionX = _flag addAction [format ["<t>Revive %1 </t> <img size='1.8' <img image='\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_revive_ca.paa' />",name _flag], A3A_fnc_actionRevive,nil,6,true,true,"","!(_this getVariable [""helping"",false]) and (isNull attachedTo _target)",4];
                _flag setUserActionText [_actionX,format ["Revive %1",name _flag],"<t size='2'><img image='\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_revive_ca.paa'/></t>"];
            };
        };
    };
    case "heal1":
    {
        if (player != _flag) then
        {
            if ([_flag] call A3A_fnc_fatalWound) then
            {
                _actionX = _flag addAction [format ["<t>Revive %1</t> <img size='1.8' <img image='\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa' />",name _flag], A3A_fnc_actionRevive,nil,6,true,false,"","!(_this getVariable [""helping"",false]) and (isNull attachedTo _target)",4];
                _flag setUserActionText [_actionX,format ["Revive %1",name _flag],"<t size='2'><img image='\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa'/></t>"];
            }
            else
            {
                _actionX = _flag addAction [format ["<t>Revive %1</t> <img size='1.8' <img image='\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_revive_ca.paa' />",name _flag], A3A_fnc_actionRevive,nil,6,true,false,"","!(_this getVariable [""helping"",false]) and (isNull attachedTo _target)",4];
                _flag setUserActionText [_actionX,format ["Revive %1",name _flag],"<t size='2'><img image='\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_revive_ca.paa'/></t>"];
            };
            //_flag addAction [format ["Revive %1",name _flag], { _this spawn A3A_fnc_actionRevive; },nil,0,false,true,"","!(_this getVariable [""helping"",false]) and (isNull attachedTo _target)"];

            _actionX = _flag addAction [format ["<t>Carry %1</t> <img image='\A3\ui_f\data\igui\cfg\actions\take_ca.paa' size='1.6' shadow=2 />",name _flag], A3A_fnc_carry,nil,5,true,false,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull]) and (isNull attachedTo _target) and !(_this getVariable [""helping"",false]);",4];
            _flag setUserActionText [_actionX,format ["Carry %1",name _flag],"<t size='2'><img image='\A3\ui_f\data\igui\cfg\actions\take_ca.paa'/></t>"];
            [_flag] call A3A_fnc_logistics_addLoadAction;
        };
    };
    case "remove":
    {
        if (player == _flag) then
        {
            if (isNil "actionX") then
            {
                removeAllActions _flag;
                if (player == player getVariable ["owner",player]) then {[] call SA_Add_Player_Tow_Actions};
                call A3A_fnc_initLootToCrate;
                call A3A_fnc_dropObject;
            }
            else
            {
                _flag removeAction actionX;
            };
        }
        else
        {
            removeAllActions _flag;
        };
    };
    case "refugee":
    {
        _flag addAction ["<t>Liberate</t> <img image='\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_unbind_ca.paa' size='1.6' shadow=2 />", A3A_fnc_liberaterefugee,nil,6,true,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])",4]
    };//"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_unbind_ca.paa"
    case "prisonerX":
    {
        _flag addAction ["<t>Liberate POW</t> <img image='\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_unbind_ca.paa' size='1.6' shadow=2 />", A3A_fnc_liberatePOW,nil,6,true,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])",4]
    };
    case "captureX":
    {
        // Uses the optional param to determine whether the call of captureX is a release or a recruit
        _flag addAction ["<t>Release POW</t> <img image='\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_unbind_ca.paa' size='1.6' shadow=2 />", { _this spawn A3A_fnc_captureX; },false,6,true,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])",4];
        _flag addAction ["Recruit", { _this spawn A3A_fnc_captureX; },true,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])",4];
        _flag addAction ["Interrogate", A3A_fnc_interrogate,nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])",4];
    };
    case "buildHQ":
    {
        _flag addAction ["Build HQ here", A3A_fnc_buildHQ,nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])",4]
    };
    case "seaport":
    {
        _flag addAction ["Buy Boat", {[vehSDKBoat] spawn A3A_fnc_addFIAVeh},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])",4]
    };
    case "garage":
    {
        [_flag] call HR_GRG_fnc_initGarage;
    };
    case "fireX":
    {
        // Rest moved to HQ management menu
        // fireX addAction ["Rest for 8 Hours", A3A_fnc_skiptime,nil,0,false,true,"","(_this == theBoss)",4];
        // Clear forest moved to HQ management menu
        // fireX addAction ["Clear Nearby Forest", A3A_fnc_clearForest,nil,0,false,true,"","(_this == theBoss)",4];
        // Clear fog moved to HQ management menu
        // fireX addAction ["I hate the fog", { [10,[0,0,0]] remoteExec ["setFog",2]; },nil,0,false,true,"","(_this == theBoss)",4];
        // Stop rain moved to HQ management menu
        // fireX addAction ["Rain rain go away", { [10,0] remoteExec ["setRain",2]; },nil,0,false,true,"","(_this == theBoss)",4];
        fireX addAction ["Move this asset", A3A_fnc_moveHQObject,nil,0,false,true,"","(_this == theBoss)",4];
    };
    case "SDKFlag":
    {
        removeAllActions _flag;
        _flag addAction ["Unit Recruitment", {if ([player,300] call A3A_fnc_enemyNearCheck) then {["Unit Recruitment", "You cannot recruit units while there are enemies near you"] call A3A_fnc_customHint;} else { createDialog "A3A_RecruitDialog"; };},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])",4];
        // TODO UI-update: _flag addAction for buy vehicle
        // _flag addAction ["Buy Vehicle", {if ([player,300] call A3A_fnc_enemyNearCheck) then {["Buy Vehicle", "You cannot buy vehicles while there are enemies near you"] call A3A_fnc_customHint;} else {nul = createDialog "vehicle_option"}},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])",4];
        [_flag] call HR_GRG_fnc_initGarage;
    };
    case "Intel_Small":
    {
        _flag addAction ["Search for Intel", A3A_fnc_searchIntelOnLeader, nil, 4, true, false, "", "isPlayer _this", 4];
    };
    case "Intel_Medium":
    {
        _flag addAction ["Take Intel", A3A_fnc_searchIntelOnDocument, nil, 4, true, false, "", "isPlayer _this", 4];
    };
    case "Intel_Large":
    {
        _flag addAction ["Download Intel", A3A_fnc_searchIntelOnLaptop, nil, 4, true, false, "", "isPlayer _this", 4];
    };
    case "Intel_Encrypted":
    {
        _flag addAction ["Decifer Intel", A3A_fnc_searchEncryptedIntel, nil, 4, true, false, "", "isPlayer _this", 4];
    };
    case "static":
    {
        private _cond = "(_target getVariable ['ownerSide', teamPlayer] == teamPlayer) and (isNull attachedTo _target) and ([_this] call A3A_fnc_isMember) and ";
        _flag addAction ["Allow AIs to use this weapon", A3A_fnc_unlockStatic, nil, 1, false, false, "", _cond+"!isNil {_target getVariable 'lockedForAI'}", 4];
        _flag addAction ["Prevent AIs using this weapon", A3A_fnc_lockStatic, nil, 1, false, false, "", _cond+"isNil {_target getVariable 'lockedForAI'}", 4];
    //    _flag addAction ["Kick AI off this weapon", A3A_fnc_lockStatic, nil, 1, true, false, "", _cond+"isNil {_target getVariable 'lockedForAI'} and !(isNull gunner _target) and !(isPlayer gunner _target)}", 4];
        _flag addAction ["Move this asset", A3A_fnc_moveHQObject, nil, 1.5, false, false, "",  _cond+"(count crew _target == 0)", 4];
    };
};
