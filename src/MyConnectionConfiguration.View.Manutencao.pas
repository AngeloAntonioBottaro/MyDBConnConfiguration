unit MyConnectionConfiguration.View.Manutencao;

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
  MyConnectionConfiguration.Ini;

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
    procedure FormCreate(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure imgDatabaseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    FIni: TMyConnectionConfigurationIni;
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
  Utils.MyFormLibrary;

procedure TViewManutencao.FormCreate(Sender: TObject);
begin
   TMyFormLibrary.New.ConfForm(Self);
   FSectionAlterar := EmptyStr;
   FIni := TMyConnectionConfigurationIni.Create;
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
   if(not FSectionAlterar.IsEmpty)then
     Self.FillFields;
end;

procedure TViewManutencao.imgDatabaseClick(Sender: TObject);
var
  vDialog: TFileOpenDialog;
begin
   edtDatabase.Text := EmptyStr;
   vDialog := TFileOpenDialog.Create(nil);
   try
     vDialog.Title := 'Selecione o banco de dados';
     vDialog.DefaultFolder := TMyConnectionConfigurationIni.DatabaseFolder;
     if(vDialog.Execute())then
       edtDatabase.Text := ExtractFileName(vDialog.FileName);
   finally
     vDialog.DisposeOf;
   end;
end;

procedure TViewManutencao.btnFecharClick(Sender: TObject);
begin
   Self.Close;
end;

procedure TViewManutencao.btnGravarClick(Sender: TObject);
begin
   if(Trim(edtName.Text).IsEmpty)then
     raise ExceptionRequired.Create('O campo nome é obrigatório', edtName);

   if(Trim(edtDatabase.Text).IsEmpty)then
     raise ExceptionRequired.Create('O campo banco é obrigatório', edtDatabase);

   if(Trim(edtHost.Text).IsEmpty)then
     raise ExceptionRequired.Create('O campo IP/Servidor é obrigatório', edtHost);

   if(Trim(edtUsername.Text).IsEmpty)then
     raise ExceptionRequired.Create('O campo usuário é obrigatório', edtUsername);

   if(Trim(edtPort.Text).IsEmpty)then
     raise ExceptionRequired.Create('O campo porta é obrigatório', edtPort);

   if(Trim(edtPassword.Text).IsEmpty)then
     raise ExceptionRequired.Create('O campo senha é obrigatório', edtPassword);

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
   edtDatabase.Text := FIni.ReadDatabase(FSectionAlterar);
   edtPassword.Text := FIni.ReadPassword(FSectionAlterar);
   edtPort.Text     := FIni.ReadPort(FSectionAlterar);
   edtUsername.Text := FIni.ReadUsername(FSectionAlterar);
end;

end.
