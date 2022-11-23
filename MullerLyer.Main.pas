unit MullerLyer.Main;

{
   Dynamic Müller-Lyer Illusion implementation with Delphi Alexandria (c)2022 by Paul TOTH
   https://github.com/tothpaul

  https://www.giannisarcone.com/Muller_lyer_illusion.html
  Copyright © G. Sarcone

  Pointed out by Albert Moukheiber !
  https://www.facebook.com/513735070/videos/834999877744145/

}
interface

uses
{$IFDEF MSWINDOWS}
  Winapi.Windows,
  Winapi.ShellAPI,
{$ENDIF}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.Math,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Ani,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Layout1: TLayout;
    VertScrollBox1: TVertScrollBox;
    Line1: TLine;
    FloatAnimation1: TFloatAnimation;
    Line2: TLine;
    Line3: TLine;
    Line4: TLine;
    Line5: TLine;
    Line6: TLine;
    LineA: TLine;
    LineB: TLine;
    Label2: TLabel;
    Layout2: TLayout;
    procedure FloatAnimation1Process(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label2Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.FloatAnimation1Process(Sender: TObject);
begin
  var Time := FloatAnimation1.NormalizedTime;
  Line2.RotationAngle :=  135 - 90 * Time;
  Line3.RotationAngle :=  -45 - 90 * Time;
  Line4.RotationAngle :=   45 + 90 * Time;
  Line5.RotationAngle := -135 + 90 * Time;
  Line6.RotationAngle :=  135 - 90 * Time;
end;

function NewLine(Parent: TFmxObject; Width, Thickness, X, Y: Single; Color: TAlphaColor = TAlphaColors.Black): TLine;
begin
  Result := TLine.Create(Parent);
  Result.LineType := TLineType.Top;
  Result.Stroke.Thickness := Thickness;
  Result.Stroke.Color := Color;
  Result.Width := Width;
  Result.Height := Thickness;
  Result.Position.X := X;
  Result.Position.Y := Y;
  Result.RotationCenter.X := 0;
  Result.RotationCenter.Y := 0;
  Result.Parent := Parent;
end;

function NewLine2(Parent: TFmxObject; Width, X, Y, ScaleX: Single): TLine;
begin
  Result := TLine.Create(Parent);
//  Result.LineType := TLineType.Diagonal; // default
  Result.Stroke.Thickness := 2;
  Result.Stroke.Color := TAlphaColors.Gray;
  Result.Width := Width;
  Result.Height := Width;
  Result.Position.X := X;
  Result.Position.Y := Y;
  Result.Scale.X := ScaleX;
  Result.Parent := Parent;
end;

function AnimateScale(Line: TLine; Start, Stop, Duration, Delay: Single): TFloatAnimation;
begin
  Result := TFloatAnimation.Create(Line);
  Result.StartValue := Start;
  Result.StopValue := Stop;
  Result.AutoReverse := True;
  Result.Loop := True;
  Result.Duration := Duration;
  Result.Delay := Delay;
  Result.Parent := Line;
  Result.PropertyName := 'Scale.Y';
  Result.Enabled := True;
end;

function Animate2Line(Line: TLine; Start, Stop, Duration, Delay: Single): TFloatAnimation;
begin
  Result := TFloatAnimation.Create(Line);
  Result.StartValue := Start;
  Result.StopValue := Stop;
  Result.AutoReverse := True;
  Result.Loop := True;
  Result.Duration := Duration;
  Result.Delay := Delay;
  Result.Parent := Line;
  Result.PropertyName := 'RotationAngle';
  Result.Enabled := True;
end;

procedure AnimateLine(Line: TLine; Start, Stop: Single);
begin
  Animate2Line(Line, Start, Stop, 3, 0);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  for var i := 0 to 9 do
  begin
    var A := 90 - i * 360 / 10;
    var S, C: Single;
    SinCos(A * PI/180, S, C);
    var L := TLayout.Create(Self);
    L.Parent := Layout1;
    L.Position.X := 250 + 140 * C;
    L.Position.Y := 250 + 140 * S;
    L.Width := 1;
    L.Height := 1;
    L.ClipChildren := FAlse;
    L.RotationCenter.X := 0;
    L.RotationCenter.Y := 0;
    L.RotationAngle := A;

    NewLine(L, 80, 2, -80, 0);
    NewLine(L, 80, 2, 0, 0, TAlphaColors.Blue);

    var K := 18;

    AnimateLine(NewLine(L, K, 2, -80, 0), +135, +45);
    AnimateLine(NewLine(L, K, 2, -80, 0), -135, -45);
    AnimateLine(NewLine(L, K, 2, 0, 0), +45, +135);
    AnimateLine(NewLine(L, K, 2, 0, 0), -45, -135);
    AnimateLine(NewLine(L, K, 2, +80, 0), +135, +45);
    AnimateLine(NewLine(L, K, 2, +80, 0), -135, -45);
  end;

  var count := 30;
  for var i := 0 to count - 1 do
  begin
    var X := (i + 1) * Layout2.Width / (count + 1);

    var L := 80;

    NewLine(Layout2, L, 2, x, 10, TAlphaColors.Red).RotationAngle := 90;
    NewLine(Layout2, L, 2, x, 10 + L, TAlphaColors.Blue).RotationAngle := 90;
    NewLine(Layout2, L, 2, x, 10 + 2 * L, TAlphaColors.Red).RotationAngle := 90;
    NewLine(Layout2, L, 2, x, 10 + 3 * L, TAlphaColors.Blue).RotationAngle := 90;

    var duration := 1;
    var delay := 2 * i / count;
    var width := 500 / count / 2;
    var K := 3;

    AnimateScale(NewLine2(Layout2, width, x, 10, +1), +K, -K, duration, delay);
    AnimateScale(NewLine2(Layout2, width, x, 10, -1), +K, -K, duration, delay);
    AnimateScale(NewLine2(Layout2, width, x, 10 + L, +1), -K, +K, duration, delay);
    AnimateScale(NewLine2(Layout2, width, x, 10 + L, -1), -K, +K, duration, delay);
    AnimateScale(NewLine2(Layout2, width, x, 10 + 2 * L, +1), +K, -K, duration, delay);
    AnimateScale(NewLine2(Layout2, width, x, 10 + 2 * L, -1), +K, -K, duration, delay);
    AnimateScale(NewLine2(Layout2, width, x, 10 + 3 * L, +1), -K, +K, duration, delay);
    AnimateScale(NewLine2(Layout2, width, x, 10 + 3 * L, -1), -K, +K, duration, delay);
    AnimateScale(NewLine2(Layout2, width, x, 10 + 4 * L, +1), +K, -K, duration, delay);
    AnimateScale(NewLine2(Layout2, width, x, 10 + 4 * L, -1), +K, -K, duration, delay);
  end;
end;

procedure TForm1.Label2Click(Sender: TObject);
begin
{$IFDEF MSWINDOWS}
  ShellExecute(0, 'open', PChar(Label2.Text), nil, nil, SW_SHOW);
{$ENDIF}
end;


end.
