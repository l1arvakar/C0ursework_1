unit MusicPathsUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.FileCtrl;

type
  TMusicPathForm = class(TForm)
    TitleLabel: TLabel;
    InfoLabel: TLabel;
    ListBox: TListBox;
    InstructLabel: TLabel;
    DeletePathBtn: TBitBtn;
    AddPathBtn: TBitBtn;
    Timer1: TTimer;
    procedure FormActivate(Sender: TObject);
    procedure SetLang(Lang: String);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AddPathBtnClick(Sender: TObject);
    procedure DeletePathBtnClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MusicPathForm: TMusicPathForm;

implementation

uses
    PlaySoundUnit, SettingsUnit;

{$R *.dfm}

procedure TMusicPathForm.AddPathBtnClick(Sender: TObject);
var
    Directory, str: String;
    StringArr: Array of String;
    CfgFile: TextFile;
    Counter, i: Integer;
begin
    if Lang = 'RUS' then
        Str := 'Выберите папку c музыкой'
    else
        Str := 'Select folder';
    if SelectDirectory('',Str, Directory) then
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
        StringArr[Counter] := Directory;
        Rewrite(CfgFile);
        for i := 0 to Counter do
            Writeln(CfgFile, StringArr[i]);
        CloseFile(CfgFile);
        ListBox.AddItem(Directory,ListBox);
        if ListBox.Count >= 15 then
            AddPathBtn.Enabled := False;
    end;
end;

procedure TMusicPathForm.DeletePathBtnClick(Sender: TObject);
var
    lpCaption, lpText: String;
    StringArr: Array of String;
    CfgFile: TextFile;
    Counter, i: Integer;
begin
    if ListBox.ItemIndex <> -1 then
    begin
        if Lang = 'RUS' then
        begin
            lpCaption := 'Удаление';
            lpText := PChar('Вы действительно хотите удалить путь'#13#10 + ListBox.Items[ListBox.ItemIndex] +'?');
        end
        else
        begin
            lpCaption := 'Deleting';
            lpText := PChar('Are you shure for deleting path'#13#10 + ListBox.Items[ListBox.ItemIndex] +'?');
        end;
        if MessageBox(Handle, PChar(lpText), PChar(lpCaption), MB_YESNO + MB_ICONQUESTION) = IDYES then
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
            for i := ListBox.ItemIndex + 1 to Counter - 2 do
                StringArr[i] := StringArr[i + 1];
            Dec(Counter);
            Rewrite(CfgFile);
            for i := 0 to Counter - 1 do
                Writeln(CfgFile, StringArr[i]);
            CloseFile(CfgFile);
            ListBox.DeleteSelected;
            if ListBox.Count < 15 then
                AddPathBtn.Enabled := True;
        end;
    end
    else
    begin
        if Lang = 'RUS' then
            MessageBox(Handle, PChar('Выберите путь'), PChar('Ошибка'), MB_OK + MB_ICONERROR)
        else
            MessageBox(Handle, PChar('Select a path'), PChar('Error'), MB_OK + MB_ICONERROR)
    end;
end;

procedure TMusicPathForm.FormActivate(Sender: TObject);
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
    ListBox.Clear;
    for i := 1 to Counter - 1 do
        ListBox.AddItem(StringArr[i],ListBox);
    SetLang(PlaySoundUnit.Lang);
    ListBox.ItemIndex := -1;
end;

procedure TMusicPathForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    SettingsForm.Show;
end;

procedure TMusicPathForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
    if Key = #27 then
        MusicPathForm.Close;
end;

procedure TMusicPathForm.SetLang(Lang: String);
begin
    if Lang = 'RUS' then
    begin
        Caption := 'Пути к трекам';
        TitleLabel.Caption := 'Выберите пути к своей музыке';
        InstructLabel.Caption := 'Выберите пути к вашим трекам (не более 15)';
        InfoLabel.Caption := 'Мы ищем в этих папках:';
        AddPathBtn.Hint := 'Добавить путь';
        DeletePathBtn.Hint := 'Удалить путь';
    end
    else
    begin
        Caption := 'Music Paths';
        TitleLabel.Caption := 'Select parths to your music';
        InstructLabel.Caption := 'Select file paths (no more than 15)';
        InfoLabel.Caption := 'We''re looking this folders:';
        AddPathBtn.Hint := 'Add path';
        DeletePathBtn.Hint := 'Delete path';
    end;
end;

procedure TMusicPathForm.Timer1Timer(Sender: TObject);
begin
    if MusicPathForm.Visible then
        ListBox.SetFocus;
end;

end.
