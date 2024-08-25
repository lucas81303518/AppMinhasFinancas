unit UF_CadDocumentos;

interface

uses
  System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UF_BaseCadastro, FMX.ListBox, FMX.Controls.Presentation, FMX.Layouts,
  FMX.Objects, FMX.Edit, FMX.EditBox, FMX.NumberBox, FMX.DateTimeCtrls,
  Generics.Collections, Model.TipoDeConta, Controller.TipoDeContas,
  Controller.FormasDePagamento, model.FormaDePagamento, Controller.Documento,
  model.Documentos, UF_CadTipoDeConta;

type
  TF_CadDocumentos = class(TF_BaseCadastro)
    LayoutTipoDeConta: TLayout;
    cbTipoConta: TComboBox;
    Label2: TLabel;
    LayoutValor: TLayout;
    Label3: TLabel;
    numberBoxValor: TNumberBox;
    lblCadastrarTipoDeConta: TLabel;
    LayoutDescricao: TLayout;
    Label4: TLabel;
    edtDescricao: TEdit;
    LayoutDataRecebimento: TLayout;
    lblData: TLabel;
    dataDoc: TDateEdit;
    LayoutFormaPagamento: TLayout;
    cbFormaDePagamento: TComboBox;
    Label11: TLabel;
    lblCadastrarFormaPagamento: TLabel;
    Label12: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lblCadastrarTipoDeContaClick(Sender: TObject);
    procedure edtDescricaoEnter(Sender: TObject);
    procedure lblCadastrarFormaPagamentoClick(Sender: TObject);
    procedure recSalvarClick(Sender: TObject);
    procedure numberBoxValorClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FControllerTipoContas: TControllerTipoDeContas;
    FControllerFormasPagamento: TControllerFormasPagamento;
    FControllerDocumento: TControllerDocumento;
    FEditando: Boolean;
    FDocumento: TDocumento;
    FTipoDocumento: TTipoDocumento;
    FListaFormasPagamento: TObjectlist<TFormaPagamento>;

    procedure ExecutarAposCadastro;
    procedure AtualizaTelaPeloTipoDocumento;
    procedure MontaTela;
    procedure ConsultaDadosTipoContas();
    procedure MontaTipoContas(Dados: TObjectList<TTipoConta>);
    procedure ConsultaDadosFormasPagamento();
    procedure MontaFormasPagamento(Dados: TObjectlist<TFormaPagamento>);
    function ValidarCampos: Boolean; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; TipoDocumento: TTipoDocumento; Documento: TDocumento = nil);
  end;

var
  F_CadDocumentos: TF_CadDocumentos;

implementation

uses
  UF_CadFormasPagamento, funcoes, Dmodulo, System.SysUtils, Loading,
  UF_BaseMenu;

{$R *.fmx}

procedure TF_CadDocumentos.AtualizaTelaPeloTipoDocumento;
begin
  if FTipoDocumento = tdSaida then
  begin
    lblTitulo.Text := 'Cadastrar Sa�da';
    lblData.Text   := 'Data pagamento';
  end;
end;

procedure TF_CadDocumentos.ConsultaDadosFormasPagamento;
begin
  TLoading.Show('Carregando Formas de Pagamento...', F_CadDocumentos);
  FControllerFormasPagamento.OnExecutarAposConsulta := MontaFormasPagamento;
  FControllerFormasPagamento.GetAll;
end;

procedure TF_CadDocumentos.ConsultaDadosTipoContas();
begin
  TLoading.Show('Carregando Tipo de Contas...', F_CadDocumentos);
  FControllerTipoContas.OnExecutarAposConsulta := MontaTipoContas;
  FControllerTipoContas.GetPorTipo(Integer(FTipoDocumento));
end;

constructor TF_CadDocumentos.Create(AOwner: TComponent; TipoDocumento: TTipoDocumento; Documento: TDocumento);
begin
  inherited Create(AOwner);
  FTipoDocumento             := TipoDocumento;
  FControllerTipoContas      := TControllerTipoDeContas.create;
  FControllerFormasPagamento := TControllerFormasPagamento.Create;
  FControllerDocumento       := TControllerDocumento.Create;
  AtualizaTelaPeloTipoDocumento();
  FDocumento := documento;
  if FDocumento <> nil then
    MontaTela;
  FEditando := FDocumento <> nil;
end;

procedure TF_CadDocumentos.edtDescricaoEnter(Sender: TObject);
begin
  inherited;
  {$IFDEF ANDROID}
//  foco := TEdit(Sender);
//  Ajustar_Scroll();
  {$ENDIF}
end;

procedure TF_CadDocumentos.ExecutarAposCadastro;
begin
  TLoading.Hide;
  Close;
