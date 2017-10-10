unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls, Unit1, ComCtrls, XPMan, Menus, IniFiles,
  jpeg;

type
  TForm2 = class(TForm)
    clrbx1: TColorBox;
    clrbx2: TColorBox;
    clrbx3: TColorBox;
    btn4: TButton;
    TrackBar1: TTrackBar;
    edt1: TEdit;
    ud1: TUpDown;
    btn1: TButton;
    grp1: TGroupBox;
    grp2: TGroupBox;
    grp3: TGroupBox;
    grp4: TGroupBox;
    pgc1: TPageControl;
    ts1: TTabSheet;
    ts2: TTabSheet;
    ts4: TTabSheet;
    grp5: TGroupBox;
    rg1: TRadioGroup;
    cbb1: TComboBox;
    grp6: TGroupBox;
    ud2: TUpDown;
    edt2: TEdit;
    grp7: TGroupBox;
    rg2: TRadioGroup;
    img1: TImage;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    chk1: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btn4Click(Sender: TObject);

    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;
  clrBxMas: array[0..2] of TColorBox;


implementation

{$R *.dfm}


procedure ballCountSet;
begin
  with Form2 do
  begin
    BallCount := StrToInt(edt1.Text);
  end;
end;

procedure speedChange;  //меняем скорость (к основной прибавляется выбранная пользователем)
var
  i: Counter;
begin
  speed := Form2.TrackBar1.Position;
  for i := 0 to 9 do
  begin
    masVelX[i] := masvelx[i] + speed;
    masVelY[i] := masvely[i] + speed;
  end;
end;

procedure toDefault;  //сброс настроек к стандартным
var
  i, j: Counter;
begin

  Form2.edt1.text := IntToStr(5);
  Form2.edt2.text := IntToStr(2);
  if speed <> 2 then
  begin
    Form2.TrackBar1.Position := 2;
    speed := 2;
    for j := 0 to 9 do
    begin
      masVelX[j] := speed;
      masVelY[j] := speed;
    end;
  end;

  form1.Color := clBlack;
  for i := 0 to 9 do
  begin
    if i <= 2 then
    begin

      clrBxMas[i].Selected := clBlack;
      if i = 1 then
        clrBxMas[i].Selected := clBlack;

      if i = 2 then
        clrBxMas[i].ItemIndex := 16;

    end;

    Ball[i].Pen.Color := clBlack;
    Ball[i].Brush.Style := bsClear;
    BallCount := 5;
  end;
  form2.rg1.ItemIndex := 0;
  form2.cbb1.ItemIndex:= 7;
  form2.chk1.Checked:= True;
  BallPenWidth(2);
  ballsVisibleFL;
  setBallsCircles;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  clrbx3.Items.Add('None');
  clrbx2.Items.Add('Random');
  ud1.Associate := edt1;
  ud1.Position := ini.ReadInteger('Дополнительно', 'Количество', 5);
  clrbx1.Selected := ini.ReadInteger('Общее', 'Цвет фона', BGColor);
  clrbx2.Selected := ini.ReadInteger('Общее', 'Цвет рамки', PenColor);
  if BrushColor = 1337 then   //цвет залики не выбран, стави прозрачный (1337)
    clrbx3.ItemIndex := 16
  else
    clrbx3.Selected := ini.ReadInteger('Общее', 'Цвет заливки', BrushColor);
  Form2.cbb1.ItemIndex := ini.ReadInteger('Общее', 'Текстура', TextureNumber);
  ud2.Associate := edt2;
  chk1.Checked:= ini.ReadBool('Общее', 'Рамка', PenEn);
  ud2.Position := ini.ReadInteger('Общее', 'Толщина рамки', 2);
  rg1.ItemIndex := ini.ReadInteger('Дополнительно', 'Шарики', circles);
  rg2.ItemIndex := ini.ReadInteger('Дополнительно', 'Без фона', 1);
  TrackBar1.Position := ini.ReadInteger('Дополнительно', 'Скорость', speed);

  form2.Position := poScreenCenter;  //форма по центру

  //заносим colorBox в массив для удобства использования
  clrBxMas[0] := clrbx1;
  clrBxMas[1] := clrbx2;
  clrBxMas[2] := clrbx3;

end;



procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //сохраняем настроки при закрытии формы
  ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'settings.ini');
  ini.WriteInteger('Общее', 'Цвет фона', Form2.clrbx1.ItemIndex);
  ini.WriteInteger('Общее', 'Цвет рамки', Form2.clrbx2.Selected);
  if clrbx3.ItemIndex = 16 then
    ini.WriteInteger('Общее', 'Цвет заливки', 1337)
  else
  ini.WriteInteger('Общее', 'Цвет заливки', Form2.clrbx3.Selected);
  ini.WriteInteger('Общее', 'Текстура', Form2.cbb1.ItemIndex);
  ini.WriteBool('Общее', 'Рамка', form2.chk1.Checked);
  ini.WriteInteger('Общее', 'Толщина рамки', StrToInt(Form2.edt2.Text));
  ini.WriteInteger('Дополнительно', 'Количество', StrToInt(Form2.edt1.Text));
  ini.WriteInteger('Дополнительно', 'Шарики', form2.rg1.ItemIndex);
  ini.WriteInteger('Дополнительно', 'Без фона', form2.rg2.ItemIndex);
  ini.WriteInteger('Дополнительно', 'Скорость', Form2.TrackBar1.Position);
end;

procedure TForm2.btn4Click(Sender: TObject);
begin
  toDefault;  //сброс настроек
end;


procedure TForm2.btn1Click(Sender: TObject);
begin
  speedChange;   //задаем скорость
  Form2.Close;
  if paramCount = 2 then
    form1.Close
  else
    Form1.FormCreate(Sender);
end;







end.

