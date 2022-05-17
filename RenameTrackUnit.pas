unit RenameTrackUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, PlaySoundUnit, ToolsUnit;
type
  TRenameTrackForm = class(TForm)
    IndoLabel: TLabel;
    TrackNameEdit: TEdit;
    ConfirmBtn: TButton;
    CloseBtn: TButton;
    procedure TrackNameEditChange(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure ConfirmBtnClick(Sender: TObject);
    procedure TrackNameEditKeyPress(Sender: TObject; var Key: Char);
    procedure SetLang(Lang: String);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


var
  RenameTrackForm: TRenameTrackForm;

implementation

{$R *.dfm}

procedure TRenameTrackForm.CloseBtnClick(Sender: TObject);
begin
    RenameTrackForm.Close;
end;

procedure TRenameTrackForm.ConfirmBtnClick(Sender: TObject);
var
    Str: String;
begin
    Str := PlaySoundForm.TracksListBox.Items[PlaySoundForm.TracksListBox.ItemIndex];
    if PlaySoundUnit.CurrPlaylist = '' then
        RenameFile(PlaySoundUnit.FileDirectory + 'Playlists\' + PlaySoundForm.TracksListBox.Items[PlaySoundForm.TracksListBox.ItemIndex], PlaySoundUnit.FileDirectory + 'Playlists\' +  TrackNameEdit.Text + '.mp3')
    else
        RenameFile(PlaySoundUnit.CurrPlaylist + '\' + PlaySoundForm.TracksListBox.Items[PlaySoundForm.TracksListBox.ItemIndex], PlaySoundUnit.CurrPlaylist + '\' +  TrackNameEdit.Text + '.mp3');
    PlaySoundForm.TracksListBox.Update;
    RenameTrackForm.Close;
end;

procedure TRenameTrackForm.FormCreate(Sender: TObject);
begin
    SetLang(PlaySoundUnit.Lang);
end;

procedure TRenameTrackForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
    if Key = #27 then
        RenameTrackForm.Close;
end;

procedure TRenameTrackForm.TrackNameEditChange(Sender: TObject);
begin
    if TrackNameEdit.Text = '' then
    begin
        ConfirmBtn.Enabled := False;
    end
    else
    begin
        ConfirmBtn.Enabled := True;
    end;
end;

procedure TRenameTrackForm.TrackNameEditKeyPress(Sender: TObject;
  var Key: Char);
begin
    if ((Key = #13) and (TrackNameEdit.Text <> ''))  then
        ConfirmBtn.Click;
end;

procedure TRenameTrackForm.SetLang(Lang: String);
begin
    if Lang = 'RUS' then
    begin
        Caption := 'Переименовать';
        IndoLabel.Caption := 'Название трека:';
        ConfirmBtn.Caption := 'Сохранить';
        CloseBtn.Caption := 'Отмена';
    end
    else
    begin
        Caption := 'Rename';
        IndoLabel.Caption := 'Track name:';
        ConfirmBtn.Caption := 'Save';
        CloseBtn.Caption := 'Cancel';
    end;
end;

end.
