unit MyDBConnConfiguration.Ini;

interface

uses
  System.SysUtils,
  System.Classes,
  Common.Utils.MyIniLibrary;

type
  TMyDBConnConfigurationIni = class
  private
    FIniFile: IMyIniLibrary;
    FStrings: TStrings;
  public
    constructor Create;
    destructor Destroy; override;
    class function IniPath: string;

    function NewIni: Boolean;
    function GetIniInstance: IMyIniLibrary;
    function IniFilePathName: string;
    procedure CreateNewConfigurationFile;
    procedure CreateNewItem(AName, AHost, ADatabase, APassword, APort, AUsername: String);
    procedure SaveItem(ASection, AName, AHost, ADatabase, APassword, APort, AUsername: String);

    function ReadName(ASection: String): string;
    function ReadHost(ASection: String): string;
    function ReadDBPath(ASection: String): string;
    function ReadDatabase(ASection: String): string;
    function ReadPassword(ASection: String): string;
    function ReadPort(ASection: String): string;
    function ReadUsername(ASection: String): string;
    procedure ReadSections;
    function GetSections: TStrings;
  end;

implementation

uses
  Common.Utils.MyLibrary,
  Common.Utils.Myconsts,
  Common.Utils.MyVCLLibrary,
  MyDBConnConfiguration.Consts;

constructor TMyDBConnConfigurationIni.Create;
begin
   FIniFile := TMyIniLibrary.New;
   FIniFile
    .Path(Self.IniPath)
    .Name(INI_NAME);
end;

destructor TMyDBConnConfigurationIni.Destroy;
begin
   if(Assigned(FStrings))then
     FStrings.Free;
   inherited;
end;

function TMyDBConnConfigurationIni.GetIniInstance: IMyIniLibrary;
begin
   Result := FIniFile;
end;

function TMyDBConnConfigurationIni.IniFilePathName: string;
begin
   Result := IncludeTrailingPathDelimiter(Self.IniPath) + INI_NAME;
end;

class function TMyDBConnConfigurationIni.IniPath: string;
begin
   Result := IncludeTrailingPathDelimiter(TMyLibrary.GetPathAppDataLocal) + TMyVclLibrary.GetAppName;

   if(not DirectoryExists(Result))then
     ForceDirectories(Result);
end;

function TMyDBConnConfigurationIni.NewIni: Boolean;
begin
   Result := (not FileExists(Self.IniFilePathName));
end;

function TMyDBConnConfigurationIni.ReadName(ASection: String): string;
begin
   Result := FIniFile.Section(ASection).Identifier(IDENTIFIER_NAME).ReadIniFileStr(DEFAULT_NAME);
end;

function TMyDBConnConfigurationIni.ReadHost(ASection: String): string;
begin
   Result := FIniFile.Section(ASection).Identifier(IDENTIFIER_HOST).ReadIniFileStr(DEFAULT_HOST);
   if(UpperCase(Result) = UpperCase(DEFAULT_HOST))then
     Result := '127.0.0.1';
end;

function TMyDBConnConfigurationIni.ReadDatabase(ASection: String): string;
begin
   Result := FIniFile.Section(ASection).Identifier(IDENTIFIER_DATABASE).ReadIniFileStr(DEFAULT_DATABASE);
end;

function TMyDBConnConfigurationIni.ReadDBPath(ASection: String): string;
var
  LDefault: string;
begin
   LDefault := IncludeTrailingPathDelimiter(TMyVclLibrary.GetAppPath) + 'DATABASE\';
   Result := FIniFile.Section(ASection).Identifier(IDENTIFIER_DB_PATH).ReadIniFileStr(LDefault);

   if(Result.Trim.IsEmpty)then
     Result := LDefault;
end;

function TMyDBConnConfigurationIni.ReadPassword(ASection: String): string;
begin
   Result := FIniFile.Section(ASection).Identifier(IDENTIFIER_PASSWORD).ReadIniFileStr(DEFAULT_PASSWORD);

   if(Result.Equals(DEFAULT_PASSWORD))then
     Exit;

   Result := TMyLibrary.Decrypt(Result);
end;

function TMyDBConnConfigurationIni.ReadPort(ASection: String): string;
begin
   Result := FIniFile.Section(ASection).Identifier(IDENTIFIER_PORT).ReadIniFileStr(DEFAULT_PORT);
end;

function TMyDBConnConfigurationIni.ReadUsername(ASection: String): string;
begin
   Result := FIniFile.Section(ASection).Identifier(IDENTIFIER_USERNAME).ReadIniFileStr(DEFAULT_USERNAME);
end;

procedure TMyDBConnConfigurationIni.ReadSections;
begin
   if(Assigned(FStrings))then
     FStrings.Free;

   FStrings := TStringList.Create;
   FIniFile.ReadSections(FStrings);
end;

function TMyDBConnConfigurationIni.GetSections: TStrings;
begin
   if(not Assigned(FStrings))then
     Self.ReadSections;

   Result := FStrings;
end;

procedure TMyDBConnConfigurationIni.CreateNewConfigurationFile;
begin
   Self.CreateNewItem(DEFAULT_NAME, DEFAULT_HOST, DEFAULT_DATABASE, DEFAULT_PASSWORD, DEFAULT_PORT, DEFAULT_USERNAME);
end;

procedure TMyDBConnConfigurationIni.CreateNewItem(AName, AHost, ADatabase, APassword, APort, AUsername: String);
begin
   Self.SaveItem(EmptyStr, AName, AHost, ADatabase, APassword, APort, AUsername);
end;

procedure TMyDBConnConfigurationIni.SaveItem(ASection, AName, AHost, ADatabase, APassword, APort, AUsername: String);
begin
   FIniFile
    .Section(ASection)
    .Identifier(IDENTIFIER_NAME).WriteIniFile(AName)
    .Identifier(IDENTIFIER_HOST).WriteIniFile(AHost)
    .Identifier(IDENTIFIER_DB_PATH).WriteIniFile(ExtractFilePath(ADatabase))
    .Identifier(IDENTIFIER_DATABASE).WriteIniFile(ExtractFileName(ADatabase))
    .Identifier(IDENTIFIER_PASSWORD).WriteIniFile(TMyLibrary.Encrypt(APassword))
    .Identifier(IDENTIFIER_PORT).WriteIniFile(APort)
    .Identifier(IDENTIFIER_USERNAME).WriteIniFile(AUsername);
end;

end.
