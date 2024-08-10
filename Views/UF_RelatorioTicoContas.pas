unit UF_RelatorioTicoContas;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UF_BaseMenu, FMX.Controls.Presentation, FMX.Objects, FMX.Layouts,
  FMXTee.Engine, FMXTee.Procs, FMXTee.Chart, FMX.Controls3D, FMXTee.Chart3D,
  FMX.DateTimeCtrls, Controller.Documento, Model.Documentos, Generics.Collections,
  FMX.ListBox, Frame.Legenda;

type
  TF_RelatorioTipoContas = class(TF_BaseMenu)
    Layout1: TLayout;
    imageVoltar: TImage;
    layoutGrafico: TLayout;
    circuloCentral: TCircle;
    Layout3: TLayout;
    Label1: TLabel;
    dataInicial: TDateEdit;
    dataFinal: TDateEdit;
    Tipo: TGroupBox;
    rbSaida: TRadioButton;
    rbEntrada: TRadioButton;
    lbLegendaItens: TListBox;
    layoutTop: TLayout;
    LayoutCentralizaPeriodo: TLayout;
    Layout2: TLayout;
    lblTitulo: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rbEntradaClick(Sender: TObject);
    procedure rbSaidaClick(Sender: TObject);
    procedure dataInicialChange(Sender: TObject);
    procedure dataFinalChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure dataInicialExit(Sender: TObject);
    procedure dataFinalExit(Sender: TObject);
    procedure imageVoltarClick(Sender: TObject);
    procedure dataInicialClosePicker(Sender: TObject);
    procedure dataFinalClosePicker(Sender: TObject);
  private
    { Private declarations }
    FDocumentoController: TControllerDocumento;
    FListaTotaisTipoConta: TObjectList<TReadTipoContaTotalDocs>;
    TipoDoc: Integer;

    function CalculaCentroGrafico: Single;
    procedure MontaGrafico;
    procedure LimpaLayout(Layout: TLayout);
    procedure AddLegenda(TipoContaFrame: TTipoContaFrame);
  public
    { Public declarations }
  end;

var
  F_RelatorioTipoContas: TF_RelatorioTipoContas;

implementation

uses
  Math;

const PIE_MARGIN_LEFT_RIGHT = 80;
const VALOR_MAXIMO_GRAFICO = 360;

const
  PASTEL_COLORS: array[0..49] of TAlphaColor = (
    $FFFFC1C1, // Light Pink
    $FFFFD1DC, // Light Pinkish Red
    $FFFFF1C1, // Light Yellow
    $FFC1FFD1, // Light Green
    $FFC1FFFF, // Light Cyan
    $FFC1DFFF, // Light Blue
    $FFC1C1FF, // Light Purple
    $FFFFC1FF, // Light Magenta
    $FFFFDCC1, // Light Peach
    $FFFFF1E6, // Light Ivory
    $FFDCF1C1, // Light Olive Green
    $FFC1E6FF, // Light Sky Blue
    $FFDCC1FF, // Light Lavender
    $FFFFE6C1, // Light Coral
    $FFFFF0E1, // Light Beige
    $FFC1D4FF, // Light Periwinkle
    $FFC1FFF1, // Light Aquamarine
    $FFD4FFC1, // Light Lime
    $FFFFC1D4, // Light Pinkish Purple
    $FFFFF0DC, // Light Almond
    $FFFAFAD2, // Light Goldenrod Yellow
    $FFE6E6FA, // Lavender
    $FFFFE4E1, // Misty Rose
    $FFFFEFD5, // Papaya Whip
    $FFFFDAB9, // Peach Puff
    $FFE0FFFF, // Light Cyan
    $FF98FB98, // Pale Green
    $FFAFEEEE, // Pale Turquoise
    $FFDB7093, // Pale Violet Red
    $FFFFE4B5, // Moccasin
    $FFFFD700, // Gold
    $FFFF6347, // Tomato
    $FF4682B4, // Steel Blue
    $FFD2B48C, // Tan
    $FF87CEFA, // Light Sky Blue
    $FF778899, // Light Slate Gray
    $FFB0C4DE, // Light Steel Blue
    $FF40E0D0, // Turquoise
    $FFEE82EE, // Violet
    $FFF5DEB3, // Wheat
    $FF9ACD32, // Yellow Green
    $FFFFA07A, // Light Salmon
    $FF20B2AA, // Light Sea Green
    $FF87CEEB, // Sky Blue
    $FF8470FF, // Light Slate Blue
    $FF7B68EE, // Medium Slate Blue
    $FF6A5ACD, // Slate Blue
    $FF708090, // Slate Gray
    $FF2E8B57, // Sea Green
    $FF00FF7F  // Spring Green
  );

