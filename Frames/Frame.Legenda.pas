unit Frame.Legenda;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation;

  {
    TituloConta: string;
    ValorTotal, Porcentagem: Currency;
    Cor: TAlphaColor
  }

type
  TTipoContaFrame = class
  private
    FIdTipoConta: Integer;
    FTituloConta: string;
    FValorTotal: Currency;
    FPorcentagem: Currency;
    FCor: TAlphaColor;
  public
    property IdTipoConta: Integer read FIdTipoConta write FIdTipoConta;
    property TituloConta: string read FTituloConta write FTituloConta;
    property ValorTotal: Currency read FValorTotal write FValorTotal;
    property Porcentagem: Currency read FPorcentagem write FPorcentagem;
    property Cor: TAlphaColor read FCor write FCor;
  end;

  TFrameLegenda = class(TFrame)
    Circulo: TCircle;
    lblTipoConta: TLabel;
    Line1: TLine;
    lblValorTotal: TLabel;
    lblPorcentagem: TLabel;
    Rectangle1: TRectangle;
    RectProgressBar: TRectangle;
    progressBar: TRectangle;
  private
    { Private declarations }
    FTipoContaFrame: TTipoContaFrame;
    FDataInicial: TDateTime;
    FDataFinal:   TDateTime;
    {$IFDEF MSWINDOWS}
      procedure Click(Sender: TObject);
    {$ELSE}
      procedure Click(Sender: TObject; const Point: TPointF);
    {$ENDIF}
  public
    { Public declarations }
    procedure SetColorProgressBar(Porcentagem: Currency; Cor: TAlphaColor);
    constructor Create(AOwner: TComponent; TipoContaFrame: TTipoContaFrame;
                      dataInicial, dataFinal: TDateTime);
  end;

implementation

uses
  UF_RelatorioTipoContasDetalhado;

{$R *.fmx}

{ TFrameLegenda }
{$IFDEF MSWINDOWS}
  procedure TFrameLegenda.Click(Sender: TObject);
{$ELSE}
  procedure TFrameLegenda.Click(Sender: TObject; const Point: TPointF);
{$ENDIF}
begin
  if not Assigned(F_RelatorioTipoDeContasDetalhado) then
    F_RelatorioTipoDeContasDetalhado := TF_RelatorioTipoDeContasDetalhado.Create(Self,
                                                                                 FTipoContaFrame,
                                                                                 FdataInicial,
                                                                                 FDataFinal);
  F_RelatorioTipoDeContasDetalhado.Show;
end;

constructor TFrameLegenda.Create(AOwner: TComponent;
  TipoContaFrame: TTipoContaFrame; dataInicial, dataFinal: TDateTime);
begin
  inherited Create(AOwner);
  {$IFDEF MSWINDOWS}
    OnClick := Click;
  {$ELSE}
    OnTap   := Click;
  {$ENDIF}
  FDataInicial        := dataInicial;
  FDataFinal          := dataFinal;
  FTipoContaFrame     := TipoContaFrame;
  Tag                 := TipoContaFrame.IdTipoConta;
  Circulo.Fill.Color  := TipoContaFrame.Cor;
  lblTipoConta.Text   := TipoContaFrame.TituloConta;
  lblValorTotal.Text  := FormatFloat('R$ #,##.00', TipoContaFrame.ValorTotal);
  SetColorProgressBar(TipoContaFrame.Porcentagem, TipoContaFrame.Cor);
  lblPorcentagem.Text := FormatFloat('##0.0', TipoContaFrame.Porcentagem) + '%';
end;

procedure TFrameLegenda.SetColorProgressBar(Porcentagem: Currency;
  Cor: TAlphaColor);
var
  ValorMaximo: Single;
begin
  ValorMaximo := RectProgressBar.Width;
  progressBar.Width := ValorMaximo * (Porcentagem / 100);
  progressBar.Fill.Color := Cor;
end;

end.
