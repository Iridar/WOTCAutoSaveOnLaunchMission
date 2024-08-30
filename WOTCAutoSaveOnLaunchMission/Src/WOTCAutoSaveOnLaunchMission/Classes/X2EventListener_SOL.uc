class X2EventListener_SOL extends X2EventListener config(AutoSave);

var private config bool bDoAutoSaveOnMissionStart;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	if (default.bDoAutoSaveOnMissionStart && !IsIronman())
	{
		Templates.AddItem(Create_ListenerTemplate());
	}
	return Templates;
}

static function CHEventListenerTemplate Create_ListenerTemplate()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'IRI_X2EventListener_SOL');

	Template.RegisterInTactical = true;
	Template.RegisterInStrategy = false;

	Template.AddCHEvent('OnTacticalBeginPlay', ListenerEventFunction, ELD_OnStateSubmitted, 1);

	return Template;
}

static private function EventListenerReturn ListenerEventFunction(Object EventData, Object EventSource, XComGameState NewGameState, Name Event, Object CallbackData)
{
	local GeneratedMissionData				MissionData;
	local XComGameState_HeadquartersXCom	XComHQ;
	local string							BattleOpName;
	local XComOnlineEventMgr				OnlineEventMgr;
	
	// This runs when loading tactical saves too, so we need to do some filtering before creating a new save.

	if (!IsFirstTurn())
		return ELR_NoInterrupt;
	
	// Get the localized operation name
	XComHQ = `XCOMHQ;
	MissionData = XComHQ.GetGeneratedMissionData(XComHQ.MissionRef.ObjectID);
	BattleOpName = MissionData.BattleOpName;
	if (BattleOpName == "")
		return ELR_NoInterrupt;

	if (DoesSaveAlreadyExist(BattleOpName))
	{
		`LOG("Auto save at mission start already exists, exiting.",, 'MissionLaunchAutoSave');
		return ELR_NoInterrupt;
	}

	OnlineEventMgr = `ONLINEEVENTMGR;
	OnlineEventMgr.SetPlayerDescription(MissionData.BattleOpName);

	`LOG("Creating AutoSave on Mission Start:" @ BattleOpName,, 'MissionLaunchAutoSave');

	OnlineEventMgr.SaveGame(OnlineEventMgr.GetNextSaveID(), false /*IsAutosave*/, false /*IsQuicksave*/);

	return ELR_NoInterrupt;
}

static private function bool DoesSaveAlreadyExist(const string SaveName)
{
	local XComOnlineEventMgr				OnlineEventMgr;
	local array<OnlineSaveGame>				SavedGames;
	local OnlineSaveGame					SavedGame;
	local XComGameState_CampaignSettings	CampaignSettingsStateObject;
	local OnlineSaveGameDataMapping			kData;

	CampaignSettingsStateObject = XComGameState_CampaignSettings(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings', true));
	if (CampaignSettingsStateObject == none)
	 	return false;

	OnlineEventMgr = `ONLINEEVENTMGR;

	if (!OnlineEventMgr.GetSaveGames(SavedGames))
		return false;

	foreach SavedGames(SavedGame)
	{
		foreach SavedGame.SaveGames(kData)
		{
			// Start time check makes sure only the saves from the same campaign are looked at.
			if (kData.SaveGameHeader.bIsTacticalSave && !kData.SaveGameHeader.bIsAutosave && !kData.SaveGameHeader.bIsQuicksave && kData.SaveGameHeader.CampaignStartTime == CampaignSettingsStateObject.StartTime)
			{
				// `LOG("Found save file with description:" @ kData.SaveGameHeader.Description,, 'IRITEST');
				// Description includes a lot of stuff, like date, so just check if the op name is in there somewhere.
				if (InStr(kData.SaveGameHeader.Description, SaveName,, true /* ignore case */ ) != INDEX_NONE) 
				{
					return true;
				}
			}
		}
	}

	return false;
}

static private function bool IsFirstTurn()
{
	local XComGameState_BattleData BattleData;

	BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	
	return BattleData != none && BattleData.TacticalTurnCount == 0;
}

static private function bool IsIronman()
{
	local XComGameState_CampaignSettings CampaignSettingsStateObject;

	CampaignSettingsStateObject = XComGameState_CampaignSettings(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings', true));

	return CampaignSettingsStateObject != none && CampaignSettingsStateObject.bIronmanEnabled;
}
