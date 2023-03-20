unit View.Main;

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
  Vcl.Dialogs,
  Vcl.StdCtrls;

type
  TViewMain = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
  public
  end;

var
  ViewMain: TViewMain;

implementation

{$R *.dfm}

uses
  MyDatabaseConnectionFile;

procedure TViewMain.Button1Click(Sender: TObject);
var
  TDCF: TMyDataBaseConnectionFile;
begin
   TDCF := TMyDataBaseConnectionFile.Create;
   try
     ShowMessage('Host: ' + TDCF.Host + sLineBreak +
                 'Password: ' + TDCF.Password + sLineBreak +
                 'Database: ' + TDCF.Database + sLineBreak +
                 'Port: ' + TDCF.Port);
   finally
     TDCF.Free;
   end;
end;

end.
