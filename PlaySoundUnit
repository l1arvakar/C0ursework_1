unit PlaySoundUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.MPlayer, Vcl.StdCtrls, Vcl.ComCtrls,
    Vcl.Menus, Vcl.ExtCtrls, Vcl.Imaging.jpeg, Vcl.Buttons, Vcl.FileCtrl,
    Vcl.WinXCtrls, mmsystem, ShellAPI, Vcl.Imaging.pngimage, Vcl.JumpList,
    Vcl.WinXPickers, Vcl.TabNotBk, Vcl.ExtDlgs;

type
  TPlaySoundForm = class(TForm)
    PrevTrackBtn: TBitBtn;
    StopBtn: TBitBtn;
    NextTrackBtn: TBitBtn;
    SettingsBtn: TBitBtn;
    SongImage: TImage;
    NowTimeLabel: TLabel;
    MaxTimeLabel: TLabel;
    TrackBar: TTrackBar;
    VolumeBar: TTrackBar;
    VolumeLabel: TLabel;
    TrackNameLabel: TLabel;
    MyTracksBtn: TBitBtn;
    PlaylistsBtnBtn: TBitBtn;
    CreatePlaylistBtn: TBitBtn;
    CycleBtn: TBitBtn;
    PlaylistsListBox: TListBox;
    DeletePlaylistBtn: TBitBtn;
    EqualizerBtn: TBitBtn;
    MiniViewBtn: TBitBtn;
    ExplorerBtn: TBitBtn;
    MediaPlayer: TMediaPlayer;
    TrackTimer: TTimer;
    PlayBtn: TBitBtn;
    TracksListBox: TFileListBox;
    MuteBtn: TSpeedButton;
    Cycle1TrackBtn: TBitBtn;
    NoCycleBtn: TBitBtn;
    RefocusTimer: TTimer;
    BitBtn2: TBitBtn;
    AddPlaylistBtn: TBitBtn;
    RandBtn: TSpeedButton;
    DeleteTrackBtn: TBitBtn;
    DefaultImage: TImage;
    ChangePlaylistBtn: TBitBtn;
    BitBtn3: TBitBtn;
    PlaylistNAmeLabel: TLabel;
    AddTrackBtn: TBitBtn;
    AddMusicDialog: TOpenDialog;
    RenameTrackBtn: TBitBtn;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Panel: TPanel;
    AskLabel: TLabel;
    TipLabel: TLabel;
    procedure StopBtnClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure PauseTrack;
    procedure PlayTrack;
    procedure FormCreate(Sender: TObject);
    procedure FindDir;
    procedure LoadPlaylists;
    procedure CopyTracks(Directory: String);
    procedure LoadTracks;
    function GetCurrentUserName: string;
    procedure TrackDblClick(Sender: TObject);
    procedure UpdateTime;
    procedure TrackBarChange(Sender: TObject);
    procedure TrackTimerTimer(Sender: TObject);
    procedure CycleBtnClick(Sender: TObject);
    procedure Cycle1TrackBtnClick(Sender: TObject);
    procedure NoCycleBtnClick(Sender: TObject);
    procedure ActivateMusicPlayer;
    procedure DisactivateMusicPlayer;
    procedure UpdateTrackName;
    procedure MuteBtnClick(Sender: TObject);
    procedure VolumeBarChange(Sender: TObject);
    procedure MiniViewBtnClick(Sender: TObject);
    procedure RandBtnClick(Sender: TObject);
    procedure RefocusTimerTimer(Sender: TObject);
    procedure NextTrackBtnClick(Sender: TObject);
    procedure PlayBtnClick(Sender: TObject);
    procedure PrevTrackBtnClick(Sender: TObject);
    procedure MyTracksBtnClick(Sender: TObject);
    procedure PlaylistsBtnBtnClick(Sender: TObject);
    procedure ExplorerBtnClick(Sender: TObject);
    procedure AddPlaylistBtnClick(Sender: TObject);
    procedure DeletePlaylistBtnClick(Sender: TObject);
    procedure PlaylistsListBoxDblClick(Sender: TObject);
    procedure CreatePlaylistBtnClick(Sender: TObject);
    procedure ChangePlaylistBtnClick(Sender: TObject);
    procedure DeleteTrackBtnClick(Sender: TObject);
    procedure AddTrackBtnClick(Sender: TObject);
    procedure RenameTrackBtnClick(Sender: TObject);
    procedure SettingsBtnClick(Sender: TObject);
    procedure FindCfg;
    procedure CreateCfg;
    procedure ReadCfg;
    procedure SetLang(Lang: String);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
  PlaySoundForm: TPlaySoundForm;
  IsPlaying, IsActivate: Boolean;
  FileDirectory, CurrDirectory, CurrPlaylist, Lang: String;
  CurrTrack, VolumeValue, PrevPrevTrack, PrevTrack, PathCounter: Integer;
  Pathes: Array of String;

implementation

{$R *.dfm}

uses
    ToolsUnit, AddPlaylistUnit, RenameTrackUnit, MiniViewUnit, SettingsUnit, MusicPathsUnit;


procedure TPlaySoundForm.PauseTrack();
begin
    MediaPlayer.Pause;
    IsPlaying := False;
    StopBtn.Visible := False;
    PlayBtn.Visible := True;
