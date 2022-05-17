unit AddPlaylistUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, Vcl.ExtDlgs;

type
  TAddPlaylistForm = class(TForm)
    PlaylistImage: TImage;
    PlaylistNameEdit: TEdit;
    CreatePlaylistButton: TButton;
    CloseFormLabel: TLabel;
    OpenPictureDialog: TOpenPictureDialog;
    InfoLabel: TLabel;
    ImagePathLabel: TLabel;
    procedure PlaylistNameEditChange(Sender: TObject);
    procedure CloseFormLabelClick(Sender: TObject);
    procedure PlaylistImageClick(Sender: TObject);
    procedure CloseFormLabelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure CloseFormLabelMouseLeave(Sender: TObject);
    procedure CreatePlaylistButtonClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure PlaylistNameEditKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure SetLang(Lang: String);
    procedure FormActivate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AddPlaylistForm: TAddPlaylistForm;

implementation
{$R *.dfm}

uses
    PlaySoundUnit, AddPlaylistSongsUnit;

procedure TAddPlaylistForm.CloseFormLabelClick(Sender: TObject);
begin
    AddPlaylistForm.Close;
    PlaySoundForm.Show;
end;

procedure TAddPlaylistForm.CloseFormLabelMouseLeave(Sender: TObject);
begin
    CloseFormLabel.Font.Style := [];
end;

procedure TAddPlaylistForm.CloseFormLabelMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
    CloseFormLabel.Font.Style := [fsUnderline];
end;

procedure TAddPlaylistForm.CreatePlaylistButtonClick(Sender: TObject);
var
    PrevName, NewName, DirExt: String;
    SearchRec: TSearchRec;
    IsFind: Boolean;
begin
    if ImagePathLabel.Caption <> '' then
        DirExt :=  Copy(ImagePathLabel.Caption, Length(ImagePathLabel.Caption) - 3, 4);
    if ((CreatePlaylistButton.Caption = 'Создать') or (CreatePlaylistButton.Caption = 'Create')) then
    begin
        AddPlaylistSongsForm.PlaylistImage.Picture := PlaylistImage.Picture;
        AddPlaylistSongsForm.PlaylistName.Caption := PlaylistNameEdit.Text;
        AddPlaylistSongsForm.MusicListBox.Clear;
        AddPlaylistForm.Hide;
        AddPlaylistSongsForm.ShowModal;
    end
    else
    begin
        SetCurrentDir(FileDirectory + 'Playlists');
        PrevName := FileDirectory + 'Playlists\' + PlaySoundForm.PlaylistsListBox.Items[PlaySoundForm.PlaylistsListBox.ItemIndex];
        NewName := FileDirectory + 'Playlists\' + PlaylistNameEdit.Text;
        RenameFile(PrevName, NewName);
        if not ((ImagePathLabel.Caption = '') or (Copy(ImagePathLabel.Caption, 1, Length(PrevName)) = PrevName)) then
        begin
            SetCurrentDir(NewName);
            IsFind := False;
            if FindFirst('*', faAnyFile, SearchRec) = 0 then
                repeat
                    if (Copy(SearchRec.Name, 1, 5) = 'image') then
                    begin
                        DeleteFile(SearchRec.Name);
                        IsFind := True;
                    end;
                until (IsFind or (FindNext(SearchRec) <> 0));
            if not isFind then
                FindClose(SearchRec);
            CopyFile(PChar(AddPlaylistForm.ImagePathLabel.Caption), PChar(FileDirectory + 'Playlists\' + PlaylistNameEdit.Text + '\image' + DirExt), True);
        end;
        AddPlaylistForm.Close;
        PlaySoundForm.PlaylistsBtnBtn.Click;
    end;
end;


procedure TAddPlaylistForm.FormActivate(Sender: TObject);
begin
    SetLang(PlaySoundUnit.Lang);
end;

procedure TAddPlaylistForm.FormCreate(Sender: TObject);
begin
    SetLang(PlaySoundUnit.Lang);
end;

procedure TAddPlaylistForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
    if Key = #13 then
        CreatePlaylistButton.Click;

    if Key = #27 then
        AddPlaylistForm.Close;
end;

procedure TAddPlaylistForm.PlaylistImageClick(Sender: TObject);
begin
    if OpenPictureDialog.Execute then
    begin
        PlaylistImage.Picture.LoadFromFile(OpenPictureDialog.FileName);
        ImagePathLabel.Caption := OpenPictureDialog.FileName;
    end;
end;

procedure TAddPlaylistForm.PlaylistNameEditChange(Sender: TObject);
begin
    if PlaylistNameEdit.Text = '' then
    begin
        CreatePlaylistButton.Enabled := False;
    end
    else
    begin
        CreatePlaylistButton.Enabled := True;
    end;
end;

procedure TAddPlaylistForm.PlaylistNameEditKeyPress(Sender: TObject;
  var Key: Char);
begin
    if ((Key = #13) and (PlaylistNameEdit.Text <> ''))  then
        CreatePlaylistButton.Click;
end;

procedure TAddPlaylistForm.SetLang(Lang: String);
begin
    if PlaySoundUnit.Lang = 'RUS' then
    begin
        Caption := 'Создание плейлиста';
        PlaylistImage.Hint := 'Изменить обложку альбома';
        InfoLabel.Caption := 'Название плейлиста:';
        CloseFormLabel.Caption := 'Выйти';
    end
    else
    begin
        Caption := 'Playlist creating';
        PlaylistImage.Hint := 'Change playlist image';
        InfoLabel.Caption := 'Playlist name:';
        CloseFormLabel.Caption := 'Cancel';
    end;
end;

end.
