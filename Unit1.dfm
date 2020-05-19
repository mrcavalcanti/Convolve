object frmMain: TfrmMain
  Left = 216
  Top = 340
  Width = 462
  Height = 322
  Caption = 'Convolu'#231#245'es - Marcelo Saviski'
  Color = clBtnFace
  Constraints.MinHeight = 24
  Constraints.MinWidth = 160
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 454
    Height = 270
    ActivePage = TabimgOriginal
    Align = alClient
    TabOrder = 0
    OnResize = PageControlResize
    object TabimgOriginal: TTabSheet
      Caption = 'Imagem &Original'
      DesignSize = (
        446
        242)
      object imgOriginal: TImage
        Left = 199
        Top = 95
        Width = 48
        Height = 48
        Cursor = crHandPoint
        Anchors = []
        AutoSize = True
        Center = True
        OnMouseDown = imgOriginalMouseDown
        OnMouseMove = imgOriginalMouseMove
      end
    end
    object TabimgTrasf: TTabSheet
      Caption = 'Imagem &Trasformada'
      ImageIndex = 1
      DesignSize = (
        446
        242)
      object imgTransf: TImage
        Left = 199
        Top = 95
        Width = 48
        Height = 48
        Cursor = crHandPoint
        Anchors = []
        AutoSize = True
        Center = True
        OnMouseDown = imgOriginalMouseDown
        OnMouseMove = imgOriginalMouseMove
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 270
    Width = 454
    Height = 25
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object lblPercent: TLabel
      Left = 451
      Top = 0
      Width = 3
      Height = 25
      Align = alRight
      OnClick = lblPercentClick
    end
    object Painel: TPanel
      Left = 0
      Top = 0
      Width = 301
      Height = 25
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object btnConvolve: TButton
        Left = 150
        Top = 0
        Width = 75
        Height = 25
        Caption = '&Convolver'
        Enabled = False
        TabOrder = 0
        OnClick = btnConvolveClick
      end
      object btnAjustar: TButton
        Left = 225
        Top = 0
        Width = 75
        Height = 25
        Caption = '&Ajustar'
        TabOrder = 1
        OnClick = btnAjustarClick
      end
      object btnSalvar: TButton
        Left = 75
        Top = 0
        Width = 75
        Height = 25
        Caption = '&Salvar'
        Enabled = False
        TabOrder = 2
        OnClick = btnSalvarClick
      end
      object btnCarregar: TButton
        Left = 0
        Top = 0
        Width = 75
        Height = 25
        Caption = '&Carregar'
        TabOrder = 3
        OnClick = btnCarregarClick
      end
    end
  end
  object OpenPictureDialog: TOpenPictureDialog
    Left = 48
    Top = 400
  end
  object SavePictureDialog: TSavePictureDialog
    Left = 76
    Top = 400
  end
end
