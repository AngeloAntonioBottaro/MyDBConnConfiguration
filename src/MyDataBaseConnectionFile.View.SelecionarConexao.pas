unit MyDataBaseConnectionFile.View.SelecionarConexao;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.IniFiles,
  System.Classes,
  System.Variants,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.DBCtrls,
  Data.DB,
  Datasnap.DBClient,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.Imaging.pngimage,
  Utils.MyIniLibrary;

type
  TViewSelecionarConexao = class(TForm)
    TBT_Host: TClientDataSet;
    DS_TBT_Host: TDataSource;
    pnTela: TPanel;
    pnButtons: TPanel;
    DBLookupComboBox1: TDBLookupComboBox;
    btnCancelar: TButton;
    btnSelecionar: TButton;
    lbSelecionar: TLabel;
    TBT_HostSection: TStringField;
    TBT_HostName: TStringField;
    TBT_HostDatabase: TStringField;
    TBT_HostPassword: TStringField;
    TBT_HostHost: TStringField;
    TBT_HostPort: TStringField;
    imgConf: TImage;
    procedure FormShow(Sender: TObject);
    procedure btnSelecionarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure imgConfClick(Sender: TObject);
  private
    FIniFile: IMyIniLibrary;
    FSections: TStrings;
    FSelectedSection: string;
  public
    property IniFile: IMyIniLibrary read FIniFile write FIniFile;
    property Sections: TStrings read FSections write FSections;
    property SelectedSection: string read FSelectedSection write FSelectedSection;
  end;

var
  ViewSelecionarConexao: TViewSelecionarConexao;

implementation

{$R *.dfm}

uses
  MyDatabaseConnectionFile.Consts,
  MyDataBaseConnectionFile.View.Lista;

procedure TViewSelecionarConexao.btnCancelarClick(Sender: TObject);
begin
   Self.Close;
   ModalResult := mrCancel;
end;

procedure TViewSelecionarConexao.btnSelecionarClick(Sender: TObject);
begin
   FSelectedSection := DBLookupComboBox1.KeyField;
   Self.Close;
   ModalResult := mrOk;
end;

procedure TViewSelecionarConexao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   FIniFile  := nil;
   FSections := nil;
end;

procedure TViewSelecionarConexao.FormShow(Sender: TObject);
var
  I: Integer;
  LSection: string;
begin
   TBT_Host.Close;
   TBT_Host.Open;
   for I := 0 to Pred(FSections.Count) do
   begin
      LSection := FSections[I];
      FIniFile.Section(LSection);

      TBT_Host.Append;
      TBT_HostSection.AsString  :=  LSection;
      TBT_HostName.AsString     :=  FIniFile.Identifier(IDENTIFIER_NAME).ReadIniFileStr(DEFAULT_NAME);
      TBT_HostHost.AsString     :=  FIniFile.Identifier(IDENTIFIER_HOST).ReadIniFileStr(DEFAULT_HOST);
      TBT_HostDatabase.AsString :=  FIniFile.Identifier(IDENTIFIER_DATABASE).ReadIniFileStr(DEFAULT_DATABASE);
      TBT_HostPassword.AsString :=  FIniFile.Identifier(IDENTIFIER_PASSWORD).ReadIniFileStr;
      TBT_HostPort.AsString     :=  FIniFile.Identifier(IDENTIFIER_PORT).ReadIniFileStr(DEFAULT_PORT);
      TBT_Host.Post;
   end;
end;

procedure TViewSelecionarConexao.imgConfClick(Sender: TObject);
begin
   if(ViewLista = nil)then Application.CreateForm(TViewLista, ViewLista);
   try
     ViewLista.ShowModal;
   finally
     FreeAndNil(ViewLista);
   end;
end;

end.
