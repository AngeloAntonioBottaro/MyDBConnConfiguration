unit MyDBConnConfiguration;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.Forms,
  Vcl.Controls,
  MyDBConnConfiguration.Ini;

type
  TMyDBConnConfiguration = class
  private
    FIniFile: TMyDBConnConfigurationIni;
    FHost: string;
    FDBPath: string;
    FDatabase: string;
    FPassword: string;
    FPort: string;
    FUsername: string;
    FCancel: Boolean;
    function GetSelectedSection: string;
    procedure UpdateNewIni;
    function GetDatabase: string;
  public
    constructor Create;
    destructor Destroy; override;
    function LoadConfiguration: TMyDBConnConfiguration;
    procedure ListConfigurations;
    property Host: string read FHost write FHost;
    property Database: string read GetDatabase write FDatabase;
    property Password: string read FPassword write FPassword;
    property Port: string read FPort write FPort;
    property Username: string read FUsername write FUsername;
    property Cancel: Boolean read FCancel write FCancel;
  end;

implementation

uses
  MyExceptions,
  MyDBConnConfiguration.Consts,
  MyDBConnConfiguration.View.SelecionarConexao,
  MyDBConnConfiguration.View.Lista,
  MyDBConnConfiguration.View.Manutencao;

constructor TMyDBConnConfiguration.Create;
begin
   FCancel  := False;
   FIniFile := TMyDBConnConfigurationIni.Create;
   Self.UpdateNewIni;
end;

destructor TMyDBConnConfiguration.Destroy;
begin
   FIniFile.Free;
   inherited;
end;

procedure TMyDBConnConfiguration.UpdateNewIni;
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

function TMyDBConnConfiguration.LoadConfiguration: TMyDBConnConfiguration;
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
     FDBPath   := FIniFile.ReadDBPath(LSection);
     FDatabase := FIniFile.ReadDatabase(LSection);
     FPassword := FIniFile.ReadPassword(LSection);
     FPort     := FIniFile.ReadPort(LSection);
     FUsername := FIniFile.ReadUsername(LSection);
   except on E: Exception do
     raise ExceptionInformation.Create('Não foi possível acessar as informações da configuração selecionada.' + sLineBreak +
                                       'Mensagem: ' + E.Message);
   end;
end;

function TMyDBConnConfiguration.GetDatabase: string;
begin
   Result := FDBPath + FDatabase;
end;

function TMyDBConnConfiguration.GetSelectedSection: string;
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

procedure TMyDBConnConfiguration.ListConfigurations;
begin
   if(ViewLista = nil)then Application.CreateForm(TViewLista, ViewLista);
   try
     ViewLista.ShowModal;
   finally
     FreeAndNil(ViewLista);
   end;
end;

end.
