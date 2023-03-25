Created by Iridar, mod idea by Dragon32

More info here: https://www.patreon.com/Iridar

[WOTC] Mission Launch Auto Save

This simple mod creates an Auto Save whenever you click "Launch" in Squad Select, using the name of the Operation as the name of the save file. This can be useful if your game tends to crash when loading into a mission.

[h1]IRONMAN[/h1]

With true Ironman enabled, you're allowed to have only one Save per campaign, so any Auto Save made by this mod will be automatically overwritten the moment you load into Tactical. However, you can still load the created Auto Save if the game crashes while loading the mission. 

Also, this mod makes it possible to manually Auto Save in Tactical with Ironman enabled. To do so, hit the [b]F5[/b] hotkey. No, you cannot rebind this. 

Normally, Ironman saves automatically only at the start of the turn, so being able to save near the end of the turn may be useful if you're afraid of the game crashing during the following enemy turn.

[h1]COMPATIBILITY[/h1]

Compatible with [b][url=https://steamcommunity.com/sharedfiles/filedetails/?id=1122974240]WotC: robojumper's Squad Select[/url][/b]. Should be compatible with all its variants as well.

This mod replaces the "OnClicked" delegate on the Squad Select button. It stores and calls the original delegate, so it should be compatible with all mods that also try to replace the "OnClicked" delegate [i]before[/i] this mod.

However, if another mod replaces the "OnClicked" delegate [i]after[/i] this mod, there's no guarantee that the other mod will also preserve and call this mod's delegate. If it doesn't, Auto Save will not be created.

There are currently no known conflicts.

[h1]COMPANION MODS[/h1]

[b][url=https://steamcommunity.com/sharedfiles/filedetails/?id=1124242299]WOTC Save Games Delete All Option[/url][/b] to quickly delete all those saves you piled up.

[h1]CREDITS[/h1]

Thanks to [b]Dragon32[/b] for the idea.

Please support me on [b][url=https://www.patreon.com/Iridar]Patreon[/url][/b] if you require tech support, have a suggestion for a feature, or simply wish to help me create more awesome mods.



Этот простой мод автоматически сохраняет игру при нажатии кнопки "Начать Задание" на экране выбора отряда перед отправкой бойцов на задание. Имя операции используется в качестве имени файла. Это может быть полезно если у вас игра частенько вылетает при загрузке задания.

[h1]ТЕРМИНАТОР[/h1]

При игре в режиме "Терминатора", у вас может быть только один файл сохранений, так что файл сохранения созданный этим модом автоматически перезапишется как только задание успешно прогрузится. Однако, если во время загрузки задания игра вылетит, у вас будет возможность загрузить это автоматическое сохранение.

[h1]СОВМЕСТИМОСТЬ[/h1]

Совместим с [b][url=https://steamcommunity.com/sharedfiles/filedetails/?id=1122974240]WotC: robojumper's Squad Select[/url][/b]. Скорее всего совместим с остальными версиями этого мода.

[h1]ЗАКЛЮЧЕНИЕ[/h1]

Спасибо [b]Dragon32[/b] за идею.

Поддержать автора можно через [b][url=https://sponsr.ru/iridar/]Sponsr[/url][/b]. Становитесь подписчиком - и будем создавать крутые моды вместе.
