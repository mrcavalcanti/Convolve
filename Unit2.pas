unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, Buttons, ExtCtrls, imgFunction, IniFiles;

type
  TfrmAjuste = class(TForm)
    Painel: TPanel;
    BitBtn1: TBitBtn;
    Button1: TButton;
    Label1: TLabel;
    edtBias: TEdit;
    Button2: TButton;
    Grade: TStringGrid;
    Panel2: TPanel;
    ListBox: TListBox;
    Button3: TButton;
    Splitter1: TSplitter;
    ckbSobrepor: TCheckBox;
    procedure GradeKeyPress(Sender: TObject; var Key: Char);
    procedure GradeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure edtBiasKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure ListBoxClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ListBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ListBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormDeactivate(Sender: TObject);
    procedure ListBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Splitter1CanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure GradeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GradeMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure GradeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    function ContGrid: TSize;
    procedure Limpar;
  public
    Mask: TFloatXYArray;
    Bias: Integer;
    Ini, DefIni: TMemIniFile;
    procedure ApplyMask;
  end;

const
  RowSeparator: char = '|';
  ColSeparator: char = ',';

var
  frmAjuste: TfrmAjuste;
  
implementation

uses Unit1, Math;

{$R *.dfm}

procedure TfrmAjuste.GradeKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', #8{BackSpace}, '-', DecimalSeparator]) then
    Key := #0
  else
  begin
    ListBox.ItemIndex := 0;
    Caption := 'Ajuste';
  end;
end;

procedure TfrmAjuste.GradeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not Grade.EditorMode then Exit;
  case Key of
    VK_LEFT:  if Grade.Col > 0 then Grade.Col := Grade.Col - 1;
    VK_RIGHT: if Grade.Col < Grade.ColCount then  Grade.Col := Grade.Col + 1;
  end;
end;

procedure TfrmAjuste.FormShow(Sender: TObject);
begin
  Grade.SetFocus;
end;

procedure TfrmAjuste.Button1Click(Sender: TObject);
var
  i, j: Integer;
  Texto: string;
begin
  if not InputQuery('Informe o novo valor', 'Alteração múltipla', Texto) then Exit;
  for j := Grade.Selection.Top to Grade.Selection.Bottom do
    for i := Grade.Selection.Left to Grade.Selection.Right do
      Grade.Cells[i, j] := Texto;
end;

procedure TfrmAjuste.edtBiasKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', #8, '-']) then
    Key := #0;
end;

procedure TfrmAjuste.Limpar;
var
  I: Integer;
begin
  for I := 0 to Grade.ColCount -1 do
    Grade.Cols[I].Clear;
end;

function TfrmAjuste.ContGrid: TSize;
var
  i, j: Integer;
  n: Double;
begin
  Result.cx := 0;
  Result.cy := 0;
  for j := 0 to Grade.RowCount -1 do
    for i := 0 to Grade.ColCount -1 do
      if TryStrToFloat(Grade.Cells[i, j], n) then
      begin
        if j >= Result.cy then
          Result.cy := j + 1;
        if i >= Result.cx then
          Result.cx := i + 1;
      end;
end;

procedure TfrmAjuste.ApplyMask;
var
  Size: TSize;
  i, j: integer;
begin
  Size := ContGrid;
  SetLength(Mask, Size.cy, Size.cx);
  Bias := MulDiv(StrToIntDef(Trim(edtBias.Text), 0), 255, 100);
  for j := 0 to Size.cy - 1 do
    for i := 0 to Size.cx - 1 do
    begin
      Mask[j, i] := StrToFloatDef(Grade.Cells[i, j], 0);
    end;
  frmMain.btnConvolve.Enabled := (Length(frmAjuste.Mask) > 0) and (not frmMain.imgOriginal.Picture.Bitmap.Empty);
end;

procedure TfrmAjuste.FormCreate(Sender: TObject);
const
  FilterExtension = '.ini';
  DefaultFile = 'Filtros' + FilterExtension;
var
  SearchRec: TSearchRec;
  I: Integer;
  Strings: TStrings;
begin
  I := FindFirst(ExtractFilePath(Application.ExeName) + '*' + FilterExtension, faAnyFile, SearchRec);
  Strings := TStringList.Create;
  with TMemIniFile.Create('') do
  try
    while I = 0 do
    begin
      Rename(SearchRec.Name, True);
      GetStrings(Strings);
      I := FindNext(SearchRec);
    end;
  finally
    Free;
    FindClose(SearchRec);
  end;
  DefIni := TMemIniFile.Create(ExtractFilePath(Application.ExeName) + DefaultFile);
  Ini := TMemIniFile.Create('');
  Ini.SetStrings(Strings);
  Strings.Free;
  Ini.ReadSections(ListBox.Items);
  ListBox.Sorted := True;
  ListBox.Items.Insert(0, ' Custom');
  ListBox.ItemIndex := 0;
end;

procedure TfrmAjuste.FormDestroy(Sender: TObject);
begin
  Ini.Free;
  DefIni.Free;
end;

procedure TfrmAjuste.Button3Click(Sender: TObject);
var
  Nome, s: string;
  I: Integer;
