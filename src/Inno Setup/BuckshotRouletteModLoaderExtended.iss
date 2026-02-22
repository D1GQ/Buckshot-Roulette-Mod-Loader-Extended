[Setup]
AppName=Buckshot Roulette Mod Loader Extended
AppVersion=1.0
DefaultDirName={userdesktop}\BuckshotRouletteModded
Uninstallable=no
DisableWelcomePage=no
DisableDirPage=no
ExtraDiskSpaceRequired=1610612736
OutputDir=.
OutputBaseFilename=BRML-E_Setup

[Files]
Source: "xdelta3.exe"; DestDir: "{tmp}"; Flags: dontcopy deleteafterinstall

[Code]
var
  GamePage: TWizardPage;
  GameExeEdit: TEdit;
  GameExeButton: TButton;
  PatchFileEdit: TEdit;
  PatchFileButton: TButton;
  GamePath: string;
  GameFolderPath: string;
  PatchPath: string;
  ModsFolder: string;
  ModsUnpackedFolder: string;
  PatchSuccess: Boolean;
  OpenFolderCheckbox: TCheckBox;

procedure BrowseForGameExe(Sender: TObject);
var
  FileName: string;
begin
  FileName := GameExeEdit.Text;
  if GetOpenFileName('Select Buckshot Roulette.exe', 
                     FileName, 
                     'C:\Program Files (x86)\Steam\steamapps\common\Buckshot Roulette', 
                     'Executable files (*.exe)|*.exe', 
                     'exe') then
    GameExeEdit.Text := FileName;
end;

procedure BrowseForPatch(Sender: TObject);
var
  FileName: string;
begin
  FileName := PatchFileEdit.Text;
  if GetOpenFileName('Select patch file', 
                     FileName, 
                     '', 
                     'Delta patch files (*.xdelta)|*.xdelta', 
                     'xdelta') then
    PatchFileEdit.Text := FileName;
end;

procedure InitializeWizard();
var
  DescLabel: TLabel;
  GameLabel: TLabel;
  PatchLabel: TLabel;
begin
  GamePage := CreateCustomPage(wpSelectDir, 'Select Game and Patch Files', 
    'Choose your original Buckshot Roulette.exe and the patch file');
  
  DescLabel := TLabel.Create(WizardForm);
  DescLabel.Parent := GamePage.Surface;
  DescLabel.Left := 0;
  DescLabel.Top := 0;
  DescLabel.Width := GamePage.Surface.Width;
  
  GameLabel := TLabel.Create(WizardForm);
  GameLabel.Parent := GamePage.Surface;
  GameLabel.Left := 0;
  GameLabel.Top := 20;
  GameLabel.Caption := 'Original Buckshot Roulette.exe:';
  
  GameExeEdit := TEdit.Create(WizardForm);
  GameExeEdit.Parent := GamePage.Surface;
  GameExeEdit.Left := 0;
  GameExeEdit.Top := 40;
  GameExeEdit.Width := GamePage.Surface.Width - 90;
  GameExeEdit.Text := 'C:\Program Files (x86)\Steam\steamapps\common\Buckshot Roulette\Buckshot Roulette_windows\Buckshot Roulette.exe';
  
  GameExeButton := TButton.Create(WizardForm);
  GameExeButton.Parent := GamePage.Surface;
  GameExeButton.Left := GameExeEdit.Left + GameExeEdit.Width + 5;
  GameExeButton.Top := 38;
  GameExeButton.Width := 80;
  GameExeButton.Caption := 'Browse...';
  GameExeButton.OnClick := @BrowseForGameExe;
  
  PatchLabel := TLabel.Create(WizardForm);
  PatchLabel.Parent := GamePage.Surface;
  PatchLabel.Left := 0;
  PatchLabel.Top := 80;
  PatchLabel.Caption := 'xdelta patch:';
  
  PatchFileEdit := TEdit.Create(WizardForm);
  PatchFileEdit.Parent := GamePage.Surface;
  PatchFileEdit.Left := 0;
  PatchFileEdit.Top := 100;
  PatchFileEdit.Width := GamePage.Surface.Width - 90;
  
  PatchFileButton := TButton.Create(WizardForm);
  PatchFileButton.Parent := GamePage.Surface;
  PatchFileButton.Left := PatchFileEdit.Left + PatchFileEdit.Width + 5;
  PatchFileButton.Top := 98;
  PatchFileButton.Width := 80;
  PatchFileButton.Caption := 'Browse...';
  PatchFileButton.OnClick := @BrowseForPatch;
  
  OpenFolderCheckbox := TCheckBox.Create(WizardForm);
  OpenFolderCheckbox.Parent := WizardForm.FinishedPage;
  OpenFolderCheckbox.Left := WizardForm.FinishedLabel.Left;
  OpenFolderCheckbox.Top := WizardForm.FinishedLabel.Top + WizardForm.FinishedLabel.Height + 8;
  OpenFolderCheckbox.Width := WizardForm.FinishedPage.ClientWidth - 32;
  OpenFolderCheckbox.Caption := 'Open installation folder when finished';
  OpenFolderCheckbox.Checked := True;
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := True;
  
  if CurPageID = GamePage.ID then
  begin
    if not FileExists(GameExeEdit.Text) then
    begin
      MsgBox('Original game executable not found! Please select a valid file.', mbError, MB_OK);
      Result := False;
      Exit;
    end;
    
    if not FileExists(PatchFileEdit.Text) then
    begin
      MsgBox('Patch file not found! Please select a valid .xdelta file.', mbError, MB_OK);
      Result := False;
      Exit;
    end;
    
    GamePath := GameExeEdit.Text;
    GameFolderPath := ExtractFilePath(GamePath);
    PatchPath := PatchFileEdit.Text;
  end;
