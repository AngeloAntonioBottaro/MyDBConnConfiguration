unit MyConnectionConfiguration;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.Forms,
  Vcl.Controls,
  MyConnectionConfiguration.Ini;

type
  TMyConnectionConfiguration = class
  private
    FIniFile: TMyConnectionConfigurationIni;
    FHost: string;
    FDatabase: string;
    FPassword: string;
    FPort: string;
    FUsername: string;
    FCancel: Boolean;
    function GetSelectedSection: string;
    procedure UpdateNewIni;
  public
    constructor Create;
    destructor Destroy; override;
    function LoadConfiguration: TMyConnectionConfiguration;
    procedure ListConfigurations;
    property Host: string read FHost write FHost;
    property Database: string read FDatabase write FDatabase;
    property Password: string read FPassword write FPassword;
    property Port: string read FPort write FPort;
    property Username: string read FUsername write FUsername;
    property Cancel: Boolean read FCancel write FCancel;
  end;

implementation

uses
  MyExceptions,
  MyConnectionConfiguration.Consts,
  MyConnectionConfiguration.View.SelecionarConexao,
  MyConnectionConfiguration.View.Lista,
  MyConnectionConfiguration.View.Manutencao;

constructor TMyConnectionConfiguration.Create;
begin
   FCancel  := False;
   FIniFile := TMyConnectionConfigurationIni.Create;
   Self.UpdateNewIni;
end;

destructor TMyConnectionConfiguration.Destroy;
begin
   FIniFile.Free;
   inherited;
end;

procedure TMyConnectionConfiguration.UpdateNewIni;
begin
   if(not FIniFile.NewIni)then
     Exit;

   if(ViewManutencao = nil)then Application.CreateForm(TViewManutencao, ViewManutencao);
   try
     ViewManutencao.ShowModal;
   finally
     FreeAndNil(ViewManutencao);
   end;

   if(FIniFile.NewIni)then
     FIniFile.CreateNewConfigurationFile;
end;

function TMyConnectionConfiguration.LoadConfiguration: TMyConnectionConfiguration;
var
  LSection: string;
begin
   Result := Self;
   LSection  := Self.GetSelectedSection;
   if(FCancel)then
     Exit;

   if(LSection.IsEmpty)then
     raise ExceptionInformation.Create('Configuração de conexão não encontrada');

   try
     FHost     := FIniFile.ReadHost(LSection);
     FDatabase := FIniFile.ReadDatabasePathName(LSection);
     FPassword := FIniFile.ReadPassword(LSection);
     FPort     := FIniFile.ReadPort(LSection);
     FUsername := FIniFile.ReadUsername(LSection);
   except on E: Exception do
     raise ExceptionInformation.Create('Não foi possível acessar as informações da configuração selecionada.' + sLineBreak +
                                       'Mensagem: ' + E.Message);
   end;
end;

function TMyConnectionConfiguration.GetSelectedSection: string;
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

procedure TMyConnectionConfiguration.ListConfigurations;
begin
   if(ViewLista = nil)then Application.CreateForm(TViewLista, ViewLista);
   try
     ViewLista.ShowModal;
   finally
     FreeAndNil(ViewLista);
   end;
end;

end.
