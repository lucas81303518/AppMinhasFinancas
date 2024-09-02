unit Frame.MetasFormPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, ReadMeta;

type
  TFrameMetasFormPrincipal = class(TFrame)
    Rectangle1: TRectangle;
    RectProgressBar: TRectangle;
    progressBar: TRectangle;
    lblNomeMeta: TLabel;
    procedure RectProgressBarResize(Sender: TObject);
  private
    FMeta: TReadMeta;
    FPorcentagem: Currency;
    procedure SetNomeMeta(const Value: string);
    procedure SetCor(const Value: Int64);
    procedure SetPorcentagem(const Value: Currency);
    procedure SetMeta(const Value: TReadMeta);
  public
    { Public declarations }
    property Meta: TReadMeta read FMeta write SetMeta;
    property Porcentagem: Currency read FPorcentagem write SetPorcentagem;

  end;

implementation

{$R *.fmx}

procedure TFrameMetasFormPrincipal.RectProgressBarResize(Sender: TObject);
begin
  SetPorcentagem(FPorcentagem);
end;

procedure TFrameMetasFormPrincipal.SetCor(const Value: Int64);
begin
  progressBar.Fill.Color := Value;
end;

procedure TFrameMetasFormPrincipal.SetMeta(const Value: TReadMeta);
begin
  FMeta := Value;
  SetCor(FMeta.Cor);
  SetNomeMeta(FMeta.Descricao);
end;

procedure TFrameMetasFormPrincipal.SetNomeMeta(const Value: string);
begin
  lblNomeMeta.Text := Value;
end;

procedure TFrameMetasFormPrincipal.SetPorcentagem(const Value: Currency);
var
  ValorMaximo: Single;
begin
  FPorcentagem := Value;
  ValorMaximo := RectProgressBar.Width;
  progressBar.Width := ValorMaximo * (Porcentagem / 100);
  if progressBar.Width < 20 then
    progressBar.Width := 20;
end;

end.