end;

procedure TPlaySoundForm.PlayBtnClick(Sender: TObject);
begin
    PlayTrack;
    StopBtn.Visible := True;
    PlayBtn.Visible := False;
end;

procedure TPlaySoundForm.PlaylistsBtnBtnClick(Sender: TObject);
begin
    LoadPlaylists;
end;

procedure TPlaySoundForm.PlaylistsListBoxDblClick(Sender: TObject);
var
    PlayListDirectory, ImagePath, ErrorCap, ErrorMsg: String;
    SearchRec: TSearchRec;
    IsFind: Boolean;
begin
    if PlaylistsListBox.ItemIndex <> - 1 then
    begin
        Panel.Visible := False;
        PlayListDirectory := FileDirectory + 'Playlists\' + PlaylistsListBox.Items[PlaylistsListBox.ItemIndex];
        if PlayListDirectory <> CurrPlaylist then
        begin
            DisactivateMusicPlayer;
            PlaylistNameLAbel.Caption := PlaylistsListBox.Items[PlaylistsListBox.ItemIndex] + ':';
            if DirectoryExists(PlayListDirectory) then
            begin
                CurrPlaylist := PlayListDirectory;
                TracksListBox.Directory:= CurrPlaylist;
                TracksListBox.Update;
                SetCurrentDir(CurrPlaylist);
                IsFind := False;
                if FindFirst('*', faAnyFile, SearchRec) = 0 then
                    repeat
                        if (Copy(SearchRec.Name, 1, 5) = 'image') then
                        begin
                            ImagePath := SearchRec.Name;
                            IsFind := True;
                        end;
                    until (IsFind or (FindNext(SearchRec) <> 0));
            end;
            FindClose(SearchRec);
            if FileExists(ImagePath) then
                SongImage.Picture.LoadFromFile(ImagePath)
            else
                SongImage.Picture := DefaultImage.Picture;
            CurrTrack := 1000000;
            if TracksListBox.Count <> 0 then
                TracksListBox.Selected[0] := True;
            TracksListBox.ItemIndex := -1;
        end;
    end;
end;

procedure TPlaySoundForm.PlayTrack();
begin
    MediaPlayer.Play;
    IsPlaying := True;
    StopBtn.Visible := True;
    PlayBtn.Visible := False;
end;

procedure TPlaySoundForm.PrevTrackBtnClick(Sender: TObject);
var
    FileNAme: String;
