unit AddPlaylistSongsUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons;

type
  TAddPlaylistSongsForm = class(TForm)
    PlaylistImage: TImage;
    PlaylistName: TLabel;
    SongsCountLabel: TLabel;
    CounterLabel: TLabel;
    MusicListBox: TListBox;
    AskLabel: TLabel;
    Panel: TPanel;
    AddTrackLabel: TLabel;
    AddMusicDialog: TOpenDialog;
    CloseBtn: TButton;
    DeleteTrackBtn: TBitBtn;
    AddTrackBtn: TBitBtn;
    procedure AddTrackLabelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure AddTrackLabelMouseLeave(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AddTrackLabelClick(Sender: TObject);
    procedure AddNode(Name: String);
    procedure CloseBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CloseBtnKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AddTrackBtnKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DeleteTrackBtnKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AddTrackBtnClick(Sender: TObject);
    procedure DeleteTrackBtnClick(Sender: TObject);
    procedure SetLang(Lang: String);
    procedure FormActivate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AddPlaylistSongsForm: TAddPlaylistSongsForm;

implementation

{$R *.dfm}
uses
    AddPlaylistUnit, PlaySoundUnit, ToolsUnit;

type
    TNode =^ Node;
    Node = Record
      pName: String;
      pNext: TNode;
      pPrev: TNode;
    End;
var
    Head: TNode;
    Tail: TNode;
    Size: Integer;

procedure TAddPlaylistSongsForm.AddNode(Name: String);
var
    Temp, Curr: Tnode;
begin
    New(Temp);
    Temp.pName := Name;
    if Size = 0 then
    begin
        Head := Temp;
    end
    else
        if Size = 1 then
        begin
            Head^.pNext := Temp;
            Tail := Temp;
            Tail^.pPrev := Head;
        end
        else
        begin
            Tail^.pNext := Temp;
            Temp^.pPrev := Tail;
            Tail := Temp;
        end;
    Inc(Size);
    if Size > 0 then
        Panel.Visible := False;
    CounterLabel.Caption := IntToStr(Size);
end;

procedure TAddPlaylistSongsForm.AddTrackBtnClick(Sender: TObject);
var
    Name: string;
    Counter, i: Integer;
    IsNotFound: Boolean;
begin
    if AddMusicDialog.Execute then
    begin
        Name := Tools.TakeName(AddMusicDialog.FileName);
        Delete(Name, Length(Name) - 3, 4);
        i := 0;
        IsNotFound := True;
        While (IsNotFound and (i < MusicListBox.Count)) do
        begin
            if MusicListBox.Items[i] = Name  then
                IsNotFound := False;
            inc(i);
        end;
        if IsNotFound then
        begin
            AddNode(AddMusicDialog.FileName);
            MusicListBox.Items.Add(Name);
        end
        else
        if PlaySoundUnit.Lang = 'RUS' then
            MessageBox(Handle, PChar('Трек уже добавлен'), PChar('Ошибка'), MB_OK + MB_ICONERROR)
        else
            MessageBox(Handle, PChar('Track has been already added'), PChar('Error'), MB_OK + MB_ICONERROR);

    end;
end;

procedure TAddPlaylistSongsForm.AddTrackBtnKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
    if Key = Vk_Return then
        CloseBtn.Click;
end;

procedure TAddPlaylistSongsForm.AddTrackLabelClick(Sender: TObject);
begin
    AddTrackBtn.Click;
end;

procedure TAddPlaylistSongsForm.AddTrackLabelMouseLeave(Sender: TObject);
begin
    AddTrackLabel.Font.Color := clWindowText;
end;

procedure TAddPlaylistSongsForm.AddTrackLabelMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
    AddTrackLabel.Font.Color := clRed;
end;



procedure TAddPlaylistSongsForm.CloseBtnClick(Sender: TObject);
var
    I: Integer;
    NewPlaylistPath: string;
    Prev, Temp: TNode;
begin
    NewPlaylistPath := FileDirectory + 'Playlists\' + PlaylistName.Caption;
    CreateDir(NewPlaylistPath);
    if Length(AddPlaylistForm.ImagePathLabel.Caption) <> 0 then
    begin
        CopyFile(PChar(AddPlaylistForm.ImagePathLabel.Caption), PChar(NewPlaylistPath + '\image' + Copy(AddPlaylistForm.ImagePathLabel.Caption, Length(AddPlaylistForm.ImagePathLabel.Caption) - 3, 4)), True);
    end;
    if Size <> 0 then
    begin
        Temp := Head;
        for i := 1 to Size - 1 do
        begin
            CopyFile(PChar(Temp.pName), PChar(NewPlaylistPath + '\' + Tools.TakeName(Temp.pName)), True);
            Prev := Temp;
            Temp := Temp.pNext;
            Temp.pPrev := nil;
            Dispose(Prev);
        end;
        CopyFile(PChar(Temp.pName), PChar(NewPlaylistPath + '\' + Tools.TakeName(Temp.pName)), True);
        Dispose(Temp);
    end;
    Size := 0;
    CounterLabel.Caption := IntToStr(Size);
    PlaySoundForm.LoadPlaylists;
    Panel.Visible := True;
    AddPlaylistForm.Close;
    AddPlaylistSongsForm.Close;
end;

procedure TAddPlaylistSongsForm.CloseBtnKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key = Vk_Return then
        CloseBtn.Click;
end;

procedure TAddPlaylistSongsForm.DeleteTrackBtnKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
    if Key = Vk_Return then
        CloseBtn.Click;
end;

procedure TAddPlaylistSongsForm.DeleteTrackBtnClick(Sender: TObject);
var
    isDeleted: Boolean;
    Index, Counter, i: Integer;
    DeletedNode, Temp, List: TNode;
begin
    if MusicListBox.ItemIndex <> -1 then
    begin
        isDeleted := False;
        Index := MusicListBox.ItemIndex + 1;
        if (Index = 1) then
        begin
            if Size <> 1 then
            begin
                DeletedNode := Head;
                Head := Head^.pNext;
                Head^.pPrev := nil;
            end
            else
                DeletedNode := Head;
            IsDeleted := True;
        end
        else
            if (Index = Size) then
            begin
                DeletedNode := Tail;
                Tail := Tail^.pPrev;
                Tail^.pNext := nil;
                IsDeleted := True;
            end;
        if (not IsDeleted) then
        begin
            if (Index <= Size - Index) then
            begin
                temp := head;
                counter := 1;
                while (counter <> Index) do
                begin
                    Temp := Temp^.pNext;
                    Inc(Counter);
                end;
            end
            else
            begin
                Temp := Tail;
                Counter := Size;
                while (Counter <> Index) do
                begin
                    Temp := Temp^.pPrev;
                    Dec(Counter);
                end;
            end;
            DeletedNode := Temp;
            Temp^.pPrev^.pNext := Temp^.pNext;
            Temp^.pNext^.pPrev := Temp^.pPrev;
        end;
        Dispose(DeletedNode);
        Dec(Size);
        MusicListBox.DeleteSelected;
        if Size = 0 then
            Panel.Visible := True;
        CounterLabel.Caption := IntToStr(Size);
    end
    else
        if PlaySoundUnit.Lang = 'RUS' then
            MessageBox(Handle, PChar('Трек для удаления не выбран'), PChar('Ошибка'), MB_OK + MB_ICONERROR)
        else
            MessageBox(Handle, PChar('Track to delete isn''t selected'), PChar('Error'), MB_OK + MB_ICONERROR)
end;

procedure TAddPlaylistSongsForm.FormActivate(Sender: TObject);
begin
    SetLang(PlaySoundUnit.Lang);
end;

procedure TAddPlaylistSongsForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    CloseBtn.Click;
end;

procedure TAddPlaylistSongsForm.FormCreate(Sender: TObject);
begin
    Size := 0;
    CounterLabel.Caption := IntToStr(Size);
    SetLang(PlaySoundUnit.Lang);
end;

procedure TAddPlaylistSongsForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key = Vk_Return then
        CloseBtn.Click;
end;

procedure TAddPlaylistSongsForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
    if Key = #13 then
        CloseBtn.Click;

    if Key = #27 then
        AddPlaylistSongsForm.Close;
end;

procedure TAddPlaylistSongsForm.SetLang(Lang: String);
begin
    if Lang = 'RUS' then
    begin
        Caption := 'Добавление треков';
        SongsCountLabel.Caption := 'Треков:';
        AskLabel.Caption := 'Что за плейлист без треков?';
        AskLabel.Left := 69;
        AddTrackLabel.Caption := 'Добавить трек';
        AddTrackLabel.Left := 133;
        AddTrackBtn.Hint := PlaySoundForm.AddTrackBtn.Hint;
        DeleteTrackBtn.Hint := PlaySoundForm.DeleteTrackBtn.Hint;
        CloseBtn.Caption := 'Закончить';
    end
    else
    begin
        Caption := 'Tracks adding';
        SongsCountLabel.Caption := 'Tracks:';
        AskLabel.Caption := 'What is a playlist without tracks?';
        AskLabel.Left := 45;
        AddTrackLabel.Caption := 'Add track';
        AddTrackLabel.Left := 149;
        AddTrackBtn.Hint := PlaySoundForm.AddTrackBtn.Hint;
        DeleteTrackBtn.Hint := PlaySoundForm.DeleteTrackBtn.Hint;
        CloseBtn.Caption := 'Finish';
    end;
end;

end.
