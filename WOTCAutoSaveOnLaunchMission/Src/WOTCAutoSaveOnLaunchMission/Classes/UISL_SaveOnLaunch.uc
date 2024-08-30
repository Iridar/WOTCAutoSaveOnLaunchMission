class UISL_SaveOnLaunch extends UIScreenListener;

event OnInit(UIScreen Screen)
{
	local UISquadSelect		SquadSelect;
	local UITacticalHud		TacticalHUD;
	local UIPanel_SOL_Dummy DummyPanel;

	SquadSelect = UISquadSelect(Screen);
	if (SquadSelect != none)
	{

		`LOG("Storing the original OnClicked delegate.",, 'MissionLaunchAutoSave');

		// We want to create a new save whenever player clicks the Launch button in squad select.
		// To do so, we need to replace the original OnClicked delegate with our own.
		// Normally, we'd simply run SquadSelect.OnLaunchMission() in our own delegate,
		// but that can cause compatibility issues with other mods that may have set
		// a custom delegate to that button that does something different to OnLaunchMission().
		// So for maximum compatibility we create a hidden dummy panel to store the original OnClicked delegate,
		// and call it from our own delegate.
		// We cannot store the original delegate as a global variable in this UISL, 
		// since it would cause garbage collection crashes.
		DummyPanel = SquadSelect.LaunchButton.Spawn(class'UIPanel_SOL_Dummy', SquadSelect.LaunchButton);
		DummyPanel.InitPanel('IRI_SOL_DummyPanel');
		DummyPanel.Hide();
		DummyPanel.SetPosition(-100, -100);

		`LOG("Replacing:" @ string(SquadSelect.LaunchButton.OnClickedDelegate) @ "with" @ string(DummyPanel.OnLaunchMission),, 'WOTCAutoSaveOnLaunchMission');

		DummyPanel.OnClickedOriginal = SquadSelect.LaunchButton.OnClickedDelegate;
		SquadSelect.LaunchButton.OnClickedDelegate = DummyPanel.OnLaunchMission;
	}
	else
	{
		TacticalHUD = UITacticalHud(Screen);
		if (TacticalHUD != none && IsIronman())
		{
			TacticalHUD.Movie.Stack.SubscribeToOnInputForScreen(TacticalHUD, OnTacticalHUDInput);
		}
	}
}

// If Ironman is enabled, then hitting F5 will manually AutoSave the game.
private function bool OnTacticalHUDInput(UIScreen Screen, int iInput, int ActionMask)
{
	local UIProgressDialogue Progress;

	// Ignore releases, just pay attention to presses.
	if ( ( ActionMask & class'UIUtilities_Input'.const.FXS_ACTION_PRESS) == 0 )
		return false;

	// Docs for this:
	// https://x2communitycore.github.io/X2WOTCCommunityHighlander/misc/SubscribeToOnInputForScreen/
	
	if (iInput == class'UIUtilities_Input'.const.FXS_KEY_F5)
	{
		Progress = Screen.Movie.Pres.Spawn(class'UIProgressDialogue');
		Progress.m_kData.strTitle =  class'XComKeybindingData'.default.m_arrGeneralBindableLabels[eGBC_QuickSave]; // "Quick Save"
		Progress.m_kData.strDescription = class'UISaveGame'.default.m_sSavingInProgressPS3; // "Saving content..."
		Screen.Movie.Stack.Push(Progress);

		`LOG("Performing manual Ironman Auto Save.",, 'MissionLaunchAutoSave');
		`AUTOSAVEMGR.DoAutosave(OnAutoSaveCompleted, /*bDebugSave*/, false /*bPreMissionSave*/, /*bPostMissionSave*/, /*PartialHistoryLength*/);
	}

    return false;
}

private function OnAutoSaveCompleted(bool bWasSuccessful)
{
	`SCREENSTACK.PopFirstInstanceOfClass(class'UIProgressDialogue', false);
	`LOG("Quick Save Completed" @ bWasSuccessful,, 'MissionLaunchAutoSave');

	
	//class'UISaveGame'.default.m_sSaveFailedTitle="SAVE FAILED"
	//class'UISaveGame'.default.m_sSaveFailedText="Failed to write save file"
}

private function bool IsIronman()
{
	local XComGameState_CampaignSettings CampaignSettingsStateObject;

	CampaignSettingsStateObject = XComGameState_CampaignSettings(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings', true));

	return CampaignSettingsStateObject != none && CampaignSettingsStateObject.bIronmanEnabled;
}
