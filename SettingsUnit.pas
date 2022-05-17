unit SettingsUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, PlaySoundUnit, MusicPathsUnit, AboutProgramUnit;

type
  TSettingsForm = class(TForm)
    InfoLabel1: TLabel;
    InfoLabel2: TLabel;
    RussianLangLabel: TLabel;
    EnglishLangLabel: TLabel;
    PathButton: TButton;
    AboutButton: TButton;
    Timer: TTimer;
    Button1: TButton;
    procedure TimerTimer(Sender: TObject);
    procedure SetLang(Lang: String);
    procedure RussianLangLabelClick(Sender: TObject);
    procedure ChangeLangCfg(Lang: String);
    procedure FormCreate(Sender: TObject);
    procedure EnglishLangLabelClick(Sender: TObject);
    procedure PathButtonClick(Sender: TObject);
    procedure AboutButtonClick(Sender: TObject);
    procedure Button1KeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SettingsForm: TSettingsForm;

implementation

{$R *.dfm}

procedure TSettingsForm.TimerTimer(Sender: TObject);
begin
    if SettingsForm.Visible then
        Button1.SetFocus;
end;

procedure TSettingsForm.EnglishLangLabelClick(Sender: TObject);
begin
    if EnglishLangLabel.Font.Style = [] then
    begin
        EnglishLangLabel.Font.Style := [fsUnderline];
        ChangeLangCfg('ENG');
        PlaySoundUnit.Lang := 'ENG';
        SetLang(PlaySoundUnit.Lang);
        PlaySoundForm.SetLang(PlaySoundUnit.Lang);
    end;
end;

procedure TSettingsForm.FormCreate(Sender: TObject);
begin
    SetLang(PlaySoundUnit.Lang);
end;

procedure TSettingsForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
    if Key = #27 then
        SettingsForm.Close;
end;

procedure TSettingsForm.PathButtonClick(Sender: TObject);
begin
    MusicPathForm.Show;
    SettingsForm.Hide;
end;

procedure TSettingsForm.RussianLangLabelClick(Sender: TObject);
begin
    if RussianLangLabel.Font.Style = [] then
    begin
        RussianLangLabel.Font.Style := [fsUnderline];
        ChangeLangCfg('RUS');
        PlaySoundUnit.Lang := 'RUS';
        SetLang(PlaySoundUnit.Lang);
        PlaySoundForm.SetLang(PlaySoundUnit.Lang);
    end;
end;

procedure TSettingsForm.SetLang(Lang: String);
begin
    if Lang = 'RUS' then
    begin
        RussianLangLabel.Font.Style := [fsUnderline];
        EnglishLangLabel.Font.Style := [];
        Caption := 'Настройки';
        InfoLabel1.Caption := 'Путь к вашим трекам:';
        PathButton.Caption := 'Указать путь';
        AboutButton.Caption := 'О программе';
    end
    else
    begin
        RussianLangLabel.Font.Style := [];
        EnglishLangLabel.Font.Style := [fsUnderline];
        Caption := 'Settings';
        InfoLabel1.Caption := 'Path to your tracks:';
        PathButton.Caption := 'Configure path';
        AboutButton.Caption := 'About program';
    end;
end;

procedure TSettingsForm.AboutButtonClick(Sender: TObject);
begin
    AboutProgramForm.ShowModal;
end;

procedure TSettingsForm.Button1KeyPress(Sender: TObject; var Key: Char);
begin
    if Key = #27 then //Escape
        SettingsForm.Close;
end;

procedure TSettingsForm.ChangeLangCfg(Lang: String);
var
    StringArr: Array of String;
    CfgFile: TextFile;
    Counter, i: Integer;
begin
    SetLength(StringArr,16);
    Counter := 0;
    AssignFile(CfgFile, PlaySoundUnit.FileDirectory + 'settings.cfg');
    Reset(CfgFile);
    while not EOF(CfgFile) do
    begin
        Readln(CfgFile, StringArr[counter]);
        Inc(Counter);
    end;
    CloseFile(CfgFile);
    StringArr[0] := Lang;
    Rewrite(CfgFile);
    for i := 0 to Counter - 1 do
        Writeln(CfgFile, StringArr[i]);
    CloseFile(CfgFile);
end;

end.
