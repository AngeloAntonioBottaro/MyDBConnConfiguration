unit MyDatabaseConnectionFile.Ini;

interface

uses
  System.SysUtils,
  System.Classes,
  Utils.MyIniLibrary;

type
  TMyDatabaseConnectionFileIni = class
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
  MyDatabaseConnectionFile.Consts;

constructor TMyDatabaseConnectionFileIni.Create;
begin
   FIniFile := TMyIniLibrary.New;
   FIniFile
    .Path(Self.IniPath)
    .Name(INI_NAME);
end;

function TMyDatabaseConnectionFileIni.GetIniInstance: IMyIniLibrary;
begin
   Result := FIniFile;
end;

function TMyDatabaseConnectionFileIni.IniFilePathName: string;
begin
   Result := IncludeTrailingPathDelimiter(Self.IniPath) + INI_NAME;
end;

function TMyDatabaseConnectionFileIni.IniPath: string;
begin
   Result := TMyVclLibrary.GetAppPath;
end;

function TMyDatabaseConnectionFileIni.ReadName(ASection: String): string;
begin
   Result := FIniFile.Section(ASection).Identifier(IDENTIFIER_NAME).ReadIniFileStr(DEFAULT_NAME);
end;

function TMyDatabaseConnectionFileIni.ReadHost(ASection: String): string;
begin
   Result := FIniFile.Section(ASection).Identifier(IDENTIFIER_HOST).ReadIniFileStr(DEFAULT_HOST);
end;

function TMyDatabaseConnectionFileIni.ReadDatabase(ASection: String): string;
begin
   Result := FIniFile.Section(ASection).Identifier(IDENTIFIER_DATABASE).ReadIniFileStr(DEFAULT_DATABASE);
end;

function TMyDatabaseConnectionFileIni.ReadDatabasePathName(ASection: string): string;
begin
   Result := Self.IniPath + FOULDER_DATABASE + Self.ReadDatabase(ASection);
end;

function TMyDatabaseConnectionFileIni.ReadPassword(ASection: String): string;
begin
   Result := FIniFile.Section(ASection).Identifier(IDENTIFIER_PASSWORD).ReadIniFileStr(DEFAULT_PASSWORD);

   if(Result.Equals(DEFAULT_PASSWORD))then
     Exit;

   Result := TMyLibrary.Decrypt(Result);
end;

function TMyDatabaseConnectionFileIni.ReadPort(ASection: String): string;
begin
   Result := FIniFile.Section(ASection).Identifier(IDENTIFIER_PORT).ReadIniFileStr(DEFAULT_PORT);
end;

procedure TMyDatabaseConnectionFileIni.ReadSections;
begin
   if(Assigned(FStrings))then
     FStrings.Free;

   FStrings := TStringList.Create;
   FIniFile.ReadSections(FStrings);
end;

function TMyDatabaseConnectionFileIni.GetSections: TStrings;
begin
   if(not Assigned(FStrings))then
     Self.ReadSections;

   Result := FStrings;
end;

procedure TMyDatabaseConnectionFileIni.CreateNewConfigurationFile;
begin
   Self.CreateNewItem(DEFAULT_NAME, DEFAULT_HOST, DEFAULT_DATABASE, DEFAULT_PASSWORD, DEFAULT_PORT);
end;

procedure TMyDatabaseConnectionFileIni.CreateNewItem(AName, AHost, ADatabase, APassword, APort: String);
begin
   Self.SaveItem(EmptyStr, AName, AHost, ADatabase, APassword, APort);
end;

destructor TMyDatabaseConnectionFileIni.Destroy;
begin
   if(Assigned(FStrings))then
     FStrings.Free;
   inherited;
end;

procedure TMyDatabaseConnectionFileIni.SaveItem(ASection, AName, AHost, ADatabase, APassword, APort: String);
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
