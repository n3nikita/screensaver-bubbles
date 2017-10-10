program Project1;

uses
  Forms,
  Graphics,
  Windows,
  Messages,
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {Form2};



{$E scr}

{$R *.res}

begin

//     no params -> Context menu -> Configure
//    /p HWND   -> preview; hwnd - parent window
//    /c:HWND   -> Configure, parent - modal
//    /s - view

  if (paramCount = 0) then
  begin
    Application.Initialize;
    Application.Title := 'Bubbles';
  Application.CreateForm(TForm1, Form1);
    Application.CreateForm(TForm2, Form2);
    Application.Run;
  end
  else if {(paramCount = 2) and} (CharLower(PChar(ParamStr(1))) = '/p') then
  begin
    Application.Initialize;
    Application.CreateForm(TForm1, Form1);
    Form1.Width:= 0;
    Application.CreateForm(TForm2, Form2);
    form2.Show;
    ShowCursor(True);
    Application.Run;
  end
  else if {(ParamCount = 1) and} (CharLower(PChar(ParamStr(1))) = '/s') then
  begin
    Application.Initialize;
    Application.CreateForm(TForm1, Form1);
    Application.CreateForm(TForm2, Form2);
    Application.Run;
  end;

end.

