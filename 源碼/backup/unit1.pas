unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    lblScore: TLabel;
    lblGG: TLabel;
    lblReStart: TLabel;
    Paddle: TShape;
    Ball: TShape;
    GameTmr: TTimer;
    procedure controlPaddle(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure GameTime(Sender: TObject);
    procedure lblReStartMouseEnter(Sender: TObject);
    procedure lblReStartMouseLeave(Sender: TObject);
    procedure PaddleMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure reStartOnClick(Sender: TObject);
  private

  public
    procedure InitGame;
    procedure UpdateScore;
    procedure GameOver;
    procedure IncSpeed;
    procedure changColor;
  end;

var
  Form1: TForm1;
  Score:Integer;
  speedX, speedY:Integer;

implementation

{$R *.lfm}

{ TForm1 }

// 當開始執行程式時
procedure TForm1.FormCreate(Sender: TObject);
begin
  DoubleBuffered:=True;
  InitGame;
end;

// 遊戲計時器
procedure TForm1.GameTime(Sender: TObject);
begin
  Ball.Left:=Ball.Left + speedX;
  Ball.Top:=Ball.Top + speedY;
  changColor;

  if Ball.Top <= 0 then speedY:=-speedY;
  if (Ball.Left <= 0) or (Ball.Left + Ball.Width > ClientWidth) then speedX:=-speedX;

  if Ball.Top + Ball.Height >= ClientHeight then GameOver;

  if (Ball.Left + Ball.Width >= Paddle.Left) and (Ball.Left <= Paddle.Left + Paddle.Width)
  and (Ball.Top + Ball.Height >= Paddle.Top) then
  begin
    speedY:=-speedY;

    IncSpeed;
    Inc(Score);
    UpdateScore;
  end;
end;

// 當滑鼠碰到字體時 字體變粗
procedure TForm1.lblReStartMouseEnter(Sender: TObject);
begin
  lblReStart.Font.Style:=[fsBold];
end;

// 當滑鼠離開字體時 字體變細
procedure TForm1.lblReStartMouseLeave(Sender: TObject);
begin
  lblReStart.Font.Style:=[];
end;

// 當滑鼠點擊時
procedure TForm1.reStartOnClick(Sender: TObject);
begin
  InitGame;
end;

// ********************************************* 控制擋板
procedure TForm1.controlPaddle(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Paddle.Left:=X - Paddle.Width div 2;
  Paddle.Top:=ClientHeight - Paddle.Height - 2;
end;

procedure TForm1.PaddleMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  controlPaddle(Sender, Shift, X+Paddle.Left, Y+Paddle.Top);
end;

// 初始化遊戲
procedure TForm1.InitGame;
begin
  Randomize;

  Score:=0;
  speedX:=4;
  speedY:=4;

  Ball.Left:=Random(471) + 30;
  Ball.Top:=70;

  lblGG.Visible:=False;
  lblReStart.Visible:=False;
  lblReStart.Font.Style:=[];
  GameTmr.Enabled:=True;

  UpdateScore;
end;

// 更新分數
procedure TForm1.UpdateScore;
begin
  lblScore.Caption:='分數：' + IntToStr(Score);
end;

// 遊戲結束
procedure TForm1.GameOver;
begin
  GameTmr.Enabled:=False;

  lblGG.Visible:=True;
  lblReStart.Visible:=True;
end;

// 加快速度
procedure TForm1.IncSpeed;
begin
  if speedX > 0 then Inc(speedX) else Dec(speedX);
  if speedY > 0 then Inc(speedY) else Dec(speedY);
end;

// 改變球的顏色
procedure TForm1.changColor;
var
  Num:Integer;
begin
  Num:=Random(5);

  case Num of
  0:Ball.Brush.Color:=RGBToColor(255, 0, 0);
  1:Ball.Brush.Color:=RGBToColor(255, 255, 0);
  2:Ball.Brush.Color:=RGBToColor(102, 255, 51);
  4:Ball.Brush.Color:=RGBToColor(0, 255, 255);
  else Ball.Brush.Color:=clWhite;
  end;
end;

end.

