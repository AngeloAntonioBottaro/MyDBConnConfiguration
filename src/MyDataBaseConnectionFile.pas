unit MyDataBaseConnectionFile;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.Forms,
  Vcl.Controls,
  MyDatabaseConnectionFile.Ini;

type
  TMyDataBaseConnectionFile = class
  private
    FIniFile: TMyDatabaseConnectionFileIni;
    FHost: string;
    FDatabase: string;
    FPassword: string;
    FPort: STRING;
    FCancel: Boolean;
    procedure GetConfigurationFile;
    procedure LoadConfigurationFile;
    function GetSelectedSection: string;
  public
    constructor Create;
    destructor Destroy; override;
    property Host: string read FHost write FHost;
    property Database: string read FDatabase write FDatabase;
    property Password: string read FPassword write FPassword;
    property Port: STRING read FPort write FPort;
    property Cancel: Boolean read FCancel write FCancel;
  end;

implementation

uses
  MyExceptions,
  MyDataBaseConnectionFile.View.SelecionarConexao,
  MyDatabaseConnectionFile.Consts;

constructor TMyDataBaseConnectionFile.Create;
begin
   FCancel  := False;
   FIniFile := TMyDatabaseConnectionFileIni.Create;
   Self.GetConfigurationFile;
end;

destructor TMyDataBaseConnectionFile.Destroy;
begin
   FIniFile.Free;
   inherited;
end;

procedure TMyDataBaseConnectionFile.GetConfigurationFile;
begin
   if(not FileExists(FIniFile.IniFilePathName))then
     FIniFile.CreateNewConfigurationFile;

   Self.LoadConfigurationFile;
end;

procedure TMyDataBaseConnectionFile.LoadConfigurationFile;
var
  LSection: string;
begin
   LSection  := Self.GetSelectedSection;
   if(LSection.IsEmpty)and(FCancel)then
     Exit;

   if(LSection.IsEmpty)then
     raise ExceptionInformation.Create('Não foi possível acessar as informações da configuração selecionada');

   FHost     := FIniFile.ReadHost(LSection);
   FDatabase := FIniFile.ReadDatabasePathName(LSection);
   FPassword := FIniFile.ReadPassword(LSection);
   FPort     := FIniFile.ReadPort(LSection);
end;

function TMyDataBaseConnectionFile.GetSelectedSection: string;
begin
   Result := EmptyStr;

   FIniFile.ReadSections;
   if(FIniFile.GetSections.Count = 1)then
     Exit(FIniFile.GetSections[0]);

   if(ViewSelecionarConexao = nil)then Application.CreateForm(TViewSelecionarConexao, ViewSelecionarConexao);
   try
     if(ViewSelecionarConexao.ShowModal = mrOk)then
       Result := ViewSelecionarConexao.SelectedSection
     else
       FCancel := True;
   finally
     FreeAndNil(ViewSelecionarConexao);
   end;
end;

end.