end;

procedure TF_CadDocumentos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FControllerTipoContas.Free;
  FControllerFormasPagamento.Free;
  FControllerDocumento.Free;
  if FDocumento <> nil then
    FDocumento.Free;
  Action := TCloseAction.caFree;
  F_CadDocumentos := nil;
end;

procedure TF_CadDocumentos.FormCreate(Sender: TObject);
begin
  //teste123
end;

procedure TF_CadDocumentos.FormShow(Sender: TObject);
begin
  inherited;
  MenuAtivo := TMenuAtivo.maCadastros;
  ConsultaDadosTipoContas();
  ConsultaDadosFormasPagamento();
end;

procedure TF_CadDocumentos.lblCadastrarFormaPagamentoClick(Sender: TObject);
begin
  inherited;
  if not Assigned(F_CadFormasPagamento) then
  begin
    F_CadFormasPagamento := TF_CadFormasPagamento.Create(Self);
    F_CadFormasPagamento.OnFormaPagamentoIncluida := ConsultaDadosFormasPagamento;
    F_CadFormasPagamento.Show;
  end;
end;

procedure TF_CadDocumentos.lblCadastrarTipoDeContaClick(Sender: TObject);
begin
  inherited;
  if not Assigned(F_CadTipoDeConta) then
  begin
    F_CadTipoDeConta := TF_CadTipoDeConta.Create(Self, nil, FTipoDocumento);
    F_CadTipoDeConta.OnContaIncluida := ConsultaDadosTipoContas;
    F_CadTipoDeConta.Show;
  end;
end;

procedure TF_CadDocumentos.MontaFormasPagamento(Dados: TObjectlist<TFormaPagamento>);
var
  FormaPagamento: TFormaPagamento;
begin
  try
    cbFormaDePagamento.BeginUpdate;
    cbFormaDePagamento.Items.Clear;
    for FormaPagamento in Dados do
    begin
      cbFormaDePagamento.Items.AddObject(FormaPagamento.Nome, FormaPagamento);
    end;
  finally
    TLoading.Hide;
    cbFormaDePagamento.EndUpdate;
  end;
end;

procedure TF_CadDocumentos.MontaTela;
begin

end;

procedure TF_CadDocumentos.MontaTipoContas(Dados: TObjectList<TTipoConta>);
var
  TipoConta: TTipoConta;
begin
  try
    cbTipoConta.BeginUpdate;
    cbTipoConta.Items.Clear;
    for TipoConta in Dados do
    begin
      cbTipoConta.Items.AddObject(TipoConta.NomeConta, TipoConta);
    end;
  finally
    TLoading.Hide;
    cbTipoConta.EndUpdate;
  end;
end;

procedure TF_CadDocumentos.numberBoxValorClick(Sender: TObject);
begin
  inherited;
  numberBoxValor.SelectAll;
end;

procedure TF_CadDocumentos.recSalvarClick(Sender: TObject);
begin
  if not ValidarCampos then
    Exit;

  if FDocumento = nil then
    FDocumento := TDocumento.Create;
  with FDocumento do
  begin
    NumeroDocumento  := '1';
    Descricao        := edtDescricao.Text;
    Valor            := StrToCurr(numberBoxValor.Text);
    DataDocumento    := dataDoc.Date;
    QtdParcelas      := 1;
    Status           := 'P';
    CodigoMeta       := 0;
    FormaPagamentoId := TFormaPagamento(GetSelectedObject(cbFormaDePagamento)).Id;
    TipoContaId      := TTipoConta(GetSelectedObject(cbTipoConta)).Id;
  end;

  TLoading.Show('Inserindo Documento...', F_CadDocumentos);
  FControllerDocumento.OnExecutarAposCadastro := ExecutarAposCadastro;
  if FEditando then
    FControllerDocumento.Update(FDocumento)
  else
    FControllerDocumento.Add(FDocumento);
end;

function TF_CadDocumentos.ValidarCampos: Boolean;
begin
  Result := False;
  if cbTipoConta.ItemIndex < 0 then
  begin
    ShowMessage('Selecione um tipo de conta');
    cbTipoConta.SetFocus;
    Exit;
  end;

  if cbFormaDePagamento.ItemIndex < 0 then
  begin
    ShowMessage('Selecione uma forma de pagamento');
    cbFormaDePagamento.SetFocus;
    Exit;
  end;

  if StrToCurrDef(numberBoxValor.Text, 0) <= 0 then
  begin
    ShowMessage('O valor da Entrada deve ser maior que 0');
    numberBoxValor.SetFocus;
    Exit;
  end;

  Result := True;
end;

end.