end;

procedure CopyFolder(SourcePath, DestPath: string);
var
  FindRec: TFindRec;
  SourceFile: string;
  DestFile: string;
begin
  if FindFirst(SourcePath + '\*.*', FindRec) then
  begin
    try
      repeat
        if (FindRec.Name <> '.') and (FindRec.Name <> '..') then
        begin
          SourceFile := SourcePath + '\' + FindRec.Name;
          DestFile := DestPath + '\' + FindRec.Name;
          
          if FindRec.Attributes and FILE_ATTRIBUTE_DIRECTORY = 0 then
          begin
            FileCopy(SourceFile, DestFile, False);
            WizardForm.ProgressGauge.Position := WizardForm.ProgressGauge.Position + 1;
          end
          else
          begin
            CreateDir(DestFile);
            CopyFolder(SourceFile, DestFile);
          end;
        end;
      until not FindNext(FindRec);
    finally
      FindClose(FindRec);
    end;
  end;
end;

function CountFiles(Path: string): Integer;
var
  FindRec: TFindRec;
begin
  Result := 0;
  if FindFirst(Path + '\*.*', FindRec) then
  begin
    try
      repeat
        if (FindRec.Name <> '.') and (FindRec.Name <> '..') then
        begin
          if FindRec.Attributes and FILE_ATTRIBUTE_DIRECTORY = 0 then
            Result := Result + 1
          else
            Result := Result + CountFiles(Path + '\' + FindRec.Name);
        end;
      until not FindNext(FindRec);
    finally
      FindClose(FindRec);
    end;
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  ResultCode: Integer;
  GameFileName: string;
  GameFolder: string;
  DestGamePath: string;
  TotalFiles: Integer;
  SteamAppIdFile: string;
begin
  if CurStep = ssInstall then
  begin
    GameFolder := ExpandConstant('{app}');
    CreateDir(GameFolder);
    
    TotalFiles := CountFiles(GameFolderPath);
    WizardForm.ProgressGauge.Max := TotalFiles + 4;
    WizardForm.ProgressGauge.Position := 0;
    
    CopyFolder(GameFolderPath, GameFolder);
    
    ModsFolder := GameFolder + '\mods';
    ModsUnpackedFolder := GameFolder + '\mods-unpacked';
    CreateDir(ModsFolder);
    CreateDir(ModsUnpackedFolder);
    WizardForm.ProgressGauge.Position := WizardForm.ProgressGauge.Position + 2;
    
    SteamAppIdFile := GameFolder + '\steam_appid.txt';
    if SaveStringToFile(SteamAppIdFile, '2835570', False) then
      WizardForm.ProgressGauge.Position := WizardForm.ProgressGauge.Position + 1;
    
    ExtractTemporaryFile('xdelta3.exe');
    WizardForm.ProgressGauge.Position := WizardForm.ProgressGauge.Position + 1;
    
    GameFileName := ExtractFileName(GamePath);
    DestGamePath := GameFolder + '\' + GameFileName;
    
    PatchSuccess := False;
    if Exec(ExpandConstant('{tmp}\xdelta3.exe'), 
         '-d -s "' + DestGamePath + '" "' + PatchPath + '" "' + DestGamePath + '.patched"', 
         '', SW_HIDE, ewWaitUntilTerminated, ResultCode) then
    begin
      if ResultCode = 0 then
      begin
        DeleteFile(DestGamePath);
        RenameFile(DestGamePath + '.patched', DestGamePath);
        PatchSuccess := True;
      end;
    end;
  end;
  
  if CurStep = ssPostInstall then
  begin
    if not PatchSuccess then
      MsgBox('Patch failed!', mbError, MB_OK);
  end;
end;

procedure DeinitializeSetup();
var
  ResultCode: Integer;
begin
  if PatchSuccess and OpenFolderCheckbox.Checked then
    ShellExec('open', ExpandConstant('{app}'), '', '', SW_SHOWNORMAL, ewNoWait, ResultCode);
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  if CurPageID = wpFinished then
  begin
    WizardForm.FinishedLabel.Caption := 'Buckshot Roulette Mod Loader Extended has been successfully installed.';
  end;
end;