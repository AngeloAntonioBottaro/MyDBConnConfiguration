object ViewLista: TViewLista
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Lista de configura'#231#245'es'
  ClientHeight = 299
  ClientWidth = 504
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnButtons: TPanel
    Left = 0
    Top = 258
    Width = 504
    Height = 41
    Align = alBottom
    Padding.Left = 3
    Padding.Top = 3
    Padding.Right = 3
    Padding.Bottom = 3
    TabOrder = 0
    object btnFechar: TButton
      Left = 404
      Top = 4
      Width = 100
      Height = 33
      Align = alLeft
      Caption = 'Fechar'
      TabOrder = 0
      OnClick = btnFecharClick
    end
    object btnAtualizar: TButton
      Left = 304
      Top = 4
      Width = 100
      Height = 33
      Align = alLeft
      Caption = 'Atualizar'
      TabOrder = 1
      OnClick = btnAtualizarClick
    end
    object btnExluir: TButton
      Left = 204
      Top = 4
      Width = 100
      Height = 33
      Align = alLeft
      Caption = 'Excluir'
      TabOrder = 2
      OnClick = btnExluirClick
    end
    object btnAlterar: TButton
      Tag = 1
      Left = 104
      Top = 4
      Width = 100
      Height = 33
      Align = alLeft
      Caption = 'Alterar'
      TabOrder = 3
      OnClick = btnNovoClick
    end
    object btnNovo: TButton
      Left = 4
      Top = 4
      Width = 100
      Height = 33
      Align = alLeft
      Caption = 'Novo'
      TabOrder = 4
      OnClick = btnNovoClick
    end
  end
  object DBGrid: TDBGrid
    Left = 0
    Top = 0
    Width = 504
    Height = 258
    Align = alClient
    DataSource = DS_TBT_Host
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ReadOnly = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDrawColumnCell = DBGridDrawColumnCell
    Columns = <
      item
        Expanded = False
        FieldName = 'Id'
        Title.Caption = 'C'#243'digo'
        Width = 40
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Name'
        Title.Caption = 'Nome'
        Width = 101
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Host'
        Title.Caption = 'IP/Servidor'
        Width = 117
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Database'
        Title.Caption = 'Banco'
        Width = 108
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Port'
        Title.Caption = 'Porta'
        Width = 37
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Username'
        Title.Caption = 'Usu'#225'rio'
        Width = 62
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Section'
        Title.Caption = 'Chave'
        Width = 283
        Visible = True
      end>
  end
  object TBT_Host: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 24
    Top = 96
    object TBT_HostSection: TStringField
      FieldName = 'Section'
      Size = 80
    end
    object TBT_HostHost: TStringField
      FieldName = 'Host'
      Size = 50
    end
    object TBT_HostName: TStringField
      FieldName = 'Name'
    end
    object TBT_HostDatabase: TStringField
      FieldName = 'Database'
    end
    object TBT_HostPort: TStringField
      FieldName = 'Port'
      Size = 5
    end
    object TBT_HostUsername: TStringField
      FieldName = 'Username'
    end
    object TBT_HostId: TIntegerField
      FieldName = 'Id'
    end
  end
  object DS_TBT_Host: TDataSource
    DataSet = TBT_Host
    Left = 104
    Top = 96
  end
end