begin
  ApplyMask;
  if Length(Mask) = 0 then Exit;
  Nome := Trim(InputBox('Salvar', 'Informe um nome para o Filtro', ''));
  if Nome = '' then Exit;
  if Ini.SectionExists(Nome) then
  begin
    ShowMessage('Já existe um Filtro com este nome');
    Exit;
  end
  else
    ListBox.Items.Add(Nome);
  s := '';
  with TStringList.Create do
  try
    Delimiter := ColSeparator;
    for I := Low(Mask) to High(Mask) do
    begin
      Text := TrimRight(Grade.Rows[I].Text);
      s := s + DelimitedText + RowSeparator;
    end;
  finally
    Free;
  end;
  Ini.WriteInteger(Nome, 'Bias', StrToIntDef(edtBias.Text, 0));
  Ini.WriteString(Nome, 'Data', s);
  DefIni.WriteInteger(Nome, 'Bias', StrToIntDef(edtBias.Text, 0));
  DefIni.WriteString(Nome, 'Data', s);
  DefIni.UpdateFile;
  ListBox.Sorted := True;
end;

procedure TfrmAjuste.BitBtn1Click(Sender: TObject);
begin
  Close;
  ApplyMask;
end;

procedure TfrmAjuste.ListBoxClick(Sender: TObject);
var
  I: Integer;
  Data, Section: string;
  Row: TStrings;
begin
  if ListBox.ItemIndex = -1 then Exit;
  Limpar;
  if ListBox.ItemIndex = 0 then
  begin
    ApplyMask;
    Caption := 'Ajuste';
  end
  else
  begin
    Section := ListBox.Items[ListBox.ItemIndex];
    Caption := 'Ajuste ' + Section;
    Data := Ini.ReadString(Section, 'Data', '');
    edtBias.Text := Ini.ReadString(Section, 'Bias', '0'); 
    with TStringList.Create do
    try
      Delimiter := RowSeparator;
      DelimitedText := Data;
      for I := 0 to Count - 1 do
      begin
        Row := Grade.Rows[I];
        Row.Delimiter := ColSeparator;
        Row.DelimitedText := Strings[I];
        Grade.Rows[I] := Row;
      end;
    finally
      Free;
    end;
    ApplyMask;
  end;
end;

procedure TfrmAjuste.Button2Click(Sender: TObject);
begin
  Limpar;
  ListBox.ItemIndex := 0;
end;

procedure TfrmAjuste.ListBoxMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  Index: Integer;
begin
  Index := ListBox.ItemAtPos(Point(X, Y), True);
  if Index <> -1 then
    ListBox.Hint := ListBox.Items[Index];
end;

procedure TfrmAjuste.ListBoxDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  Section: string;
  cpos: Integer;
begin
  with TListBox(Control), Canvas do
  begin
    if odSelected in State then
    begin
      Brush.Color := clHighlight;
      Font.Color := clHighlightText; 
    end
    else if Odd(Index) then
      Brush.Color := $D0ECD0;
    if (Index <> 0) and ( not DefIni.SectionExists(Items[Index])) then
    begin
      Section := '>' + Items[Index];
      if not (odSelected in State) then Font.Color := $202040;
    end
    else
      Section := Items[Index];
    cpos := AnsiPos('#', Section);
    if cpos > 0 then
       Section := Copy(Section, 1, cpos - 1);
    FillRect(Rect);
    TextRect(Rect, Rect.Left, Rect.Top, Section);
  end;
end;

procedure TfrmAjuste.FormDeactivate(Sender: TObject);
begin
  ApplyMask;
end;

procedure TfrmAjuste.ListBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Index: Integer;
  Section, NewSection, Data: string;
  Bias: Integer;
begin
  Index := ListBox.ItemIndex;
  if Index <> -1 then
  begin
    Section := ListBox.Items[ListBox.ItemIndex];
    if DefIni.SectionExists(Section) then
    begin
      if Key = VK_DELETE then
      begin
        if Application.MessageBox(PChar('Excluir o Filtro ' + Section + '?'), 'Convoluções', MB_YESNO + MB_ICONQUESTION) = ID_YES then
        begin
          ListBox.Items.Delete(Index);
          DefIni.EraseSection(Section);
          DefIni.UpdateFile;
          ListBox.Sorted := True;
        end;
      end
      else if Key = VK_F2 then
      begin
        NewSection := InputBox('Digite o novo nome para o Filtro', 'Convoluções', Section);
        if NewSection <> '' then
        begin
          Data := DefIni.ReadString(Section, 'Data', '');
          Bias := DefIni.ReadInteger(Section, 'Bias', 0);
          DefIni.EraseSection(Section);
          DefIni.WriteString(NewSection, 'Data', Data);
          DefIni.WriteInteger(NewSection, 'Bias', Bias);
          DefIni.UpdateFile;
          ListBox.Items[ListBox.ItemIndex] := NewSection;
          ListBox.Sorted := True;
        end;
      end;
    end;
  end;
end;

procedure TfrmAjuste.Splitter1CanResize(Sender: TObject;
  var NewSize: Integer; var Accept: Boolean);
begin
  Accept := (NewSize > 90) and (NewSize < Width div 2);
end;

var
  ACol, ARow: Integer;

procedure TfrmAjuste.GradeMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if not (ssShift in Shift) then
    Grade.MouseToCell(X, Y, ACol, ARow);
end;

procedure TfrmAjuste.GradeMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  gRect: TGridRect;
begin
  if csLButtonDown in Grade.ControlState then
  begin
    gRect.Left := ACol;
    gRect.Top := ARow;
    Grade.MouseToCell(X, Y, gRect.Right, gRect.Bottom);
    Grade.Selection := gRect;
    Grade.Repaint;
    Grade.Canvas.Brush.Style := bsClear;
    
    with Grade.ScreenToClient(Mouse.CursorPos), gRect do
      Grade.Canvas.TextOut(X + 8, Y + 16, Format('%d,%d x %d,%d', [Left + 1, Top + 1, Right - Left + 1, Bottom - Top + 1]));
  end;
end;

procedure TfrmAjuste.GradeMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Grade.Repaint;
end;

end.
