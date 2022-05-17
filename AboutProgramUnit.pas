unit AboutProgramUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls;

type
  TAboutProgramForm = class(TForm)
    RusTitleLabel: TLabel;
    Image4: TImage;
    EngTitleLabel: TLabel;
    ProgNameLAbel: TLabel;
    RusInfoLabel: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutProgramForm: TAboutProgramForm;

implementation

{$R *.dfm}

uses
    PlaySoundUnit;

procedure TAboutProgramForm.FormActivate(Sender: TObject);
begin
    if PlaySoundUnit.Lang = 'RUS' then
        Caption := 'О программе'
    else
        Caption := 'About program';
end;

procedure TAboutProgramForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
    if Key = #27 then
        AboutProgramForm.Close;
end;

end.
