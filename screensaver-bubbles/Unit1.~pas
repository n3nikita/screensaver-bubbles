unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls, Math, XPMan, ComCtrls, IniFiles;

type
  TForm1 = class(TForm)
    shp1: TShape;
    shp2: TShape;
    shp3: TShape;
    shp4: TShape;
    shp5: TShape;
    tmr1: TTimer;
    shp6: TShape;
    shp7: TShape;
    shp8: TShape;
    shp9: TShape;
    shp10: TShape;
    img1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure tmr1Timer(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure img1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure BallsFly();
  public
    { Public declarations }
  end;

type
  Counter = 0..9;

var
  Form1: TForm1;
  PosX, Posy, VelX, Vely: Real;
  masPosX, masPosY, masVelX, masVelY: array of Real;
  Ball: array[0..9] of TShape;
  //BallCount, PenWidth, TextureNumber, circles, screenshot, speed: Cardinal;
  BallCount, PenWidth, TextureNumber, circles, screenshot, speed: Counter;
  PenEn: Boolean;
  BrushColor, PenColor, BGColor: TColor;
  ini: TIniFile;

procedure setBallsSquares;

procedure setBallsCircles;

procedure setDiagonalLinesLeft;

procedure setDiagonalLinesRight;

procedure setCrossLines;

procedure setDiagonalCrossLines;

procedure setHorizontalLines;

procedure setVerticalLines;

procedure setTextureNone;

procedure ballsVisibleFL;

procedure delBallPen;

procedure BallPenWidth(width: Cardinal);

implementation

uses
  Unit2;

{$R *.dfm}

procedure Memory; //процедура выделения памяти и заполнения массива шариков
begin
  //выделяем память массивам координат
  SetLength(masPosX, 10);
  SetLength(masPosY, 10);
  SetLength(masVelX, 10);
  SetLength(masVelY, 10);

  with form1 do  //заносим шарики в массив
  begin
    Ball[0] := shp1;
    Ball[1] := shp2;
    Ball[2] := shp3;
    Ball[3] := shp4;
    Ball[4] := shp5;
    Ball[5] := shp6;
    Ball[6] := shp7;
    Ball[7] := shp8;
    Ball[8] := shp9;
    Ball[9] := shp10;
  end;
end;

procedure createScreenShot;
var
  bmp: TBitmap;
begin
    //скриншот на задний фон
  bmp := TBitmap.Create;
  bmp.Width := Screen.Width;
  bmp.Height := Screen.Height;
  BitBlt(bmp.Canvas.Handle, 0, 0, Screen.Width, Screen.Height, GetDC(0), 0, 0, SRCCOPY); //GetDC(FindWindow('ProgMan', nil)), 0,0,SRCCOPY);
  Form1.Img1.Width := Screen.Width;
  Form1.Img1.Height := Screen.Height;
  Form1.Img1.Picture.Assign(bmp);
  bmp.Free;
end;

procedure ballPositionSet;
var
  i: Counter;
  k: Integer;
  n: Boolean;
  a, b: real;
begin
  Randomize;
  for i := 0 to 9 do
  begin
    repeat //генерим координаты шара, пока он не попадет внутрь окна на свободное место от других шаров
      masPosX[i] := Random(form1.ClientWidth);
      masPosY[i] := Random(form1.ClientHeight);
      n := False;
      for k := 0 to i - 1 do //проверка с шарами
      begin
        //находим расстояние между двумя шариками (точками)
        a := MasPosX[i] - MasPosX[k];
        b := MasPosY[i] - MasPosY[k];
        if sqrt(sqr(a) + sqr(b)) <= 241 then   //формула: квадратный sqrt(sqr(x2-x1)+sqr(y2-y1))
          n := True;
      end;
      if (masPosX[i] > form1.ClientWidth - form1.Shp1.Width) or (masPosX[i] < 0) or //проверка с краем
        (masPosY[i] > form1.ClientHeight - form1.Shp1.Width) or (masPosY[i] < 0) then
        n := True;

    until n = False;
    masVelX[i] := RandomRange(1, 6) - 3 + speed; //скорость чтобы в разные стороны могла быть
    masVelY[i] := RandomRange(1, 6) - 3 + speed;
    if masVelx[i] = 0 then
      masVelx[i] := -1;
    if masVelY[i] = 0 then
      masVelY[i] := 1;
  end;
end;

procedure ballsVisibleTR;  //если добавляют шары делаем их видимыми
var
  i: Counter;
begin
  for i := 0 to BallCount - 1 do
  begin
    Ball[i].Visible := True;
  end;
end;

procedure ballsPos;
var
  i: Counter;
begin
  for i := 0 to BallCount - 1 do
  begin
    Ball[i].Left := Round(masPosX[i]);
    Ball[i].Top := Round(masPosY[i]);
  end;
end;

procedure ballsVisibleFL; //если шары отключают, делаем их невидимыми
var
  i: Counter;
begin
  for i := ballcount to 9 do
  begin
    Ball[i].Visible := False;
  end;
end;

procedure bumpWalls; //столкновения со стенками
var
  i: Cardinal;
begin
  with Form1 do
  begin
    for i := 0 to BallCount - 1 do
    begin
      masPosX[i] := masPosX[i] + masVelX[i]; //шаг по Х
      masPosY[i] := masPosY[i] + masVelY[i]; //шаг по У

      if masPosX[i] > ClientWidth - Shp1.Width then
      begin
        masPosX[i] := ClientWidth - Shp1.Width;
        masVelX[i] := -masVelX[i];
      end
      else if masPosX[i] < 0 then
      begin
        masPosX[i] := 0;
        masVelX[i] := -masVelX[i];
      end;
      if masPosY[i] > ClientHeight - Shp1.Width then
      begin
        masPosY[i] := ClientHeight - Shp1.Width;
        masVelY[i] := -masVelY[i];
      end
      else if masPosY[i] < 0 then
      begin
        masPosY[i] := 0;
        masVelY[i] := -masVelY[i];
      end;
    end;
  end;
end;

procedure bumpEachOther;  //столкновения друг с другом
var
  h0, h1, j: Cardinal;
  a, b, dist, bet, x1, x2, y1, y2: extended;
  n: integer;
  xx0, yy0, xx1, yy1: single;
begin
  for h0 := 0 to ballcount - 1 do
  begin
    for h1 := 0 to ballcount - 1 do
      if h0 <> h1 then
      begin
        //вычисляем расстояние между шариками
        a := MasPosX[h0] + MasVelX[h0] - MasPosX[h1] - MasVelX[h1];
        b := MasPosY[h0] + MasVelY[h0] - MasPosY[h1] - MasVelY[h1];
        dist := sqrt(sqr(a) + sqr(b));
        if dist <= 241 then  //если удар то
        begin
          //СМЕНА НАПРАВЛЕНИЯ
          bet := arctan2(MasPosY[h1] - MasPosY[h0], MasPosX[h1] - MasPosX[h0]);
          //вычисляем углы удара
          x1 := masvelx[h0] * cos(-bet) - MasVelY[h0] * sin(-bet);
          y1 := MasVelX[h0] * sin(-bet) + MasVelY[h0] * cos(-bet);
          x2 := MasVelX[h1] * cos(-bet) - MasVelY[h1] * sin(-bet);
          y2 := MasVelX[h1] * sin(-bet) + MasVelY[h1] * cos(-bet);
          //направляем шарики в противоположные углы
          MasVelX[h0] := x2 * cos(bet) - y1 * sin(bet);
          MasVelY[h0] := x2 * sin(bet) + y1 * cos(bet);
          masVelX[h1] := x1 * cos(bet) - y2 * sin(bet);
          MasVelY[h1] := x1 * sin(bet) + y2 * cos(bet);
          n := 0;
          xx0 := masvelx[h0];
          yy0 := masvely[h0];
          xx1 := masvelx[h1];
          yy1 := masvely[h1];
          repeat  //пытаемся раздвинуть шары,
            MasPosX[h0] := MasPosX[h0] + xx0 * 0.0011;
            MasPosY[h0] := MasPosY[h0] + yy0 * 0.0011;
            MasPosX[h1] := MasPosX[h1] + xx1 * 0.0011;
            MasPosY[h1] := MasPosY[h1] + yy1 * 0.0011;
            a := MasPosX[h0] - MasPosX[h1];
            b := MasPosY[h0] - MasPosY[h1];
            dist := sqrt(sqr(a) + sqr(b));
            inc(n);
          until (dist > 241) or (n > 50000);

        end;
      end;

    MasPosX[h0] := MasPosX[h0] + MasVelX[h0] * 0.001;
    MasPosY[h0] := MasPosY[h0] + MasVelY[h0] * 0.001;
  end;
end;

//ФОРМЫ ШАРИКОВ

procedure setBallsSquares;  //сделать из шариков квадратики
var
  i: Counter;
begin
  for i := 0 to BallCount - 1 do
  begin
    Ball[i].Shape := stSquare;
  end;
end;

procedure setBallsCircles;  //сделать шарики круглыми
var
  i: Counter;
begin
  for i := 0 to BallCount - 1 do
  begin
    Ball[i].Shape := stCircle;
  end;
end;

//ТЕКСТУРЫ

procedure setDiagonalLinesLeft;  //сделать текстуру Диагональные линии(Л)
var
  i: Counter;
begin
  for i := 0 to BallCount - 1 do
  begin
    Ball[i].Brush.Style := bsBDiagonal;
  end;
end;

procedure setDiagonalLinesRight; //сделать текстуру Диагональные линии (П)
var
  i: Counter;
begin
  for i := 0 to BallCount - 1 do
  begin
    Ball[i].Brush.Style := bsFDiagonal;
  end;
end;

procedure setCrossLines;  //сделать текстуру Крестики
var
  i: Counter;
begin
  for i := 0 to BallCount - 1 do
  begin
    Ball[i].Brush.Style := bsCross;
  end;
end;

procedure setDiagonalCrossLines;  //сделать текстуру Диагональные крестики
var
  i: Counter;
begin
  for i := 0 to BallCount - 1 do
  begin
    Ball[i].Brush.Style := bsDiagCross;
  end;
end;

procedure setHorizontalLines;  //сделать текстуру Горизонтальные линии
var
  i: Counter;
begin
  for i := 0 to BallCount - 1 do
  begin
    Ball[i].Brush.Style := bsHorizontal;
  end;
end;

procedure setVerticalLines;  //сделать текстуру Вертикальные линии
var
  i: Counter;
begin
  for i := 0 to BallCount - 1 do
  begin
    Ball[i].Brush.Style := bsVertical;
  end;
end;

procedure setTextureNone;  //убрать текстуру (сделать прозрачным)
var
  i: Counter;
begin

  for i := 0 to BallCount - 1 do
  begin
    Ball[i].Brush.Style := bsClear;
  end;
end;

procedure setTextureSolid;   //текстуры нет (заливка выбранным цветом)
var
  i: Counter;
begin
  for i := 0 to BallCount - 1 do
  begin
    Ball[i].Brush.Style := bsSolid;
  end;
end;

//ЦВЕТА

procedure BallBrushColor(Bcolor: TColor);
var
  i: Counter;
begin
  if Bcolor = 1337 then    //невидимый цвет (прозрачный)
  begin
    for i := 0 to BallCount-1 do
    begin
      Ball[i].Brush.Style := bsClear;
    end;
  end
  else
  begin
    for i := 0 to BallCount-1 do
    begin
      Ball[i].Brush.Color := Bcolor;
    end;
  end;

end;

procedure BallPenColor(Pcolor: TColor);  //цвет рамки
var
  i: Counter;
begin
  for i := 0 to BallCount-1 do
  begin
    Ball[i].Pen.Color := Pcolor;
  end;
end;

//ТЕКСТУРА

procedure BallTexture(num: Cardinal);
begin
  with form2 do
  begin
    if num = 0 then
      setTextureSolid;
    if num = 1 then
      setDiagonalLinesLeft;
    if num = 2 then
      setDiagonalLinesRight;
    if num = 3 then
      setCrossLines;
    if num = 4 then
      setDiagonalCrossLines;
    if num = 5 then
      setHorizontalLines;
    if num = 6 then
      setVerticalLines;
    if num = 7 then
      setTextureNone;
  end;
end;

//ТОЛЩИНА РАМКИ

procedure BallPenWidth(width: Cardinal);
var
  i: Counter;
begin
  for i := 0 to BallCount-1 do
  begin
    Ball[i].Pen.Style := psSolid;
    Ball[i].Pen.Width := width;
  end;
end;


//УБРАТЬ РАМКУ

procedure delBallPen;
var
  i: Counter;
begin
  for i := 0 to BallCount-1 do
  begin
    Ball[i].Pen.Style := psClear;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Sleep(150);  //ждем 1.5 секунды, чтоб успела закрыться форма 2 и не попала в скриншот

  //создаем файл со стандартными настройками, если такого нет
  ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'settings.ini');
  //извлекаем настройки из файла
  BallCount := ini.ReadInteger('Дополнительно', 'Количество', 5);
  BGColor := ini.ReadInteger('Общее', 'Цвет фона', 0);
  PenColor := ini.ReadInteger('Общее', 'Цвет рамки', 0);
  BrushColor := ini.ReadInteger('Общее', 'Цвет заливки', 1337);
  TextureNumber := ini.ReadInteger('Общее', 'Текстура', 0);
  PenEn := ini.ReadBool('Общее', 'Рамка', True);
  PenWidth := ini.ReadInteger('Общее', 'Толщина рамки', 2);
  circles := ini.ReadInteger('Дополнительно', 'Шарики', 0);
  screenshot := ini.ReadInteger('Дополнительно', 'Без фона', 1);
  speed := ini.ReadInteger('Дополнительно', 'Скорость', 2);

  Memory;  //выделяем память и заполняем массив
  DoubleBuffered := True;  //включаем двойную буферизацию

  BallBrushColor(BrushColor);  //цвет шаров
  BallPenColor(PenColor); //цвет рамки
  BallTexture(TextureNumber); //текстура

  if PenEn = False then  //удалить рамку
    delBallPen
  else
    BallPenWidth(PenWidth); //ширина рамки

  if circles = 0 then
    setBallsCircles     //шарики
  else
    setBallsSquares;   //квадратики

  form1.Color := BGColor; //фон
  Form1.BorderStyle := bsNone; //без бордюров
  Form1.ClientHeight := Screen.Height; //по размеру экрана
  Form1.ClientWidth := Screen.Width;  //по ширине экрана
  Form1.Position := poScreenCenter; //по центру


  if screenshot = 1 then
  begin
    createScreenShot;      //скриншот на задний фон (если без фона)
    img1.Visible := True;
  end
  else
    img1.Visible := False;     //цвет формы

  showcursor(false); //без курсосра

  ballsVisibleFL; //прячем неиспользуемые шарики
  ballsVisibleTR; //показываем используемые шарики
  ballPositionSet;  //расставляем шарики по экрану
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //СОХРАНЯЕМ НАСТРОКИ при закрытии
  ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'settings.ini');
  ini.WriteInteger('Общее', 'Цвет фона', BGColor);
  ini.WriteInteger('Общее', 'Цвет рамки', PenColor);
  ini.WriteInteger('Общее', 'Цвет заливки', BrushColor);
  ini.WriteInteger('Общее', 'Текстура', TextureNumber);
  ini.WriteBool('Общее', 'Рамка', PenEn);
  ini.WriteInteger('Общее', 'Толщина рамки', PenWidth);
  ini.WriteInteger('Дополнительно', 'Количество', BallCount);
  ini.WriteInteger('Дополнительно', 'Шарики', circles);
  ini.WriteInteger('Дополнительно', 'Без фона', screenshot);
  ini.WriteInteger('Дополнительно', 'Скорость', speed);
end;

procedure ballPenRandom;   //рандомный цвет шариков
var
  i: Counter;
begin
  for i := 0 to 9 do
  begin
    if form2.clrbx2.ItemIndex = 16 then
    begin
      Ball[i].Pen.Color := Random($FFFFFF);
    end;

  end;
end;

procedure TForm1.BallsFly;
begin
  ballsPos; //делаем шаг
  bumpWalls; //проверка на удары об стену
  bumpEachOther; //проверка на удары друг об друга
  ballPenRandom; //рандомная рамка (если включено)
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  //открытие настроек по комбинации клавиш (CTRL + TAB)
  if (GetKeyState(ord(VK_CONTROL)) < 0) then
  begin
    if (GetKeyState(ord(VK_TAB)) < 0) then
    begin
      form2.show;
      showcursor(true);
    end;
  end
  else
  begin
    Application.Terminate;
  end;

end;

procedure TForm1.FormClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.tmr1Timer(Sender: TObject);
begin
  BallsFly;
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  //Application.Terminate;
end;

procedure TForm1.img1Click(Sender: TObject);
begin
  form1.Close;
end;

end.

