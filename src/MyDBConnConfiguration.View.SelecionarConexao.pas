unit MyDBConnConfiguration.View.SelecionarConexao;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
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
  Vcl.Imaging.pngimage;

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
    TBT_HostHost: TStringField;
    imgConf: TImage;
    procedure FormShow(Sender: TObject);
    procedure btnSelecionarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure imgConfClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    FSelectedSection: string;    
    procedure LoadConfigurations;
    procedure ClearClientDataSet;
  public
    property SelectedSection: string read FSelectedSection write FSelectedSection;
  end;

var
  ViewSelecionarConexao: TViewSelecionarConexao;

implementation

{$R *.dfm}

uses
  MyFormLibrary,
  MyDBConnConfiguration.Consts,
  MyDBConnConfiguration.Ini,
  MyDBConnConfiguration.View.Lista;

procedure TViewSelecionarConexao.FormCreate(Sender: TObject);
begin
   TMyFormLibrary.New.ConfForm(Self);
end;

procedure TViewSelecionarConexao.FormKeyPress(Sender: TObject; var Key: Char);
begin
   if(Key = #13)then
   begin
      Perform(CM_DialogKey, VK_TAB, 0);
      Key := #0;
   end;
end;

procedure TViewSelecionarConexao.FormShow(Sender: TObject);
begin
   Self.LoadConfigurations;
end;

procedure TViewSelecionarConexao.btnCancelarClick(Sender: TObject);
begin
   Self.Close;
   ModalResult := mrCancel;
end;

procedure TViewSelecionarConexao.btnSelecionarClick(Sender: TObject);
begin
   FSelectedSection := DBLookupComboBox1.KeyValue;
   Self.Close;
   ModalResult := mrOk;
end;

procedure TViewSelecionarConexao.imgConfClick(Sender: TObject);
begin
   if(ViewLista = nil)then Application.CreateForm(TViewLista, ViewLista);
   try
     ViewLista.ShowModal;
   finally
     FreeAndNil(ViewLista);
   end;
   Self.LoadConfigurations;
end;

procedure TViewSelecionarConexao.LoadConfigurations;
var                
  LIniFile: TMyDBConnConfigurationIni;
  I: Integer;
  LSection: string;
begin
   Self.ClearClientDataSet;

   LIniFile := TMyDBConnConfigurationIni.Create;
   try
     LIniFile.ReadSections;
     for I := 0 to Pred(LIniFile.GetSections.Count) do
     begin
        LSection := LIniFile.GetSections[I];

        TBT_Host.Append;
        TBT_HostSection.AsString  :=  LSection;
        TBT_HostName.AsString     :=  LIniFile.ReadName(LSection);
        TBT_HostHost.AsString     :=  LIniFile.ReadHost(LSection);
        TBT_HostDatabase.AsString :=  LIniFile.ReadDatabase(LSection);
        TBT_Host.Post;
     end;
   finally
     LIniFile.Free;
   end; 

   DBLookupComboBox1.ListFieldIndex := 0;  
end;

procedure TViewSelecionarConexao.ClearClientDataSet;
begin
   TBT_Host.Close;
   TBT_Host.CreateDataSet;
   TBT_Host.Open;
   TBT_Host.EmptyDataSet;
   TBT_Host.Close;
   TBT_Host.Open;
end;

end.
