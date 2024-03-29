unit MyDBConnConfiguration.View.Manutencao;

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
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Imaging.pngimage,
  MyDBConnConfiguration.Ini;

type
  TViewManutencao = class(TForm)
    pnButtons: TPanel;
    btnFechar: TButton;
    btnGravar: TButton;
    pnTela: TPanel;
    edtName: TLabeledEdit;
    edtHost: TLabeledEdit;
    edtUsername: TLabeledEdit;
    edtPort: TLabeledEdit;
    edtDatabase: TLabeledEdit;
    imgDatabase: TImage;
    edtPassword: TLabeledEdit;
    imgVerSenha: TImage;
    imgOcultarSenha: TImage;
    procedure FormCreate(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure imgDatabaseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure imgVerSenhaClick(Sender: TObject);
    procedure imgOcultarSenhaClick(Sender: TObject);
  private
    FIni: TMyDBConnConfigurationIni;
    FSectionAlterar: string;
    procedure FillFields;
  public
    property SectionAlterar: string read FSectionAlterar write FSectionAlterar;
  end;

var
  ViewManutencao: TViewManutencao;

implementation

{$R *.dfm}

uses
  MyExceptions,
  MyFormLibrary,
  MyDBConnConfiguration.Consts;

procedure TViewManutencao.FormCreate(Sender: TObject);
begin
   TMyFormLibrary.New.ConfForm(Self);
   FSectionAlterar := EmptyStr;
   FIni := TMyDBConnConfigurationIni.Create;
end;

procedure TViewManutencao.FormDestroy(Sender: TObject);
begin
   FIni.Free;
end;

procedure TViewManutencao.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   TMyFormLibrary.New.DefaultKeyDown(Self, Key, Shift);
end;

procedure TViewManutencao.FormKeyPress(Sender: TObject; var Key: Char);
begin
   if(Key = #13)then
   begin
      Perform(CM_DialogKey, VK_TAB, 0);
      Key := #0;
   end;
end;

procedure TViewManutencao.FormShow(Sender: TObject);
begin
   edtHost.Text     := DEFAULT_HOST;
   edtUsername.Text := DEFAULT_USERNAME;
   edtPort.Text     := DEFAULT_PORT;
   edtDatabase.Text := DEFAULT_DATABASE;
   imgOcultarSenhaClick(nil);

   if(not FSectionAlterar.IsEmpty)then
     Self.FillFields;
end;

procedure TViewManutencao.imgDatabaseClick(Sender: TObject);
var
  LDialog: TFileOpenDialog;
begin
   edtDatabase.Text := EmptyStr;
   LDialog := TFileOpenDialog.Create(nil);
   try
     LDialog.Title := 'Selecione o banco de dados';
     LDialog.DefaultFolder := 'C:\';
     if(LDialog.Execute())then
       edtDatabase.Text := LDialog.FileName;
   finally
     LDialog.DisposeOf;
   end;
end;

procedure TViewManutencao.imgOcultarSenhaClick(Sender: TObject);
begin
   imgVerSenha.Visible      := True;
   imgOcultarSenha.Visible  := False;
   edtPassword.PasswordChar := Char('#');
end;

procedure TViewManutencao.imgVerSenhaClick(Sender: TObject);
begin
   imgVerSenha.Visible      := False;
   imgOcultarSenha.Visible  := True;
   edtPassword.PasswordChar := #0;
end;

procedure TViewManutencao.btnFecharClick(Sender: TObject);
begin
   Self.Close;
end;

procedure TViewManutencao.btnGravarClick(Sender: TObject);
begin
   if(Trim(edtName.Text).IsEmpty)then
     raise ExceptionRequired.Create('O campo nome � obrigat�rio', edtName);

   if(Trim(edtDatabase.Text).IsEmpty)then
     raise ExceptionRequired.Create('O campo banco � obrigat�rio', edtDatabase);

   if(Trim(edtHost.Text).IsEmpty)then
     raise ExceptionRequired.Create('O campo IP/Servidor � obrigat�rio', edtHost);

   if(Trim(edtUsername.Text).IsEmpty)then
     raise ExceptionRequired.Create('O campo usu�rio � obrigat�rio', edtUsername);

   if(Trim(edtPort.Text).IsEmpty)then
     raise ExceptionRequired.Create('O campo porta � obrigat�rio', edtPort);

   if(Trim(edtPassword.Text).IsEmpty)then
     raise ExceptionRequired.Create('O campo senha � obrigat�rio', edtPassword);

   FIni.SaveItem(FSectionAlterar,
                 edtName.Text,
                 edtHost.Text,
                 edtDatabase.Text,
                 edtPassword.Text,
                 edtPort.Text,
                 edtUsername.Text);

   FSectionAlterar := EmptyStr;
   Self.Close;
end;

procedure TViewManutencao.FillFields;
begin
   edtName.Text     := FIni.ReadName(FSectionAlterar);
   edtHost.Text     := FIni.ReadHost(FSectionAlterar);
   edtDatabase.Text := IncludeTrailingPathDelimiter(FIni.ReadDBPath(FSectionAlterar)) + FIni.ReadDatabase(FSectionAlterar);
   edtPassword.Text := FIni.ReadPassword(FSectionAlterar);
   edtPort.Text     := FIni.ReadPort(FSectionAlterar);
   edtUsername.Text := FIni.ReadUsername(FSectionAlterar);
end;

end.