begin
    if RandBtn.Down then
    begin
        Randomize;
        PrevPrevTrack := PrevTrack;
        PrevTrack := CurrTrack;
        repeat
            CurrTrack := Random(TracksListBox.Items.Count);
        until (CurrTrack <> PrevTrack) and (CurrTrack <> PrevPrevTrack);
    end
    else
    begin
        Dec(CurrTrack);
        if CurrTrack = -1 then
            CurrTrack := TracksListBox.Items.Count - 1;
    end;
    FileName := TracksListBox.Items[CurrTrack];
    if CurrPlaylist = '' then
    begin
        if FileExists('Playlists\' + FileName) then
        begin
            TracksListBox.Selected[CurrTrack] := True;
            try
                MediaPlayer.FileName := 'Playlists\' + FileName;
                MediaPlayer.Open;
                UpdateTrackName;
                UpdateTime;
                PlayTrack;
            except
                DisactivateMusicPlayer;
                if Lang = 'RUS' then
                    MessageBox(Handle, PChar('Файл не проигрывается'), PChar('Ошибка'), MB_OK + MB_ICONERROR)
                else
                    MessageBox(Handle, PChar('Unable to play the file'), PChar('Error'), MB_OK + MB_ICONERROR);
                TrackBar.Position := 0;
                TrackNameLabel.Caption := '';
            end;
        end;
    end
    else
    begin
        if FileExists(CurrPlaylist + '\' + FileName) then
        begin
            TracksListBox.Selected[CurrTrack] := True;
            try
                MediaPlayer.FileName := CurrPlaylist + '\' + FileName;
                MediaPlayer.Open;
                UpdateTrackName;
                UpdateTime;
                PlayTrack;
            except
                DisactivateMusicPlayer;
                if Lang = 'RUS' then
                    MessageBox(Handle, PChar('Файл не проигрывается'), PChar('Ошибка'), MB_OK + MB_ICONERROR)
                else
                    MessageBox(Handle, PChar('Unable to play the file'), PChar('Error'), MB_OK + MB_ICONERROR);
                TrackBar.Position := 0;
                TrackNameLabel.Caption := '';
            end;
        end;
    end;
end;

procedure TPlaySoundForm.RandBtnClick(Sender: TObject);
begin
    if RandBtn.Down then
    begin
        NoCycleBtn.Visible := False;
        Cycle1TrackBtn.Visible := False;
        CycleBtn.Visible := True;
        Image1.Visible := True;
    end
    else
        Image1.Visible := False;
end;

procedure TPlaySoundForm.FormCreate(Sender: TObject);
var
    UserName, Directory: String;
    i: Integer;
begin
    PlaySoundForm.Height := 629;
    PlaySoundForm.Width := 742;
    Tools.SetVolume(4500, 4500);
    CurrTrack := -1;
    IsPlaying := False;
    isActivate := False;
    StopBtn.Visible := False;
    PlayBtn.Visible := True;
    PlayBtn.Enabled := True;
    TrackBar.Enabled := False;
    FileDirectory  := ExtractFilePath(ParamStr(0));
    SetLength(Pathes, 15);
    for i := 0 to 14 do
        Pathes[i] := '';
    FindDir;
    FindCfg;
    SetLang(Lang);
    DisactivateMusicPlayer;
end;

procedure TPlaySoundForm.FindCfg;
begin
    if FileExists(FileDirectory + 'settings.cfg') then
        ReadCfg
    else
        CreateCfg;
end;

procedure TPlaySoundForm.ReadCfg;
var
    CfgFile: TextFile;
begin
    AssignFile(CfgFile, FileDirectory + 'settings.cfg');
    Reset(CfgFile);
    Readln(CfgFile, Lang);
    SetLang(Lang);
    PathCounter := 0;
    while not Eof(CfgFile) do
    begin
        Readln(CfgFile, Pathes[PathCounter]);
        Inc(PathCounter);
    end;
    CloseFile(CfgFile);
end;

procedure TPlaySoundForm.CreateCfg;
var
    CfgFile: TextFile;
    UserName: String;
begin
    AssignFile(CfgFile,FileDirectory + 'settings.cfg');
    Rewrite(CfgFile);
    Writeln(CfgFile, 'RUS');
    Lang := 'RUS';
    SetLang(Lang);
    UserName := GetCurrentUserName;
    Writeln(CfgFile, 'C:\Users\' + UserName + '\Downloads');
    Pathes[0] := 'C:\Users\' + UserName + '\Downloads';
    Write(CfgFile,'C:\Users\' + UserName + '\Music');
    Pathes[2] := 'C:\Users\' + UserName + '\Music';
    PathCounter := 2;
    CloseFile(CfgFile);
end;

procedure TPlaySoundForm.SetLang(Lang: String);
begin
    if Lang = 'RUS' then
    begin
        PlaySoundForm.MyTracksBtn.Caption := 'Мои треки';
        PlaySoundForm.MyTracksBtn.Hint := 'Показать песни';
        PlaySoundForm.PlaylistsBtnBtn.Caption := 'Плейлисты';
        PlaySoundForm.PlaylistsBtnBtn.Hint := 'Показать плейлисты';
        PlaySoundForm.SettingsBtn.Caption := 'Настройки';
        PlaySoundForm.SettingsBtn.Hint := 'Настройки плеера';
        PlaySoundForm.PrevTrackBtn.Hint := 'Предыдущий трек';
        PlaySoundForm.StopBtn.Hint := 'Пауза';
        PlaySoundForm.PlayBtn.Hint := 'Пуск';
        PlaySoundForm.NextTrackBtn.Hint := 'Следующий трек';
        PlaySoundForm.NoCycleBtn.Hint := 'Повтор: 1 трек';
        PlaySoundForm.CycleBtn.Hint := 'Повтор: выкл';
        PlaySoundForm.Cycle1TrackBtn.Hint := 'Повтор: вкл';
        PlaySoundForm.RandBtn.Hint := 'Воспроизводить в случайном порядке';
        PlaySoundForm.MiniViewBtn.Hint := 'Показывать в мини окне';
        PlaySoundForm.MuteBtn.Hint := 'Без звука';
        PlaySoundForm.AddTrackBtn.Hint := 'Добавить трек';
        PlaySoundForm.DeleteTrackBtn.Hint := 'Удалить трек';
        PlaySoundForm.RenameTrackBtn.Hint := 'Переименовать трек';
        PlaySoundForm.CreatePlaylistBtn.Hint := 'Создать плейлист';
        PlaySoundForm.AddPlaylistBtn.Hint := 'Копировать плейлист';
        PlaySoundForm.DeletePlaylistBtn.Hint := 'Удалить плейлист';
        PlaySoundForm.ChangePlaylistBtn.Hint := 'Редактировать плейлист';
        PlaySoundForm.ExplorerBtn.Hint := 'Расположение плейлистов';
        AskLabel.Caption := 'Музыка не найдена?';
        TipLAbel.Caption := 'Добавьте путь к музыке в настройках';
        if PlaylistNameLabel.Caption = 'My tracks:' then
            PlaylistNameLabel.Caption := 'Мои треки:';
    end
    else
    begin
        PlaySoundForm.MyTracksBtn.Caption := 'My tracks';
        PlaySoundForm.MyTracksBtn.Hint := 'Show songs';
        PlaySoundForm.PlaylistsBtnBtn.Caption := 'Playlists';
        PlaySoundForm.PlaylistsBtnBtn.Hint := 'Show playlists';
        PlaySoundForm.SettingsBtn.Caption := 'Settings';
        PlaySoundForm.SettingsBtn.Hint := 'Player''s settings';
        PlaySoundForm.PrevTrackBtn.Hint := 'Previos track';
        PlaySoundForm.StopBtn.Hint := 'Pause';
        PlaySoundForm.PlayBtn.Hint := 'Play';
        PlaySoundForm.NextTrackBtn.Hint := 'Next track';
        PlaySoundForm.NoCycleBtn.Hint := 'Repeat: 1 track';
        PlaySoundForm.CycleBtn.Hint := 'Repeat: off';
        PlaySoundForm.Cycle1TrackBtn.Hint := 'Repeat: on';
        PlaySoundForm.RandBtn.Hint := 'Play in random order';
        PlaySoundForm.MiniViewBtn.Hint := 'Play in mini view';
        PlaySoundForm.MuteBtn.Hint := 'Mute';
        PlaySoundForm.AddTrackBtn.Hint := 'Add track';
        PlaySoundForm.DeleteTrackBtn.Hint := 'Delete track';
        PlaySoundForm.RenameTrackBtn.Hint := 'Rename track';
        PlaySoundForm.CreatePlaylistBtn.Hint := 'Create playlist';
        PlaySoundForm.AddPlaylistBtn.Hint := 'Copy playlist';
        PlaySoundForm.DeletePlaylistBtn.Hint := 'Delete playlist';
        PlaySoundForm.ChangePlaylistBtn.Hint := 'Edit playlist';
        PlaySoundForm.ExplorerBtn.Hint := 'Playlists location';
        AskLabel.Caption := 'Music isn''t found?';
        TipLAbel.Caption := 'Add path in settings';
        if PlaylistNameLabel.Caption = 'Мои треки:' then
            PlaylistNameLabel.Caption := 'My tracks:';
    end;
end;

function TPlaySoundForm.GetCurrentUserName: string;
 const
   cnMaxUserNameLen = 254;
 var
   sUserName: string;
   dwUserNameLen: DWORD;
 begin
   dwUserNameLen := cnMaxUserNameLen - 1;
   SetLength(sUserName, cnMaxUserNameLen);
   GetUserName(PChar(sUserName), dwUserNameLen);
   SetLength(sUserName, dwUserNameLen - 1);
   Result := sUserName;
 end;

procedure TPlaySoundForm.AddPlaylistBtnClick(Sender: TObject);
var
    Directory, str: String;
begin
    if Lang = 'RUS' then
        Str := 'Выберите папку плейлиста'
    else
        Str := 'Select playlist directory';
    if SelectDirectory(Str, '', Directory) then
    begin
        Tools.CopyDir(Directory, FileDirectory + 'Playlists\' + Tools.TakeName(Directory));
        LoadPlaylists();
    end;
end;

procedure TPlaySoundForm.AddTrackBtnClick(Sender: TObject);
var
    Path: String;
begin
    Panel.Visible := False;
    if CurrPlaylist <> '' then
        Path := CurrPlaylist + '\'
    else
        Path := FileDirectory + 'Playlists\';
    if AddMusicDialog.Execute() then
    begin
        CopyFile(PChar(AddMusicDialog.FileName), PChar(Path + Tools.TakeName(AddMusicDialog.FileName)), True);
        TracksListBox.Update;
    end;
    if CurrPlaylist = '' then
            MyTracksBtn.Click;
end;

procedure TPlaySoundForm.ChangePlaylistBtnClick(Sender: TObject);
var
    PlayListDirectory: String;
    SearchRec: TSearchRec;
    IsFind: Boolean;
begin
    if PlaylistsListBox.ItemIndex <> -1  then
    begin
        AddPlaylistForm.PlaylistNameEdit.Text := PlaylistsListBox.Items[PlaylistsListBox.ItemIndex];
        PlayListDirectory := FileDirectory + 'Playlists\' + PlaylistsListBox.Items[PlaylistsListBox.ItemIndex];
        if CurrPlayList = PlayListDirectory then
        begin
            DisactivateMusicPlayer;
            TracksListBox.Clear;
        end;
        SetCurrentDir(PlayListDirectory);
        IsFind := False;
        if FindFirst('*', faAnyFile, SearchRec) = 0 then
            repeat
                if (Copy(SearchRec.Name, 1, 5) = 'image') then
                begin
                    AddPlaylistForm.PlaylistImage.Picture.LoadFromFile(SearchRec.Name);
                    AddPlaylistForm.ImagePathLabel.Caption:=PlayListDirectory + '\' + SearchRec.Name;
                    IsFind := True;
                end;
            until (IsFind or (FindNext(SearchRec) <> 0));
        if not IsFind then
        begin
            AddPlaylistForm.PlaylistImage.Picture := DefaultImage.Picture;
            AddPlaylistForm.ImagePathLabel.Caption := '';
        end;
        if Lang = 'RUS' then
            AddPlaylistForm.CreatePlaylistButton.Caption := 'Сохранить'
        else
            AddPlaylistForm.CreatePlaylistButton.Caption := 'Save';
        AddPlaylistForm.ShowModal;
    end;
end;

procedure TPlaySoundForm.CopyTracks(Directory: String);
var
    FindResult: TSearchRec;
begin
    SetCurrentDir(Directory);
    if FindFirst( '*', faAnyFile, FindResult ) = 0 then
    begin
        repeat
            if (Copy(FindResult.Name, Length(FindResult.Name) - 3, 4) = '.mp3') then
                if not FileExists(FileDirectory + 'Playlists\' + FindResult.Name) then
                    CopyFile(Pchar(Directory + '\' + FindResult.Name), Pchar(FileDirectory + 'Playlists\' + FindResult.Name), True);
        until FindNext(FindResult) <> 0;
        FindClose(FindResult);
    end;
end;

procedure TPlaySoundForm.CreatePlaylistBtnClick(Sender: TObject);
begin
    AddPlaylistForm.PlaylistNameEdit.Text := '';
    AddPlaylistForm.PlaylistImage.Picture := DefaultImage.Picture;
    if Lang = 'RUS' then
        AddPlaylistForm.CreatePlaylistButton.Caption := 'Создать'
    else
        AddPlaylistForm.CreatePlaylistButton.Caption := 'Create';
    AddPlaylistForm.ShowModal;
end;

procedure TPlaySoundForm.Cycle1TrackBtnClick(Sender: TObject);
begin
    Cycle1TrackBtn.Visible := False;
    NoCycleBtn.Visible := True;
end;

procedure TPlaySoundForm.CycleBtnClick(Sender: TObject);
begin
    RandBtn.Down := False;
    CycleBtn.Visible := False;
    Cycle1TrackBtn.Visible := True;
    Image3.Visible := True;
end;

procedure TPlaySoundForm.FindDir();
begin
    if not FileExists(FileDirectory + 'Playlists') then
          CreateDir(FileDirectory + 'Playlists');
end;

procedure TPlaySoundForm.LoadPlaylists();
var
    FindResult: TSearchRec;
begin
    PlaylistsListBox.Clear;
    SetCurrentDir(FileDirectory + 'Playlists');
    if FindFirst('*', faDirectory, FindResult) = 0 then
    begin
        repeat
            if ((FindResult.attr and faDirectory) = faDirectory) and (FindResult.Name <> '.') and (FindResult.Name <> '..') and ((Length(FindResult.Name) < 4) or (Copy(FindResult.Name, Length(FindResult.Name) - 3, 4) <> '.mp3'))  then
                PlaylistsListBox.Items.Add(FindResult.Name);
        until FindNext(FindResult) <> 0;
        FindClose(FindResult);
    end;
end;

procedure TPlaySoundForm.LoadTracks();
var
    FindResult: TSearchRec;
    str: String;
begin
    TracksListBox.Clear;
    SetCurrentDir(FileDirectory + 'Playlists');
    str := FileDirectory + 'Playlists';
    if FindFirst('*', faDirectory, FindResult) = 0 then
    begin
        repeat
            if (FindResult.Name <> '.') and (FindResult.Name <> '..') and  ((Length(FindResult.Name) >= 4) and (Copy(FindResult.Name, Length(FindResult.Name) - 3, 4) = '.mp3'))  then
                TracksListBox.Items.Add(FindResult.Name);
        until FindNext(FindResult) <> 0;
        FindClose(FindResult);
    end;
end;

procedure TPlaySoundForm.MiniViewBtnClick(Sender: TObject);
begin
    Top:=Screen.WorkAreaRect.Bottom;
    Left:=Screen.WorkAreaRect.Right;
    MiniViewForm.ShowModal;
end;

procedure TPlaySoundForm.MuteBtnClick(Sender: TObject);
begin
    if MuteBtn.Down then
    begin
        VolumeValue := VolumeBar.Position;
        VolumeBar.Position := 100;
        VolumeBar.Enabled := False;
        Image2.Visible := True;
    end
    else
    begin
        VolumeBar.Enabled := True;
        VolumeBar.Position := VolumeValue;
        Image2.Visible := False;
    end;
end;

procedure TPlaySoundForm.MyTracksBtnClick(Sender: TObject);
var
    UserName: String;
    i: Integer;
begin
    Panel.Visible := False;
    DisactivateMusicPlayer;
    UserName := GetCurrentUserName;
    for I := 0 to PathCounter - 1 do
        CopyTracks(Pathes[i]);
    CurrTrack := -1;
    LoadTracks;
    TracksListBox.Directory := FileDirectory + 'Playlists';
    SongImage.Picture := DefaultImage.Picture;
    CurrDirectory := FileDirectory + 'Playlists';
    if Lang = 'RUS' then
        PlaylistNameLabel.Caption := 'Мои треки:'
    else
        PlaylistNameLabel.Caption := 'My tracks:';
    CurrPlaylist := '';
    if TracksListBox.Count = 0 then
        Panel.Visible := True;
end;

procedure TPlaySoundForm.NextTrackBtnClick(Sender: TObject);
var
    FileNAme: String;
begin
    if RandBtn.Down then
    begin
        Randomize;
        PrevPrevTrack := PrevTrack;
        PrevTrack := CurrTrack;
        repeat
            CurrTrack := Random(TracksListBox.Items.Count);
        until (CurrTrack <> PrevTrack) and (CurrTrack <> PrevPrevTrack);
    end
    else
    begin
        Inc(CurrTrack);
        if CurrTrack = TracksListBox.Items.Count then
            CurrTrack := 0;
    end;
    FileName := TracksListBox.Items[CurrTrack];
    if CurrPlaylist = '' then
    begin
        if FileExists('Playlists\' + FileName) then
        begin
            TracksListBox.Selected[CurrTrack] := True;
            try
                MediaPlayer.FileName := 'Playlists\' + FileName;
                MediaPlayer.Open;
                UpdateTrackName;
                UpdateTime;
                PlayTrack;
            except
                DisactivateMusicPlayer;
                if Lang = 'RUS' then
                    MessageBox(Handle, PChar('Файл не проигрывается'), PChar('Ошибка'), MB_OK + MB_ICONERROR)
                else
                TrackBar.Position := 0;
                TrackNameLabel.Caption := '';
            end;
        end;
    end
    else
    begin
        if FileExists(CurrPlaylist + '\' + FileName) then
        begin
            TracksListBox.Selected[CurrTrack] := True;
            try
                MediaPlayer.FileName := CurrPlaylist + '\' + FileName;
                MediaPlayer.Open;
                UpdateTrackName;
                UpdateTime;
                PlayTrack;
            except
                DisactivateMusicPlayer;
                MessageBox(Handle, PChar('Файл не проигрывается'), PChar('Ошибка'), MB_OK + MB_ICONERROR);
                TrackBar.Position := 0;
                TrackNameLabel.Caption := '';
            end;
        end;
    end;
end;

procedure TPlaySoundForm.NoCycleBtnClick(Sender: TObject);
begin
    NoCycleBtn.Visible := False;
    CycleBtn.Visible := True;
    Image3.Visible := False;
end;

procedure TPlaySoundForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if (Key = VK_LEFT) and IsActivate then
    begin
        TrackBar.Position := TrackBar.Position - TrackBar.Max * 5 div (MediaPlayer.Length div 1000);
        TracksListBox.ItemIndex := TracksListBox.ItemIndex + 1;
    end;

    if (Key = VK_RIGHT) and IsActivate then
    begin
        TrackBar.Position := TrackBar.Position + TrackBar.Max * 5 div (MediaPlayer.Length div 1000);
        TracksListBox.ItemIndex := TracksListBox.ItemIndex - 1;
    end;
    if (Key = VK_UP) and IsActivate then
    begin
        VolumeBar.Position := VolumeBar.Position - 90;
        TracksListBox.ItemIndex := TracksListBox.ItemIndex + 1;
    end;
    if (Key = VK_DOWN) and IsActivate then
    begin
        VolumeBar.Position := VolumeBar.Position + 90;
        TracksListBox.ItemIndex := TracksListBox.ItemIndex - 1;
    end;
end;

procedure TPlaySoundForm.FormKeyPress(Sender: TObject; var Key: Char);
var
    Text: String;
begin
    if (Key = #32) and IsActivate then    //OnSpase
        if IsPlaying then
            PauseTrack()
        else
            PlayTrack();

    if (Key = 'M') or (Key = 'm') or (Key = 'ь') or (Key = 'Ь')then    //Mute
    begin
        if MuteBtn.Down then
           MuteBtn.Down := False
        else
            MuteBtn.Down := True;
        MuteBtnClick(MuteBtn);
    end;

    if Key = #27 then
    begin
        if Lang = 'RUS' then
        begin
            Text := 'Вы уверены, что хотите выйти?';
            if MessageBox(PlaySoundForm.Handle, PCHar(Text), 'd' , MB_YESNO + MB_ICONINFORMATION + MB_DEFBUTTON2) = ID_YES then
            begin
                PlaySoundForm.Close;
            end
        end
        else
        begin
            Text := 'Are you sure, you want to exit?';
            if MessageDlg(Text, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
            begin
                PlaySoundForm.Close;
            end
        end;
    end;
end;

procedure TPlaySoundForm.SettingsBtnClick(Sender: TObject);
begin
    SettingsForm.ShowModal;
end;

procedure TPlaySoundForm.StopBtnClick(Sender: TObject);
begin
    PauseTrack;
    StopBtn.Visible := False;
    PlayBtn.Visible := True;
end;

procedure TPlaySoundForm.RefocusTimerTimer(Sender: TObject);
begin
    TracksListBox.SetFocus;
end;

procedure TPlaySoundForm.RenameTrackBtnClick(Sender: TObject);
begin
    if Length(TracksListBox.FileName) <> 0 then
    begin
        RenameTrackForm.TrackNameEdit.Text := Copy(Tools.TakeName(TracksListBox.Items[TracksListBox.ItemIndex]),1, Length(Tools.TakeName(TracksListBox.Items[TracksListBox.ItemIndex])) - 4);
        RenameTrackForm.ShowModal;
    end;
end;

procedure TPlaySoundForm.TrackBarChange(Sender: TObject);
begin
    if IsActivate then
        MediaPlayer.Position := TrackBar.Position;
    if not GetKeyState(VK_LBUTTON) < 0 then
        if IsPlaying then
            PlayTrack
        else
        begin
            PlayTrack;
            PauseTrack;
        end;
end;

procedure TPlaySoundForm.TrackDblClick(Sender: TObject);
var
    ImagePath, FileName, str: string;
begin
    if (TracksListBox.ItemIndex <> -1) and (TracksListBox.ItemIndex <> CurrTrack) then
    begin
        if not IsPlaying then
        begin
            ActivateMusicPlayer();
        end;
        SetCurrentDir(FileDirectory);
        CurrTrack := TracksListBox.ItemIndex;
        FileName := TracksListBox.Items[CurrTrack];
        if CurrPlaylist = '' then
        begin
            if FileExists('Playlists\' + FileName) then
            begin
                TracksListBox.Selected[CurrTrack] := True;
                try
                    MediaPlayer.FileName := 'Playlists\' + FileName;
                    MediaPlayer.Open;
                    UpdateTrackName;
                    UpdateTime;
                    PlayTrack;
                except
                    DisactivateMusicPlayer;
                    if Lang = 'RUS' then
                        MessageBox(Handle, PChar('Файл не проигрывается'), PChar('Ошибка'), MB_OK + MB_ICONERROR)
                    else
                        MessageBox(Handle, PChar('Unable to play the file'), PChar('Error'), MB_OK + MB_ICONERROR);
                    TrackBar.Position := 0;
                    TrackNameLabel.Caption := '';
                end;
            end;
        end
        else
        begin
            if FileExists(CurrPlaylist + '\' + FileName) then
            begin
                TracksListBox.Selected[CurrTrack] := True;
                try
                    MediaPlayer.FileName := CurrPlaylist + '\' + FileName;
                    MediaPlayer.Open;
                    UpdateTrackName;
                    UpdateTime;
                    PlayTrack;
                except
                    DisactivateMusicPlayer;
                    if Lang = 'RUS' then
                        MessageBox(Handle, PChar('Файл не проигрывается'), PChar('Ошибка'), MB_OK + MB_ICONERROR)
                    else
                        MessageBox(Handle, PChar('Unable to play the file'), PChar('Error'), MB_OK + MB_ICONERROR);
                    TrackBar.Position := 0;
                    TrackNameLabel.Caption := '';
                end;
            end;
        end;
    end;
end;

procedure TPlaySoundForm.TrackTimerTimer(Sender: TObject);
var
    Event: TNotifyEvent;
    FileName: String;
begin
    Event := TrackBar.OnChange;
    TrackBar.OnChange := nil;
    if MediaPlayer.FileName <> '' then
    begin
        TrackBar.Max := MediaPlayer.Length;
        TrackBar.Position := MediaPlayer.Position;
        NowTimeLabel.Caption := FormatDateTime('nn:ss', (MediaPlayer.Position div 1000)/(24*60*60));
    end;
    TrackBar.OnChange := Event;


    if MediaPlayer.Position = MediaPlayer.Length then
    begin
        if RandBtn.Down then
        begin
            Randomize;
            PrevPrevTrack := PrevTrack;
            PrevTrack := CurrTrack;
            repeat
                CurrTrack := Random(TracksListBox.Items.Count);
            until (CurrTrack <> PrevTrack) and (CurrTrack <> PrevPrevTrack);
            FileName := TracksListBox.Items[CurrTrack];
            if FileExists('Playlists\' + FileName) then
            begin
                TracksListBox.Selected[CurrTrack] := True;
                MediaPlayer.FileName := 'Playlists\' + FileName;
                MediaPlayer.Open;
                UpdateTrackName();
                UpdateTime();
                PlayTrack();
            end;
        end
        else
            if NoCycleBtn.Visible = False then
            begin
                if TracksListBox.Count <> 0 then
                    if (CurrTrack <> TracksListBox.Items.Count - 1) or (Cycle1TrackBtn.Visible = True) then
                        NextTrackBtnClick(TrackTimer)
                    else
                    begin
                        PauseTrack;
                        DisactivateMusicPlayer()
                    end
                else
                begin
                    DisactivateMusicPlayer();
                end;
            end
            else
                PlayTrack();
    end;
end;

procedure TPlaySoundForm.ActivateMusicPlayer();
begin
    TrackBar.Enabled := True;
    PlayBtn.Enabled := True;
    StopBtn.Enabled := True;
    NextTrackBtn.Enabled := True;
    PrevTrackBtn.Enabled := True;
    TrackTimer.Enabled := True;
    CycleBtn.Enabled := True;
    IsActivate := True;
    CycleBtn.Enabled := True;
    RandBtn.Enabled := True;
    MiniViewBtn.Enabled := True;
    EqualizerBtn.Enabled := True;
end;
procedure TPlaySoundForm.DeletePlaylistBtnClick(Sender: TObject);
var
    PlaylistName, NowPlay: string;
    lpCaption, lpText: PChar;
begin
    if PlaylistsListBox.ItemIndex <> -1 then
    begin
        NowPlay := CurrPlaylist;
        SetCurrentDir(FileDirectory + 'Playlists');
        PlaylistName := FileDirectory + 'Playlists\' + PlaylistsListBox.Items[PlaylistsListBox.ItemIndex];
        if Lang = 'RUS' then
        begin
            lpCaption := 'Удаление';
            lpText := PChar('Вы действительно хотите удалить плейлист'#13#10 + PlaylistsListBox.Items[PlaylistsListBox.ItemIndex] +'?');
            if MessageBox(Handle, PChar(lpText), PChar(lpCaption), MB_YESNO + MB_ICONQUESTION) = IDYES then
            begin
                if NowPlay = PlaylistName then
                begin
                    MediaPlayer.Close;
                    DisactivateMusicPlayer;
                    TracksListBox.Clear;
                end;
                SetCurrentDir(FileDirectory + 'Playlists');
                Tools.DeleteDir(PlaylistName);
                LoadPlaylists();
            end;
        end
        else
        begin
            lpCaption := 'Deleting';
            lpText := PChar('Are you shure for deleting playlist'#13#10 + PlaylistsListBox.Items[PlaylistsListBox.ItemIndex] +'?');
            if MessageDlg(lpText, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
            begin
                if NowPlay = PlaylistName then
                begin
                    MediaPlayer.Close;
                    DisactivateMusicPlayer;
                    TracksListBox.Clear;
                end;
                SetCurrentDir(FileDirectory + 'Playlists');
                Tools.DeleteDir(PlaylistName);
                LoadPlaylists();
            end;
        end;
    end
    else
    begin
        if Lang = 'RUS' then
            MessageBox(Handle, PChar('Выберите плейлист'), PChar('Ошибка'), MB_OK + MB_ICONERROR)
        else
            MessageBox(Handle, PChar('Select playlist'), PChar('Error'), MB_OK + MB_ICONERROR)
    end;
end;

procedure TPlaySoundForm.DeleteTrackBtnClick(Sender: TObject);
var
    QuestCap, Question, ErrorCap, ErrorMsg: string;
    lpCaption, lpText: PChar;
    PrevIndex, PrevPos: Integer;
begin
    if Length(TracksListBox.FileName) <> 0 then
    begin
        if Lang = 'RUS' then
        begin
            lpCaption := 'Удаление';
            lpText := PChar('Вы действительно хотите удалить трек'#13#10 + TracksListBox.Items[TracksListBox.ItemIndex] +'?');
        end
        else
        begin
            lpCaption := 'Deleting';
            lpText := PChar('Are you shure for deleting track'#13#10 + TracksListBox.Items[TracksListBox.ItemIndex] +'?');
        end;
        if MessageBox(Handle, PChar(lpText), PChar(lpCaption), MB_YESNO + MB_ICONQUESTION) = IDYES then
        begin
            PrevPos := MediaPlayer.Position;
            PrevIndex := TracksListBox.ItemIndex;
            DeleteFile(TracksListBox.FileName);
            TracksListBox.Update;
            if TracksListBox.Count = 0 then
                DisactivateMusicPlayer
            else
            begin
                if PrevIndex >= CurrTrack  then
                    TracksListBox.ItemIndex := CurrTrack
                else
                begin
                    TracksListBox.ItemIndex := CurrTrack - 1;
                    PrevTrackBtn.Click;
                    TrackDblClick(TracksListBox);
                end;
                PrevTrackBtn.Click;
                TrackDblClick(TracksListBox);
                if CurrPlaylist <> '' then
                    NextTrackBtn.Click;
                if PrevIndex <> CurrTrack  then
                begin
                    MediaPlayer.Position := PrevPos;
                    StopBtn.Click;
                    PlayBtn.Click;
                end;
            end;
        end;
    end
    else
    begin
        if Lang = 'RUS' then
            MessageBox(Handle, PChar('Выберите трек'), PChar('Ошибка'), MB_OK + MB_ICONERROR)
        else
            MessageBox(Handle, PChar('Select track'), PChar('Error'), MB_OK + MB_ICONERROR)
    end;
end;

procedure TPlaySoundForm.DisactivateMusicPlayer();
begin
    TrackNameLabel.Caption := '';
    PlaylistNameLabel.Caption := '';
    SongImage.Picture := DefaultImage.Picture;
    MediaPlayer.Close;
    IsActivate := False;
    IsPlaying := False;
    TrackBar.Enabled := False;
    PlayBtn.Visible := True;
    PlayBtn.Enabled := False;
    StopBtn.Visible := False;
    NextTrackBtn.Enabled := False;
    PrevTrackBtn.Enabled := False;
    TrackTimer.Enabled := False;
    CycleBtn.Enabled := False;
    RandBtn.Enabled := False;
    MiniViewBtn.Enabled := False;
    EqualizerBtn.Enabled := False;
end;

procedure TPlaySoundForm.ExplorerBtnClick(Sender: TObject);
var
    FilePath: string;
begin
    FilePath := FileDirectory + 'Playlists';
    if not FileExists(FilePath) then
        CreateDir(FilePath);
    ShellExecute(0, 'open', PChar(FilePath), nil, nil, SW_SHOW);
end;

procedure TPlaySoundForm.UpdateTrackName;
var
    Name: string;
begin
    Name := Tools.TakeName(MediaPlayer.FileName);
    Delete(Name, Length(Name) - 3, 4);
    if Length(Name) > 40 then
    begin
        Delete(Name, 38, Length(Name) - 37);
        Insert('...',Name,38)
    end;
    TrackNameLabel.Caption := Name;
end;

procedure TPlaySoundForm.VolumeBarChange(Sender: TObject);
var
    Volume: Integer;
begin

    Tools.SetVolume(Abs(VolumeBar.Position),abs(VolumeBar.Position));
    Volume := Round((9000 + VolumeBar.Position) / 90);
    VolumeLabel.Caption := IntToStr(100 - Volume) + '%';
end;

procedure TPlaySoundForm.UpdateTime();
begin
    MaxTimeLabel.Caption := FormatDateTime('nn:ss', (MediaPlayer.Length div 1000)/(24*60*60));
end;

end.