const MEDIUM_COLORS: array[0..49] of TAlphaColor = (
     $FF007FFF, // Light Blue
    $FFFF69B4, // Hot Pink
    $FF7CFC00, // Lawn Green
    $FFFFA500, // Orange
    $FFEE82EE, // Violet
    $FF1E90FF, // Dodger Blue
    $FFF0E68C, // Khaki
    $FFADFF2F, // Green Yellow
    $FFFF4500, // Red Orange
    $FF7FFFD4, // Aquamarine
    $FFFF1493, // Deep Pink
    $FF90EE90, // Light Green
    $FFFF8C00, // Dark Orange
    $FFDB7093, // Pale Violet Red
    $FF6495ED, // Cornflower Blue
    $FFDEB887, // Burlywood
    $FFFFB6C1, // Light Pink
    $FFADD8E6, // Light Blue
    $FF90EE90, // Light Green
    $FFFFFF00, // Yellow
    $FFFA8072, // Salmon
    $FFAEEEEE, // Pale Turquoise
    $FFEEE8AA, // Pale Goldenrod
    $FF00BFFF, // Deep Sky Blue
    $FFFFE4E1, // Misty Rose
    $FF98FB98, // Pale Green
    $FFF08080, // Light Coral
    $FF87CEFA, // Light Sky Blue
    $FFE6E6FA, // Lavender
    $FFF0FFF0, // Honeydew
    $FFF5F5DC, // Beige
    $FFFFEFD5, // Papaya Whip
    $FFFFE4C4, // Bisque
    $FFFFF0F5, // Lavender Blush
    $FFFFDAB9, // Peach Puff
    $FFFFE4B5, // Moccasin
    $FFFFD700, // Gold
    $FFB0E0E6, // Powder Blue
    $FFAFEEEE, // Pale Turquoise
    $FFDB7093, // Pale Violet Red
    $FFFF7F50, // Coral
    $FFB0C4DE, // Light Steel Blue
    $FFFFEBCD, // Blanched Almond
    $FFF5DEB3, // Wheat
    $FFDDA0DD, // Plum
    $FFE9967A, // Dark Salmon
    $FF8A2BE2, // Blue Violet
    $FFFF6347, // Tomato
    $FF4682B4,  // Steel Blue
    $FF32CD32 // Lime Green
);

{$R *.fmx}

procedure TF_RelatorioTipoContas.LimpaLayout(Layout: TLayout);
var
  I: Integer;
begin
  for I := Layout.ChildrenCount - 1 downto 0 do
  begin
    if not (Layout.Children[I] is TCircle) then
    begin
      Layout.Children[I].Free;
    end;
  end;

  lbLegendaItens.Clear;
end;

procedure TF_RelatorioTipoContas.AddLegenda(TipoContaFrame: TTipoContaFrame);
var
  FrameLegenda1: TFrameLegenda;
  ItemLb: TListBoxItem;
begin
  Itemlb := TListBoxItem.Create(lbLegendaItens);
  Itemlb.Margins.Bottom := 5;
  Itemlb.Margins.Left   := 5;
  Itemlb.Height := 80;

  FrameLegenda1 := TFrameLegenda.Create(ItemLb, TipoContaFrame, dataInicial.Date, dataFinal.Date);

  ItemLb.AddObject(FrameLegenda1);
  lbLegendaItens.AddObject(ItemLb);
end;

function TF_RelatorioTipoContas.CalculaCentroGrafico: Single;
begin
  layoutGrafico.Position.X := (layoutTop.Width - layoutGrafico.Width) / 2;
end;

procedure TF_RelatorioTipoContas.dataFinalChange(Sender: TObject);
begin
  inherited;
  MontaGrafico;
end;

