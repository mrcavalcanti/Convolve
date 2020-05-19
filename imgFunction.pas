{Marcelo Saviski
contato: marcelosaviski@hotmail.com}

unit imgFunction;

interface

uses
  Windows, Graphics, Math;

type
  TPercentProc = function(Percent: Single): Boolean;
  T3x3FloatArray = array[0..2, 0..2] of Double;
  T5x5FloatArray = array[0..3, 0..3] of Double;
  PFloatArray = ^TFloatXYArray;
  TFloatXYArray = array of array of Double;

procedure Convolve(Bitmap: TBitmap; const Mask: TFloatXYArray;
  const Bias: Integer; ReturnBitmap: TBitmap; Percent: TPercentProc = nil);

implementation

type
  TRGBTripleArray = array[0..MaxInt div SizeOf(TRGBTriple) -1] of TRGBTriple;
  PRGBTripleArray = ^TRGBTripleArray;

procedure Convolve(Bitmap: TBitmap; const Mask: TFloatXYArray;
  const Bias: Integer; ReturnBitmap: TBitmap; Percent: TPercentProc);
var
  Row: array of PRGBTripleArray;
  ReturnRow: PRGBTripleArray;
  NewBlue, NewGreen, NewRed: Double;
  i, j, x, y: Integer;
  Coef: Double;
  LenX, LenY, MiddleX, MiddleY: Integer;
  BMPWidth, BMPHeight, xInc, yInc: Integer;
begin
  if (Bitmap = nil) or (ReturnBitmap = nil) or (Length(Mask) = 0) then Exit;
  Assert(Bitmap <> ReturnBitmap, 'ReturnBitmap and Bitmap can not be equals');
  Assert(Bitmap.PixelFormat = pf24bit, 'Invalid PixelFormat');
  
  (*Tamanho da Matriz*)
  LenX := Length(Mask);
  LenY := Length(Mask[0]);
  MiddleY := LenX shr 1;
  MiddleX := LenY shr 1;
  ReturnBitmap.Width := Bitmap.Width;
  ReturnBitmap.Height := Bitmap.Height;
  ReturnBitmap.PixelFormat := pf24bit;

  (*Soma dos coeficientes*)
  Coef := 0;
  for j := Low(Mask) to High(Mask) do
    Coef := Coef + Sum(Mask[J]);
  if Coef = 0 then Coef := 1;

  BMPWidth := Bitmap.Width - 1;
  BMPHeight := Bitmap.Height - 1;

  yInc := 0;
  SetLength(Row, Bitmap.Height);
  for j := Low(Row) to High(Row) do
    Row[j] := Bitmap.ScanLine[j];
  for j := 0 to BMPHeight do
  begin
    ReturnRow := ReturnBitmap.ScanLine[j];
    xInc := 0;
    if (j > MiddleY) and (j <= BMPHeight - MiddleY) then
      yInc := j - MiddleY;
    for i := 0 to BMPWidth do
    begin
      if (i > MiddleX) and (i <= BMPWidth - MiddleX) then
        xInc := i - MiddleX;
      NewRed   := 0;
      NewGreen := 0;
      NewBlue  := 0;
      for y := Low(Mask) to High(Mask) do
        for x := Low(Mask[y]) to High(Mask[y]) do
         begin
          NewRed   := NewRed   + (Row[y + yInc, x + xInc].rgbtRed   * Mask[y, x]);
          NewGreen := NewGreen + (Row[y + yInc, x + xInc].rgbtGreen * Mask[y, x]);
          NewBlue  := NewBlue  + (Row[y + yInc, x + xInc].rgbtBlue  * Mask[y, x]);
         end;
      NewRed := (NewRed / Coef) + Bias;
      NewGreen := (NewGreen / Coef) + Bias;
      NewBlue := (NewBlue / Coef) + Bias;
      if NewRed > 255 then
        NewRed := 255
      else if NewRed < 0 then
        NewRed := 0;
      if NewGreen > 255 then
        NewGreen := 255
      else if NewGreen < 0 then
        NewGreen := 0;
      if NewBlue > 255 then
        NewBlue := 255
      else if NewBlue < 0 then
        NewBlue := 0;
      with ReturnRow[i] do
      begin
        rgbtRed   := Trunc(NewRed);
        rgbtGreen := Trunc(NewGreen);
        rgbtBlue  := Trunc(NewBlue);
      end;
    end;
    if Assigned(Percent) then
      if Percent(j/BMPHeight) then Exit;
  end;
end;

end.
