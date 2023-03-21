unit MyConnectionConfiguration.View.Manutencao;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs;

type
  TViewManutencao = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
  public
  end;

var
  ViewManutencao: TViewManutencao;

implementation

{$R *.dfm}

uses
  Utils.MyFormLibrary;

procedure TViewManutencao.FormCreate(Sender: TObject);
begin
   TMyFormLibrary.New.ConfForm(Self);
end;

end.
