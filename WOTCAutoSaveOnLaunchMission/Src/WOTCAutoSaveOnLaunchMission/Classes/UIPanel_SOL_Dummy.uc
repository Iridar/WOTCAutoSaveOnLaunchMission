class UIPanel_SOL_Dummy extends UIPanel; 

var delegate<OnClickedDelegate> OnClickedOriginal;

delegate OnClickedDelegate(UIButton Button);

final function OnLaunchMission(UIButton Button)
{
	local GeneratedMissionData				MissionData;
	local XComGameState_HeadquartersXCom	XComHQ;
	local UISquadSelect						SquadSelect;

	// Make the Auto Save use the same name as the mission name.
	XComHQ = `XCOMHQ;
	
	if (CannotBackOutSquadSelect(XComHQ.MissionRef.ObjectID))
	{
		`LOG("Cannot perform Auto Save on this Mission Launch, since it could soft lock the game if loaded.",, 'MissionLaunchAutoSave');
	}
	else
	{
		MissionData = XComHQ.GetGeneratedMissionData(XComHQ.MissionRef.ObjectID);
		if (MissionData.BattleOpName != "")
		{
			`ONLINEEVENTMGR.SetPlayerDescription(MissionData.BattleOpName);
		}

		`LOG("Creating AutoSave on Mission Launch:" @ MissionData.BattleOpName,, 'MissionLaunchAutoSave');
		`AUTOSAVEMGR.DoAutosave(/*AutoSaveCompleteCallback*/, /*bDebugSave*/, true /*bPreMissionSave*/, /*bPostMissionSave*/, /*PartialHistoryLength*/);
	}
	
	`LOG("Running:" @ string(OnClickedOriginal),, 'WOTCAutoSaveOnLaunchMission');

	if (OnClickedOriginal != none)
	{
		OnClickedOriginal(Button);
	}

	SquadSelect = UISquadSelect(Movie.Pres.ScreenStack.GetFirstInstanceOf(class'UISquadSelect'));
	if (SquadSelect != none && SquadSelect.bLaunched)
	{
		`LOG("Mission launched, clearing delegate and removing panel.",, 'MissionLaunchAutoSave');
		OnClickedOriginal = none;
		Remove();
	}
}

private function bool CannotBackOutSquadSelect(const int MissionID)
{
	local XComGameState_MissionSite	MissionState;
	local X2MissionSourceTemplate	MissionSourceTemplate;

	MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(MissionID));
	if (MissionState != none)
	{
		MissionSourceTemplate = MissionState.GetMissionSource();

		if (MissionSourceTemplate != none && MissionSourceTemplate.bCannotBackOutSquadSelect)
		{
			`LOG("Cannot back out of Squad Select UI for mission source:" @ MissionSourceTemplate.DataName,, 'MissionLaunchAutoSave');
		}
	}
	return MissionSourceTemplate != none && MissionSourceTemplate.bCannotBackOutSquadSelect;
}

simulated event Removed()
{
	`LOG("Dummy panel removed.",, 'MissionLaunchAutoSave');
	OnClickedOriginal = none;
	super.Removed();
}