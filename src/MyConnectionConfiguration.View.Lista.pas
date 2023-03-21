unit MyConnectionConfiguration.View.Lista;

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
  TViewLista = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
  public
  end;

var
  ViewLista: TViewLista;

implementation

{$R *.dfm}

uses
  Utils.MyFormLibrary;

procedure TViewLista.FormCreate(Sender: TObject);
begin
   TMyFormLibrary.New.ConfForm(Self);
end;

end.
