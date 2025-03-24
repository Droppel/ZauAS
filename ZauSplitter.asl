state("Zau")
{
}

startup
{
	// Add setting 'mission1', enabled by default, with 'First Mission' being displayed in the GUI
	settings.Add("prologue", true, "Split Prologue");
	settings.Add("presunarena", true, "Split Pre Sun Arena");
	settings.Add("postsunarena", true, "Split Post Sun Arena");
	settings.Add("swampskip", true, "Split Swamp Skip");
	settings.Add("natureescape", true, "Split Nature Escape");
	settings.Add("tawasheart", true, "Split Tawas Heart");
	settings.Add("heartfight", true, "Split Heart Fight");
	settings.Add("heartdefeated", true, "Split Heart Defeated");
	settings.Add("embersprings", true, "Split Ember Springs");
	settings.Add("biggeyser", true, "Split Big Geyser");
	settings.Add("springsloadin", true, "Split Springs Load In");
	settings.Add("blockpuzzle", true, "Split Block Puzzle");
	settings.Add("drawbridge", true, "Split Drawbridge");
	settings.Add("searingsands", true, "Split Searing Sands");
	settings.Add("sunandmoon", true, "Split Sun and Moon");
	settings.Add("glide", true, "Split Glide");
	settings.Add("mountain", true, "Split Mountain");
	settings.Add("launch", true, "Split Launch");
	settings.Add("enduringrite", true, "Split Enduring Rite");
	settings.Add("mountaintop", true, "Split Mountain Top");
	settings.Add("gagorib", true, "Split Gagorib");
	settings.Add("gagoribdone", true, "Split Gagorib Done");
	settings.Add("realmofthedead", true, "Split Realm of the Dead");
	settings.Add("kalunga", true, "Split Kalunga");
}

init
{
    var trg = new SigScanTarget(3, "48 8B 0D ???????? 66 0F 5A C9 E8");
    trg.OnFound = (p, _, addr) => addr + 0x4 + p.ReadValue<int>(addr);

    var scn = new SignatureScanner(game, modules[0].BaseAddress, modules[0].ModuleMemorySize);

    var gEngine = scn.Scan(trg);
    if (gEngine == IntPtr.Zero)
        throw new Exception("Not all targets found");

    // GEngine.GameInstance.LocalPlayers[0].PlayerController.LastCheckpointCrossed.Record.RecordName
    vars.LastCheckpointRecordName = new StringWatcher(new DeepPointer(gEngine, 0xD28, 0x38, 0x0, 0x30, 0x6D8, 0x220 + 0x10, 0x0), ReadStringType.UTF16, 64);
}

onStart
{
	vars.Splits = new List<List<string>>{};

	if (settings["prologue"]) {
		vars.Splits.Add(new List<string>{"Balcony", "SanctuaryStart"}); // Prologue
	}
	if (settings["presunarena"]) {
		vars.Splits.Add(new List<string>{"HL01_CHPT02_COMBAT_ENCOUNTER_01", "HL01_CHPT0X_CE02_PRE"}); // Pre Sun Arena
	}
	if (settings["postsunarena"]) {
		vars.Splits.Add(new List<string>{"HL01_CHPT0X_CE02_POST", "HL01_CHPT0X_CE02_PRE"}); // Post Sun Arena
	}
	if (settings["swampskip"]) {
		vars.Splits.Add(new List<string>{"", "WL02_130_TrapAreaStart"}); // Swamp Skip
	}
	if (settings["natureescape"]) {
		vars.Splits.Add(new List<string>{"", "KikiChase_000_StartPt1"}); // Nature Escape
	}
	if (settings["tawasheart"]) {
		vars.Splits.Add(new List<string>{"", "WL06_PulseAbilityStatue"}); // Tawas Heart
	}
	if (settings["heartfight"]) {
		vars.Splits.Add(new List<string>{"", "KikiChase_060_HeartChamberStart"}); // Heart Fight
	}
	if (settings["heartdefeated"]) {
		vars.Splits.Add(new List<string>{"", "WL02_DebugOutOfKiki"}); // Heart Defeated
	}
	if (settings["embersprings"]) {
		vars.Splits.Add(new List<string>{"", "DL01_01_firsthotspring"}); // Ember Springs
	}
	if (settings["biggeyser"]) {
		vars.Splits.Add(new List<string>{"DL01_05", "DL01_11"}); // Big Geyser
	}
	if (settings["springsloadin"]) {
		vars.Splits.Add(new List<string>{"", "DL01_42"}); // Springs Load In
	}
	if (settings["blockpuzzle"]) {
		vars.Splits.Add(new List<string>{"", "DL01_16"}); // Block Puzzle
	}
	if (settings["drawbridge"]) {
		vars.Splits.Add(new List<string>{"", "DrawbridgeCheckpoint"}); // Drawbridge
	}
	if (settings["searingsands"]) {
		vars.Splits.Add(new List<string>{"", "DL02_00_01"}); // Searing Sands
	}
	if (settings["sunandmoon"]) {
		vars.Splits.Add(new List<string>{"", "NakshiDialogue"}); // Sun and Moon
	}
	if (settings["glide"]) {
		vars.Splits.Add(new List<string>{"", "DL02_XX_AbilityStatue"}); // Glide
	}
	if (settings["mountain"]) {
		vars.Splits.Add(new List<string>{"", "DL03_000_Start"}); // Mountain
	}
	if (settings["launch"]) {
		vars.Splits.Add(new List<string>{"", "DL03_170_AbilityCharge"}); // Launch
	}
	if (settings["enduringrite"]) {
		vars.Splits.Add(new List<string>{"", "DL03_CombatShrine"}); // Enduring Rite
	}
	if (settings["mountaintop"]) {
		vars.Splits.Add(new List<string>{"", "DL04_Workbench_Upper"}); // Mountain Top
	}
	if (settings["gagorib"]) {
		vars.Splits.Add(new List<string>{"", "GagoribFightCheckpoint"}); // Gagorib
	}
	if (settings["gagoribdone"]) {
		vars.Splits.Add(new List<string>{"", "DL06_AfterGaga"}); // Gagorib Done
	}
	if (settings["realmofthedead"]) {
		vars.Splits.Add(new List<string>{"", "BeforeRealmOfTheDead"}); // Realm of the Dead
	}
	if (settings["kalunga"]) {
		vars.Splits.Add(new List<string>{"", "PL01_03_Fight"}); // Kalunga
	}
}

update
{
    vars.LastCheckpointRecordName.Update(game);

    if (vars.LastCheckpointRecordName.Changed)
    {
        print("Checkpoint: " + vars.LastCheckpointRecordName.Old + " -> " + vars.LastCheckpointRecordName.Current);
		print(vars.LastCheckpointRecordName.Current);
	}
}

split
{
	if (!vars.LastCheckpointRecordName.Changed) {
		return false;
	}

	for (int i = 0; i < vars.Splits.Count; i++) {
		if ((vars.Splits[i][0] == "" || vars.Splits[i][0] == vars.LastCheckpointRecordName.Old) && vars.Splits[i][1] == vars.LastCheckpointRecordName.Current) {
			return true;
		}
	}
	return false;
}