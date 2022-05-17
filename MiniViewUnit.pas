unit MiniViewUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, PlaySoundUnit,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls, Vcl.Imaging.pngimage;

type
  TMiniViewForm = class(TForm)
    Timer: TTimer;
    TrackName: TLabel;
    PrevTrackBtn: TBitBtn;
    StopBtn: TBitBtn;
    NextTrackBtn: TBitBtn;
    PlayBtn: TBitBtn;
    TrackBar: TTrackBar;
    Button1: TButton;
    PlaylistNameLabel: TLabel;
    MiniViewBtn: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TimerTimer(Sender: TObject);
    procedure PlayBtnClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure NextTrackBtnClick(Sender: TObject);
    procedure PrevTrackBtnClick(Sender: TObject);
    procedure MiniViewBtnClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure SetLang(Lang: String);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MiniViewForm: TMiniViewForm;

implementation

{$R *.dfm}



procedure TMiniViewForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    PlaySoundForm.Position := poDesktopCenter;
end;

procedure TMiniViewForm.FormCreate(Sender: TObject);
begin
    Top:=Screen.WorkAreaRect.Top + 150;
    Left:=Screen.WorkAreaRect.Right - Width;
    SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0,
    SWP_NOACTIVATE + SWP_NOMOVE + SWP_NOSIZE);
    SetLang(PlaySoundUnit.Lang);
end;

procedure TMiniViewForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
    if (Key = #32) and PlaySoundUnit.IsActivate then
        if IsPlaying then
            PlaySoundForm.PauseTrack()
        else
            PlaySoundForm.PlayTrack();
    if Key = #27 then
        MiniViewForm.Close;
end;

procedure TMiniViewForm.MiniViewBtnClick(Sender: TObject);
begin
    MiniViewForm.Close;
end;

procedure TMiniViewForm.NextTrackBtnClick(Sender: TObject);
begin
    PlaySoundForm.NextTrackBtn.Click;
end;

procedure TMiniViewForm.PlayBtnClick(Sender: TObject);
begin
    PlaySoundForm.PlayBtn.Click;
end;

procedure TMiniViewForm.PrevTrackBtnClick(Sender: TObject);
begin
    PlaySoundForm.PrevTrackBtn.Click;
end;

procedure TMiniViewForm.StopBtnClick(Sender: TObject);
begin
    PlaySoundForm.StopBtn.Click;
end;

procedure TMiniViewForm.TimerTimer(Sender: TObject);
begin
    if MiniViewForm.Visible then
    begin
        SetWindowPos(Handle,HWND_TOPMOST,Left,Top,Width,Height,SWP_NOACTIVATE Or   SWP_NOMOVE Or SWP_NOSIZE);
        PlayBtn.Visible := PlaySoundForm.PlayBtn.Visible;
        StopBtn.Visible := PlaySoundForm.StopBtn.Visible;
        TrackName.Caption := PlaySoundForm.TrackNameLabel.Caption;
        PlaylistNameLabel.Caption := PlaySoundForm.PlaylistNameLabel.Caption;
        TrackBar.Position := PlaySoundForm.TrackBar.Position * TrackBar.Max div PlaySoundForm.TrackBar.Max;
        Button1.SetFocus;
    end;
end;

procedure TMiniViewForm.SetLang(Lang: String);
begin
    if Lang = 'RUS' then
    begin
        MiniViewBtn.Hint := 'Выйти из мини окна';
        PrevTrackBtn.Hint := PlaySoundForm.PrevTrackBtn.Hint;
        StopBtn.Hint := PlaySoundForm.StopBtn.Hint;
        PlayBtn.Hint := PlaySoundForm.PlayBtn.Hint;
        NextTrackBtn.Hint := PlaySoundForm.NextTrackBtn.Hint;
    end
    else
    begin
        MiniViewBtn.Hint := 'Leave mini view';
        PrevTrackBtn.Hint := PlaySoundForm.PrevTrackBtn.Hint;
        StopBtn.Hint := PlaySoundForm.StopBtn.Hint;
        PlayBtn.Hint := PlaySoundForm.PlayBtn.Hint;
        NextTrackBtn.Hint := PlaySoundForm.NextTrackBtn.Hint;
    end;
end;

end.