procedure TF_RelatorioTipoContas.dataFinalClosePicker(Sender: TObject);
begin
  inherited;
  MontaGrafico;
end;

procedure TF_RelatorioTipoContas.dataFinalExit(Sender: TObject);
begin
  inherited;
  MontaGrafico;
end;

procedure TF_RelatorioTipoContas.dataInicialChange(Sender: TObject);
begin
  inherited;
  MontaGrafico;
end;

procedure TF_RelatorioTipoContas.dataInicialClosePicker(Sender: TObject);
begin
  inherited;
  MontaGrafico;
end;

procedure TF_RelatorioTipoContas.dataInicialExit(Sender: TObject);
begin
  inherited;
  MontaGrafico;
end;

procedure TF_RelatorioTipoContas.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  FListaTotaisTipoConta.Free;
  FDocumentoController.Free;
  Action := TCloseAction.caFree;
  F_RelatorioTipoContas := nil;
end;

procedure TF_RelatorioTipoContas.FormCreate(Sender: TObject);
begin
  inherited;
  TipoDoc              := 2;
  dataInicial.Date     := Date - 30;
  dataFinal.Date       := Date;
  FDocumentoController := TControllerDocumento.Create;
end;

procedure TF_RelatorioTipoContas.FormResize(Sender: TObject);
begin
  inherited;
  CalculaCentroGrafico;
end;

procedure TF_RelatorioTipoContas.FormShow(Sender: TObject);
begin
  inherited;
  MenuAtivo := TMenuAtivo.maGrafico;
  MontaGrafico;
end;

procedure TF_RelatorioTipoContas.imageVoltarClick(Sender: TObject);
begin
  Close;
end;

procedure TF_RelatorioTipoContas.MontaGrafico;
var
  pie1: TPie;
  TotalValor, Porcentagem: Currency;
  ValorAtual: Single;
begin
  TotalValor := 0;
  LimpaLayout(layoutGrafico);

  FListaTotaisTipoConta := FDocumentoController.ObterValoresPorPeriodo(TipoDoc, 'P',
                                                                       dataInicial.Date,
                                                                       dataFinal.Date
                                                                      );

  for var Doc1: TReadTipoContaTotalDocs in FListaTotaisTipoConta do
    TotalValor := TotalValor + Doc1.ValorTotal;

  ValorAtual := 0;
  var Incrementador := 0;
  for var Doc2: TReadTipoContaTotalDocs in FListaTotaisTipoConta do
  begin
    Porcentagem           := (Doc2.ValorTotal / TotalValor) * 100;
    pie1                  := TPie.Create(layoutGrafico);
    pie1.Parent           := layoutGrafico;
    pie1.Align            := TAlignLayout.Client;
    pie1.Margins.Left     := PIE_MARGIN_LEFT_RIGHT;
    pie1.Margins.Right    := PIE_MARGIN_LEFT_RIGHT;
    pie1.Fill.Color       := MEDIUM_COLORS[Incrementador];
    pie1.Stroke.Thickness := 0;
    pie1.StartAngle       := ValorAtual;
    if Incrementador = FListaTotaisTipoConta.Count - 1 then
      pie1.EndAngle := 360
    else
      pie1.EndAngle       := Round((Doc2.ValorTotal / TotalValor) * 360) + ValorAtual;
    ValorAtual            := pie1.EndAngle;

    var TipoContaFrame: TTipoContaFrame;
    TipoContaFrame := TTipoContaFrame.Create;
    TipoContaFrame.IdTipoConta := Doc2.Id;
    TipoContaFrame.TituloConta := Doc2.NomeConta;
    TipoContaFrame.ValorTotal  := Doc2.ValorTotal;
    TipoContaFrame.Porcentagem := Porcentagem;
    TipoContaFrame.Cor         := MEDIUM_COLORS[Incrementador];
    AddLegenda(TipoContaFrame);
    Inc(Incrementador);
  end;

  circuloCentral.BringToFront;
end;

procedure TF_RelatorioTipoContas.rbSaidaClick(Sender: TObject);
begin
  inherited;
  TipoDoc := 2;
  MontaGrafico;
end;

procedure TF_RelatorioTipoContas.rbEntradaClick(Sender: TObject);
begin
  inherited;
  TipoDoc := 1;
  MontaGrafico;
end;

end.
