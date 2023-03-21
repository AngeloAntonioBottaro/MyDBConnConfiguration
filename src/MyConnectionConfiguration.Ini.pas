unit MyConnectionConfiguration.Ini;

interface

uses
  System.SysUtils,
  System.Classes,
  Utils.MyIniLibrary;

type
  TMyConnectionConfigurationIni = class
  private
    FIniFile: IMyIniLibrary;
    FStrings: TStrings;
    function IniPath: string;
  public
    constructor Create;
    destructor Destroy; override;
    function GetIniInstance: IMyIniLibrary;
    function IniFilePathName: string;
    procedure CreateNewConfigurationFile;
    procedure CreateNewItem(AName, AHost, ADatabase, APassword, APort: String);
    procedure SaveItem(ASection, AName, AHost, ADatabase, APassword, APort: String);

    function ReadName(ASection: String): string;
    function ReadHost(ASection: String): string;
    function ReadDatabase(ASection: String): string;
    function ReadDatabasePathName(ASection: string): string;
    function ReadPassword(ASection: String): string;
    function ReadPort(ASection: String): string;
    procedure ReadSections;
    function GetSections: TStrings;
  end;

implementation

uses
  Utils.MyLibrary,
  Utils.Myconsts,
  Utils.MyVCLLibrary,
  MyConnectionConfiguration.Consts;

constructor TMyConnectionConfigurationIni.Create;
begin
   if(not FileExists(Self.IniFilePathName))then
     Self.CreateNewConfigurationFile;

   FIniFile := TMyIniLibrary.New;
   FIniFile
    .Path(Self.IniPath)
    .Name(INI_NAME);
end;

function TMyConnectionConfigurationIni.GetIniInstance: IMyIniLibrary;
begin
   Result := FIniFile;
end;

function TMyConnectionConfigurationIni.IniFilePathName: string;
begin
   Result := IncludeTrailingPathDelimiter(Self.IniPath) + INI_NAME;
end;

function TMyConnectionConfigurationIni.IniPath: string;
begin
   Result := TMyVclLibrary.GetAppPath;
end;

function TMyConnectionConfigurationIni.ReadName(ASection: String): string;
begin
   Result := FIniFile.Section(ASection).Identifier(IDENTIFIER_NAME).ReadIniFileStr(DEFAULT_NAME);
end;

function TMyConnectionConfigurationIni.ReadHost(ASection: String): string;
begin
   Result := FIniFile.Section(ASection).Identifier(IDENTIFIER_HOST).ReadIniFileStr(DEFAULT_HOST);
end;

function TMyConnectionConfigurationIni.ReadDatabase(ASection: String): string;
begin
   Result := FIniFile.Section(ASection).Identifier(IDENTIFIER_DATABASE).ReadIniFileStr(DEFAULT_DATABASE);
end;

function TMyConnectionConfigurationIni.ReadDatabasePathName(ASection: string): string;
begin
   Result := Self.IniPath + FOULDER_DATABASE + Self.ReadDatabase(ASection);
end;

function TMyConnectionConfigurationIni.ReadPassword(ASection: String): string;
begin
   Result := FIniFile.Section(ASection).Identifier(IDENTIFIER_PASSWORD).ReadIniFileStr(DEFAULT_PASSWORD);

   if(Result.Equals(DEFAULT_PASSWORD))then
     Exit;

   Result := TMyLibrary.Decrypt(Result);
end;

function TMyConnectionConfigurationIni.ReadPort(ASection: String): string;
begin
   Result := FIniFile.Section(ASection).Identifier(IDENTIFIER_PORT).ReadIniFileStr(DEFAULT_PORT);
end;

procedure TMyConnectionConfigurationIni.ReadSections;
begin
   if(Assigned(FStrings))then
     FStrings.Free;

   FStrings := TStringList.Create;
   FIniFile.ReadSections(FStrings);
end;

function TMyConnectionConfigurationIni.GetSections: TStrings;
begin
   if(not Assigned(FStrings))then
     Self.ReadSections;

   Result := FStrings;
end;

procedure TMyConnectionConfigurationIni.CreateNewConfigurationFile;
begin
   Self.CreateNewItem(DEFAULT_NAME, DEFAULT_HOST, DEFAULT_DATABASE, DEFAULT_PASSWORD, DEFAULT_PORT);
end;

procedure TMyConnectionConfigurationIni.CreateNewItem(AName, AHost, ADatabase, APassword, APort: String);
begin
   Self.SaveItem(EmptyStr, AName, AHost, ADatabase, APassword, APort);
end;

destructor TMyConnectionConfigurationIni.Destroy;
begin
   if(Assigned(FStrings))then
     FStrings.Free;
   inherited;
end;

procedure TMyConnectionConfigurationIni.SaveItem(ASection, AName, AHost, ADatabase, APassword, APort: String);
begin
   FIniFile
    .Section(ASection)
    .Identifier(IDENTIFIER_NAME).WriteIniFile(AName)
    .Identifier(IDENTIFIER_HOST).WriteIniFile(AHost)
    .Identifier(IDENTIFIER_DATABASE).WriteIniFile(ADatabase)
    .Identifier(IDENTIFIER_PASSWORD).WriteIniFile(TMyLibrary.Encrypt(APassword))
    .Identifier(IDENTIFIER_PORT).WriteIniFile(APort);
end;

end.
