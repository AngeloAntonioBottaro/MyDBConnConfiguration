unit MyDBConnConfiguration.View.Lista;

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
  Data.DB,
  Vcl.Grids,
  Vcl.DBGrids,
  Vcl.ExtCtrls,
  Datasnap.DBClient,
  Vcl.StdCtrls,
  MyDBConnConfiguration.Ini;

type
  TViewLista = class(TForm)
    pnButtons: TPanel;
    DBGrid: TDBGrid;
    TBT_Host: TClientDataSet;
    TBT_HostSection: TStringField;
    TBT_HostHost: TStringField;
    TBT_HostName: TStringField;
    TBT_HostDatabase: TStringField;
    DS_TBT_Host: TDataSource;
    TBT_HostPort: TStringField;
    TBT_HostUsername: TStringField;
    TBT_HostId: TIntegerField;
    btnFechar: TButton;
    btnAtualizar: TButton;
    btnExluir: TButton;
    btnAlterar: TButton;
    btnNovo: TButton;
    procedure FormCreate(Sender: TObject);
    procedure DBGridDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure btnNovoClick(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnExluirClick(Sender: TObject);
    procedure DBGridDblClick(Sender: TObject);
  private
    FIniFile: TMyDBConnConfigurationIni;
    procedure ClearClientDataSet;
  public
  end;

var
  ViewLista: TViewLista;

implementation

{$R *.dfm}

uses
  MyExceptions,
  MyFormLibrary,
  Common.Utils.MyConsts,
  MyDBConnConfiguration.View.Manutencao;

procedure TViewLista.FormCreate(Sender: TObject);
begin
   TMyFormLibrary.New.ConfForm(Self);
   Self.BorderIcons := [biSystemMenu];
   FIniFile := TMyDBConnConfigurationIni.Create;
end;

procedure TViewLista.FormDestroy(Sender: TObject);
begin
   FIniFile.Free;
end;

procedure TViewLista.FormShow(Sender: TObject);
begin
   btnAtualizar.Click;
end;

procedure TViewLista.btnAtualizarClick(Sender: TObject);
var
  I: Integer;
  LSection: string;
begin
   Self.ClearClientDataSet;

   FIniFile.ReadSections;
   for I := 0 to Pred(FIniFile.GetSections.Count) do
   begin
      LSection := FIniFile.GetSections[I];

      TBT_Host.Append;
      TBT_HostId.AsInteger      :=  I + 1;
      TBT_HostSection.AsString  :=  LSection;
      TBT_HostName.AsString     :=  FIniFile.ReadName(LSection);
      TBT_HostHost.AsString     :=  FIniFile.ReadHost(LSection);
      TBT_HostDatabase.AsString :=  FIniFile.ReadDatabase(LSection);
      TBT_HostPort.AsString     :=  FIniFile.ReadPort(LSection);
      TBT_HostUsername.AsString :=  FIniFile.ReadUsername(LSection);
      TBT_Host.Post;
   end;
end;

procedure TViewLista.btnExluirClick(Sender: TObject);
begin
   if(TBT_Host.IsEmpty)then
     Exit;

   FIniFile.GetIniInstance.EraseSection(TBT_HostSection.AsString);
   btnAtualizar.Click;

   if(TBT_Host.IsEmpty)then
     DeleteFile(FIniFile.IniFilePathName);
end;

procedure TViewLista.btnFecharClick(Sender: TObject);
begin
   Self.Close;
end;

procedure TViewLista.btnNovoClick(Sender: TObject);
begin
   if(TButton(Sender).Tag = 1)and(TBT_Host.IsEmpty)then
     raise ExceptionRequired.Create('Nenhum registro selecionado para alteração');

   if(ViewManutencao = nil)then Application.CreateForm(TViewManutencao, ViewManutencao);
   try
     ViewManutencao.SectionAlterar := EmptyStr;
     if(TButton(Sender).Tag = 1)then
       ViewManutencao.SectionAlterar := TBT_HostSection.AsString;

     ViewManutencao.ShowModal;
   finally
     FreeAndNil(ViewManutencao);
   end;

   btnAtualizar.Click;
end;

procedure TViewLista.ClearClientDataSet;
begin
   TBT_Host.Close;
   TBT_Host.CreateDataSet;
   TBT_Host.Open;
   TBT_Host.EmptyDataSet;
   TBT_Host.Close;
   TBT_Host.Open;
end;

procedure TViewLista.DBGridDblClick(Sender: TObject);
begin
   btnAlterar.Click;
end;

procedure TViewLista.DBGridDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
   if(odd(TDBGrid(Sender).DataSource.DataSet.RecNo))then
     Exit;

   if((gdSelected in State))then
     Exit;

   TDBGrid(Sender).Canvas.Brush.Color := COLOR_GRID;
   TDBGrid(Sender).Canvas.FillRect(Rect);
   TDBGrid(Sender).DefaultDrawDataCell(rect,Column.Field,state);
end;

end.
