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
    procedure dataFinalChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure imageVoltarClick(Sender: TObject);
    procedure dataInicialClosePicker(Sender: TObject);
    procedure dataFinalClosePicker(Sender: TObject);
  private
    { Private declarations }
    FDocumentoController: TControllerDocumento;
    TipoDoc: Integer;

    function CalculaCentroGrafico: Single;
    procedure ConsultarDados;
    procedure MontaGrafico(Dados: TObjectList<TObject>);
    procedure LimpaLayout(Layout: TLayout);
    procedure AddLegenda(TipoContaFrame: TTipoContaFrame);
  public
    { Public declarations }
  end;

var
  F_RelatorioTipoContas: TF_RelatorioTipoContas;

implementation

uses
  Math, Loading;

const PIE_MARGIN_LEFT_RIGHT = 80;
const VALOR_MAXIMO_GRAFICO = 360;

const
  MEDIUM_COLORS: array[0..30] of TAlphaColor = (
    $FF4B77BE, // Steel Blue
    $FF5DADE2, // Sky Blue
    $FF48C9B0, // Medium Turquoise
    $FF16A085, // Deep Teal
    $FF27AE60, // Green
    $FF2ECC71, // Emerald
    $FF3498DB, // Light Blue
    $FF2980B9, // Bright Blue
    $FF8E44AD, // Medium Purple
    $FF9B59B6, // Amethyst
    $FF34495E, // Dark Slate Gray
    $FF5D6D7E, // Blue Gray
    $FFF39C12, // Orange
    $FFF1C40F, // Yellow
    $FFF39C12, // Orange
    $FFFB8C00, // Deep Orange
    $FFBDC3C7, // Silver
    $FF95A5A6, // Gray
    $FF7F8C8D, // Gray Blue
    $FF1F618D, // Blue
    $FF154360, // Dark Blue
    $FF7D3C98, // Medium Violet Red
    $FfC0392B, // Red
    $FFEC7063, // Light Coral
    $FF16A085, // Deep Teal
    $FF2E86C1, // Light Blue
    $FF7D3F2A, // Dark Orange
    $FF6C3483, // Dark Purple
    $FF2980B9, // Bright Blue
    $FFABB2B9, // Light Gray
    $FF4A235A  // Dark Purple
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

procedure TF_RelatorioTipoContas.ConsultarDados;
begin
  TLoading.Show('Carregando dados...', F_RelatorioTipoContas);
  FDocumentoController.OnExecutarAposConsulta := MontaGrafico;
  FDocumentoController.ObterValoresPorPeriodo(TipoDoc, 'P',
                                              dataInicial.Date,
                                              dataFinal.Date
                                             );
end;

procedure TF_RelatorioTipoContas.dataFinalChange(Sender: TObject);
begin
  inherited;
  ConsultarDados;
end;

procedure TF_RelatorioTipoContas.dataFinalClosePicker(Sender: TObject);
begin
  inherited;
  ConsultarDados;
end;

procedure TF_RelatorioTipoContas.dataInicialClosePicker(Sender: TObject);
begin
  inherited;
  ConsultarDados;
end;

procedure TF_RelatorioTipoContas.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
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
  ConsultarDados;
end;

procedure TF_RelatorioTipoContas.imageVoltarClick(Sender: TObject);
begin
  Close;
end;

procedure TF_RelatorioTipoContas.MontaGrafico(Dados: TObjectList<TObject>);
var
  pie1: TPie;
  TotalValor, Porcentagem: Currency;
  ValorAtual: Single;
  listaDocs: TObjectList<TReadTipoContaTotalDocs>;
begin
  try
    listaDocs := TObjectList<TReadTipoContaTotalDocs>(Dados);

    TotalValor := 0;
    LimpaLayout(layoutGrafico);

    for var Doc1: TReadTipoContaTotalDocs in listaDocs do
      TotalValor := TotalValor + Doc1.ValorTotal;

    ValorAtual := 0;
    var Incrementador := 0;
    for var Doc2: TReadTipoContaTotalDocs in listaDocs do
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
      if Incrementador = Dados.Count - 1 then
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
  finally
    circuloCentral.BringToFront;
    TLoading.Hide;
  end;
end;

procedure TF_RelatorioTipoContas.rbSaidaClick(Sender: TObject);
begin
  inherited;
  TipoDoc := 2;
  ConsultarDados;
end;

procedure TF_RelatorioTipoContas.rbEntradaClick(Sender: TObject);
begin
  inherited;
  TipoDoc := 1;
  ConsultarDados;
end;

end.
