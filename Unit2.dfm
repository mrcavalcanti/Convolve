object frmAjuste: TfrmAjuste
  Left = 393
  Top = 130
  Width = 390
  Height = 244
  BorderStyle = bsSizeToolWin
  Caption = 'Ajuste'
  Color = clBtnFace
  Constraints.MinHeight = 180
  Constraints.MinWidth = 379
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 169
    Top = 0
    Width = 4
    Height = 156
    OnCanResize = Splitter1CanResize
  end
  object Painel: TPanel
    Left = 0
    Top = 156
    Width = 382
    Height = 54
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      382
      54)
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 20
      Height = 13
      Caption = 'Bias'
      Transparent = False
    end
    object BitBtn1: TBitBtn
      Left = 305
      Top = 27
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '&Fechar'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = BitBtn1Click
      NumGlyphs = 2
    end
    object Button1: TButton
      Left = 230
      Top = 2
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '&Multi-Edi'#231#227'o'
      TabOrder = 1
      OnClick = Button1Click
    end
    object edtBias: TEdit
      Left = 32
      Top = 4
      Width = 49
      Height = 21
      TabOrder = 2
      Text = '0'
      OnKeyPress = edtBiasKeyPress
    end
    object Button2: TButton
      Left = 305
      Top = 2
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '&Limpar'
      TabOrder = 3
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 230
      Top = 27
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '&Salvar'
      TabOrder = 4
      OnClick = Button3Click
    end
    object ckbSobrepor: TCheckBox
      Left = 8
      Top = 32
      Width = 193
      Height = 17
      Caption = 'Aplicar sobre a Imagem Trasformada'
      Enabled = False
      TabOrder = 5
    end
  end
  object Grade: TStringGrid
    Left = 173
    Top = 0
    Width = 209
    Height = 156
    Align = alClient
    ColCount = 50
    Ctl3D = True
    DefaultColWidth = 20
    DefaultRowHeight = 20
    FixedColor = 16776176
    FixedCols = 0
    RowCount = 50
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    ParentCtl3D = False
    TabOrder = 1
    OnKeyDown = GradeKeyDown
    OnKeyPress = GradeKeyPress
    OnMouseDown = GradeMouseDown
    OnMouseMove = GradeMouseMove
    OnMouseUp = GradeMouseUp
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 169
    Height = 156
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 2
    object ListBox: TListBox
      Left = 0
      Top = 0
      Width = 169
      Height = 156
      Style = lbOwnerDrawFixed
      Align = alClient
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = ListBoxClick
      OnDrawItem = ListBoxDrawItem
      OnKeyDown = ListBoxKeyDown
      OnMouseMove = ListBoxMouseMove
    end
  end
end
