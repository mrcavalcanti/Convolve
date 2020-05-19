{Marcelo Saviski
marcelosaviski@hotmail.com}
unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Jpeg, imgFunction {$IFDEF VER150}, XPMan{$ENDIF},
  ComCtrls, ExtDlgs;

type
  TfrmMain = class(TForm)
    PageControl: TPageControl;
    TabimgOriginal: TTabSheet;
    TabimgTrasf: TTabSheet;
    OpenPictureDialog: TOpenPictureDialog;
    SavePictureDialog: TSavePictureDialog;
    imgOriginal: TImage;
    imgTransf: TImage;
    Panel1: TPanel;
    Painel: TPanel;
    btnConvolve: TButton;
    btnAjustar: TButton;
    btnSalvar: TButton;
    btnCarregar: TButton;
    lblPercent: TLabel;
    procedure btnConvolveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnCarregarClick(Sender: TObject);
    procedure btnAjustarClick(Sender: TObject);
    procedure lblPercentClick(Sender: TObject);
    procedure imgOriginalMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgOriginalMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PageControlResize(Sender: TObject);
  private

  public
    
  end;

var
  frmMain: TfrmMain;
  Cancel: Boolean;

implementation

uses Unit2;

{$R *.dfm}

function ShowPercentage(Percent: Single): Boolean;
begin
  frmMain.lblPercent.Caption := Format('Concluido: %3.f%% - clique p/ cancelar ', [Percent*100]);
  Application.ProcessMessages;
  Result := Cancel;
end;

procedure TfrmMain.btnConvolveClick(Sender: TObject);
begin
  if frmAjuste.ckbSobrepor.Checked then
    imgOriginal.Picture := imgTransf.Picture;
  imgTransf.Hide;
  Painel.Enabled := False;
  try
    Convolve(imgOriginal.Picture.Bitmap, frmAjuste.Mask, frmAjuste.Bias, imgTransf.Picture.Bitmap,
      ShowPercentage);
  finally
    lblPercent.Caption := '';
    Painel.Enabled := True;
  end;
  btnSalvar.Enabled := True;
  imgTransf.Show;
  frmAjuste.ckbSobrepor.Enabled := True;
  imgTransf.Left := (imgTransf.Parent.Width - imgTransf.Width) div 2;
  imgTransf.Top := (imgTransf.Parent.Height - imgTransf.Height) div 2;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  OpenPictureDialog.InitialDir := ExtractFilePath(Application.ExeName);
  PageControl.ActivePage := TabimgOriginal;
  TabimgOriginal.DoubleBuffered := True;
  TabimgOriginal.ControlStyle := TabimgOriginal.ControlStyle + [csOpaque];
  TabimgTrasf.DoubleBuffered := True;
  TabimgTrasf.ControlStyle := TabimgTrasf.ControlStyle + [csOpaque];   
end;

procedure TfrmMain.btnSalvarClick(Sender: TObject);
begin
  if SavePictureDialog.Execute then
    imgTransf.Picture.SaveToFile(SavePictureDialog.FileName);
end;

procedure TfrmMain.btnCarregarClick(Sender: TObject);
begin
  if OpenPictureDialog.Execute then
  begin
    with TPicture.Create do
    try
      LoadFromFile(OpenPictureDialog.FileName);
      imgOriginal.Picture.Bitmap.PixelFormat := pf24bit;
      imgOriginal.Picture.Bitmap.Width := Graphic.Width;
      imgOriginal.Picture.Bitmap.Height := Graphic.Height;
      imgOriginal.Picture.Bitmap.Canvas.Draw(0, 0, Graphic);
      PageControl.ActivePage := TabimgOriginal;
      btnConvolve.Enabled := Length(frmAjuste.Mask) > 0;
      imgOriginal.Left := (imgOriginal.Parent.Width - imgOriginal.Width) div 2;
      imgOriginal.Top := (imgOriginal.Parent.Height - imgOriginal.Height) div 2;
      imgTransf.Picture := nil;
      btnSalvar.Enabled := False;
      frmAjuste.ckbSobrepor.Checked := False;
      frmAjuste.ckbSobrepor.Enabled := False;
    finally
      Free;
    end;
  end;
end;

procedure TfrmMain.btnAjustarClick(Sender: TObject);
begin
  frmAjuste.Show;
end;

procedure TfrmMain.lblPercentClick(Sender: TObject);
begin
  Cancel := Application.MessageBox('Cancelar?', PChar(Caption), MB_YESNO + MB_ICONQUESTION) = ID_YES;
  if Cancel then imgTransf.Picture := nil;
end;

var
  AX, AY: Integer;

procedure TfrmMain.imgOriginalMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  n: Integer;
begin
  with TImage(Sender) do
    if csClicked in ControlState then
    begin
      n := Left + (X - AX);
      if (n < 0) and (Width + n > Parent.Width) then
        Left := n;
      n :=  Top + (Y - AY);
      if (n < 0) and (Height + n > Parent.Height) then
        Top := n;
    end;
end;

procedure TfrmMain.imgOriginalMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  AX := X;
  AY := Y;
end;

procedure TfrmMain.PageControlResize(Sender: TObject);
begin
  imgOriginal.Left := (imgOriginal.Parent.Width - imgOriginal.Width) div 2;
  imgOriginal.Top := (imgOriginal.Parent.Height - imgOriginal.Height) div 2;
  imgTransf.Left := (imgTransf.Parent.Width - imgTransf.Width) div 2;
  imgTransf.Top := (imgTransf.Parent.Height - imgTransf.Height) div 2;
end;

end.
