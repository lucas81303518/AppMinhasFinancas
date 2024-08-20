unit UF_RelatorioTipoContasDetalhado;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UF_BaseMenu, FMX.Controls.Presentation, FMX.Objects, Frame.Legenda,
  Frame.TipoContaDetalhado,
  FMX.Layouts, FMX.DateTimeCtrls, Controller.Documento, Model.documentos,
  System.Generics.Collections, FMX.ListBox;

type
  TF_RelatorioTipoDeContasDetalhado = class(TF_BaseMenu)
    Layout1: TLayout;
    Line1: TLine;
    lblTipoConta: TLabel;
    Circulo: TCircle;
    Layout2: TLayout;
    lblTitulo: TLabel;
    LayoutTipoContaGeral: TLayout;
    lblValorTotal: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Layout4: TLayout;
    LayoutCentralizaPeriodo: TLayout;
    dataFinal: TDateEdit;
    dataInicial: TDateEdit;
    Label4: TLabel;
    lbRelatorio: TListBox;
    LayoutData: TLayout;
    LayoutTituloTipoConta: TLayout;
    LayoutDescricao: TLayout;
    LayoutValor: TLayout;
    ImageClose: TImage;
    Layout3: TLayout;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure ImageCloseClick(Sender: TObject);
    procedure dataInicialClosePicker(Sender: TObject);
    procedure dataFinalClosePicker(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FtipoContaFrame: TTipoContaFrame;
    FControllerDocumento: TControllerDocumento;
    procedure ConsultaDados;
    procedure MontaTela(Dados: TObjectList<TReadTipoContaTotalDocs>);
    procedure AddItemRelatorio(Documento: TReadTipoContaTotalDocs);
    procedure CalculaWidthLayoutColuna;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; TipoContaFrame: TTipoContaFrame;
                       DtInicial, DtFinal: TDateTime
                      );
  end;

var
  F_RelatorioTipoDeContasDetalhado: TF_RelatorioTipoDeContasDetalhado;

implementation

uses
  Loading;

{$R *.fmx}

{ TF_RelatorioTipoDeContasDetalhado }

procedure TF_RelatorioTipoDeContasDetalhado.AddItemRelatorio(Documento: TReadTipoContaTotalDocs);
var
  Frame: TFrameTipoContaDetalhado;
  ItemLb: TListBoxItem;
begin
  Itemlb := TListBoxItem.Create(lbRelatorio);
  Itemlb.Margins.Left   := 5;
  Itemlb.Height := 38;

  Frame := TFrameTipoContaDetalhado.Create(ItemLb);
  Frame.lblData.Text      := FormatDateTime('dd/mm/yyyy', Documento.DataDocumento);
  Frame.lblDescricao.Text := Documento.Descricao;
  Frame.lblValor.Text     := 'R$ ' + FormatFloat('#,##.00', Documento.ValorTotal);

  ItemLb.AddObject(Frame);
  lbRelatorio.AddObject(ItemLb);

end;

procedure TF_RelatorioTipoDeContasDetalhado.CalculaWidthLayoutColuna;
begin
  LayoutDescricao.Width := Trunc(LayoutTipoContaGeral.Width * 0.5);
  layoutData.Width      := Trunc(LayoutTipoContaGeral.Width * 0.25);
  LayoutValor.Width     := Trunc(LayoutTipoContaGeral.Width * 0.25);
end;

procedure TF_RelatorioTipoDeContasDetalhado.ConsultaDados;
begin
  TLoading.Show('Carregando Dados...', F_RelatorioTipoDeContasDetalhado);
  FControllerDocumento.OnExecutarAposConsulta := MontaTela;
  FControllerDocumento
    .RelatorioDetalhadoTipoContas(FtipoContaFrame.IdTipoConta,
                                  'P', dataInicial.Date, dataFinal.Date
                                  );
end;

constructor TF_RelatorioTipoDeContasDetalhado.Create(AOwner: TComponent;
  TipoContaFrame: TTipoContaFrame; DtInicial, DtFinal: TDateTime);
begin
  inherited Create(AOWner);
  dataInicial.Date := dtInicial;
  dataFinal.Date   := dtFinal;
  FtipoContaFrame  := tipoContaFrame;
  FControllerDocumento := TControllerDocumento.Create;
end;

procedure TF_RelatorioTipoDeContasDetalhado.dataFinalClosePicker(
  Sender: TObject);
begin
  inherited;
  ConsultaDados;
end;

procedure TF_RelatorioTipoDeContasDetalhado.dataInicialClosePicker(
  Sender: TObject);
begin
  inherited;
  ConsultaDados;
end;

procedure TF_RelatorioTipoDeContasDetalhado.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  FControllerDocumento.Free;
  Action := TCloseAction.cafree;
  F_RelatorioTipoDeContasDetalhado := nil;
end;

procedure TF_RelatorioTipoDeContasDetalhado.FormResize(Sender: TObject);
begin
  inherited;
  CalculaWidthLayoutColuna();
end;

procedure TF_RelatorioTipoDeContasDetalhado.FormShow(Sender: TObject);
begin
  inherited;
  LayoutTituloTipoConta.Visible := False;
  MenuAtivo := TMenuAtivo.maGrafico;
  ConsultaDados;
end;

procedure TF_RelatorioTipoDeContasDetalhado.ImageCloseClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TF_RelatorioTipoDeContasDetalhado.MontaTela(Dados: TObjectList<TReadTipoContaTotalDocs>);
var
  Total: Currency;
begin
  try
    Total := 0;
    lblTipoConta.Text       := FtipoContaFrame.TituloConta;
    lblTipoConta.FontColor  := FtipoContaFrame.Cor;
    lblValorTotal.FontColor := FtipoContaFrame.Cor;
    Circulo.Fill.Color      := FtipoContaFrame.Cor;

    lbRelatorio.BeginUpdate;
    lbRelatorio.Clear;
    for var Doc: TReadTipoContaTotalDocs in Dados do
    begin
      Total := Total + Doc.ValorTotal;
      AddItemRelatorio(Doc);
    end;
    lblValorTotal.Text := 'R$ ' + FormatFloat('#,##.00', FtipoContaFrame.ValorTotal);
  finally
    LayoutTituloTipoConta.Visible := True;
    lbRelatorio.EndUpdate;
    TLoading.Hide;
  end;
end;

end.
