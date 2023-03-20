unit MyDataBaseConnectionFile;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.Forms,
  Vcl.Controls,
  Utils.MyIniLibrary;

type
  TMyDataBaseConnectionFile = class
  private
    FIniFile: IMyIniLibrary;
    FHost: string;
    FDatabase: string;
    FPassword: string;
    FPort: STRING;
    FCancel: Boolean;
    function IniPath: string;
    procedure GetConfigurationFile;
    procedure CreateNewConfigurationFile;
    procedure LoadConfigurationFile;

    function Default_Password: string;
    function IniFilePathName: string;
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
  Utils.MyLibrary,
  Utils.Myconsts,
  Utils.MyVCLLibrary,
  MyDataBaseConnectionFile.View.SelecionarConexao,
  MyDatabaseConnectionFile.Consts;

constructor TMyDataBaseConnectionFile.Create;
begin
   FCancel := False;
   Self.GetConfigurationFile;
end;

destructor TMyDataBaseConnectionFile.Destroy;
begin
   //
   inherited;
end;

function TMyDataBaseConnectionFile.IniPath: string;
begin
   Result := TMyVclLibrary.GetAppPath;
end;

function TMyDataBaseConnectionFile.IniFilePathName: string;
begin
   Result := IncludeTrailingPathDelimiter(Self.IniPath) + INI_NAME;
end;

function TMyDataBaseConnectionFile.Default_Password: string;
begin
   Result := TMyLibrary.Encrypt(CURRENT_PASSWORD);
end;

procedure TMyDataBaseConnectionFile.GetConfigurationFile;
begin
   if(not FileExists(Self.IniFilePathName))then
     Self.CreateNewConfigurationFile;

   Self.LoadConfigurationFile;
end;

function TMyDataBaseConnectionFile.GetSelectedSection: string;
var
  LSections: TStrings;
begin
   Result := EmptyStr;
   LSections := TStringList.Create;
   try
     FIniFile.ReadSections(LSections);

     if(ViewSelecionarConexao = nil)then Application.CreateForm(TViewSelecionarConexao, ViewSelecionarConexao);
     try
       ViewSelecionarConexao.Sections := LSections;
       ViewSelecionarConexao.IniFile  := FIniFile;
       if(ViewSelecionarConexao.ShowModal = mrOk)then
         Result := ViewSelecionarConexao.SelectedSection
       else
         FCancel := True;
     finally
       FreeAndNil(ViewSelecionarConexao);
     end;
   finally
     LSections.Free;
   end;
end;

procedure TMyDataBaseConnectionFile.CreateNewConfigurationFile;
begin
   MyIniLibrary
    .Path(Self.IniPath)
    .Name(INI_NAME)
    .Identifier(IDENTIFIER_HOST).WriteIniFile(DEFAULT_HOST)
    .Identifier(IDENTIFIER_DATABASE).WriteIniFile(DEFAULT_DATABASE)
    .Identifier(IDENTIFIER_PASSWORD).WriteIniFile(Default_Password)
    .Identifier(IDENTIFIER_PORT).WriteIniFile(DEFAULT_PORT);
end;

procedure TMyDataBaseConnectionFile.LoadConfigurationFile;
var
  LSection: string;
begin
   FIniFile := TMyIniLibrary.New;
   FIniFile
    .Path(Self.IniPath)
    .Name(INI_NAME);

   LSection  := Self.GetSelectedSection;
   if(LSection.IsEmpty)and(FCancel)then
     Exit;

   if(LSection.IsEmpty)then
     raise ExceptionInformation.Create('Não foi possível acessar as informações da configuração selecionada');

   FIniFile.Section(LSection);

   FHost     := FIniFile.Identifier(IDENTIFIER_HOST).ReadIniFileStr(DEFAULT_HOST);
   FDatabase := Self.IniPath + FOULDER_DATABASE + FIniFile.Identifier(IDENTIFIER_DATABASE).ReadIniFileStr(DEFAULT_DATABASE);
   FPassword := FIniFile.Identifier(IDENTIFIER_PASSWORD).ReadIniFileStr(Default_Password);
   FPassword := TMyLibrary.Decrypt(FPassword);
   FPort     := FIniFile.Identifier(IDENTIFIER_PORT).ReadIniFileStr(DEFAULT_PORT);
end;

end.
