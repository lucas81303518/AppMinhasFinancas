unit UF_CadDocumentos;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
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
    procedure numberBoxValorEnter(Sender: TObject);
    procedure edtDescricaoEnter(Sender: TObject);
    procedure lblCadastrarFormaPagamentoClick(Sender: TObject);
    procedure recSalvarClick(Sender: TObject);
  private
    { Private declarations }
    FControllerTipoContas: TControllerTipoDeContas;
    FControllerFormasPagamento: TControllerFormasPagamento;
    FControllerDocumento: TControllerDocumento;
    FEditando: Boolean;
    FDocumento: TDocumento;
    FTipoDocumento: TTipoDocumento;
    FListaTipoContas: TObjectList<TTipoConta>;
    FListaFormasPagamento: TObjectlist<TFormaPagamento>;

    procedure AtualizaTelaPeloTipoDocumento;
    procedure MontaTela;
    procedure MontaTipoContas();
    procedure MontaFormasPagamento();
    function ValidarCampos: Boolean; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; TipoDocumento: TTipoDocumento; Documento: TDocumento = nil);
  end;

var
  F_CadDocumentos: TF_CadDocumentos;

implementation

uses
  UF_CadFormasPagamento, funcoes, Dmodulo;

{$R *.fmx}

procedure TF_CadDocumentos.AtualizaTelaPeloTipoDocumento;
begin
  if FTipoDocumento = tdSaida then
  begin
    lblTitulo.Text := 'Cadastrar Sa�da';
    lblData.Text   := 'Data pagamento';
  end;
end;

constructor TF_CadDocumentos.Create(AOwner: TComponent; TipoDocumento: TTipoDocumento; Documento: TDocumento);
begin
  inherited Create(AOwner);
  FTipoDocumento             := TipoDocumento;
  FControllerTipoContas      := TControllerTipoDeContas.create;
  FControllerFormasPagamento := TControllerFormasPagamento.Create;
  FControllerDocumento       := TControllerDocumento.Create;
  AtualizaTelaPeloTipoDocumento();
  MontaTipoContas();
  MontaFormasPagamento();
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

procedure TF_CadDocumentos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  try
    FControllerTipoContas.Free;
    FControllerFormasPagamento.Free;
    FControllerDocumento.Free;
    if FDocumento <> nil then
      FDocumento.Free;
    Action := TCloseAction.caFree;
    F_CadDocumentos := nil;
  except on Ex: Exception do
    begin
      ex.Message := 'Erro close: ' + ex.Message;
      raise;
    end;
  end;
end;

procedure TF_CadDocumentos.lblCadastrarFormaPagamentoClick(Sender: TObject);
begin
  inherited;
  if not Assigned(F_CadFormasPagamento) then
  begin
    F_CadFormasPagamento := TF_CadFormasPagamento.Create(Self);
    F_CadFormasPagamento.OnFormaPagamentoIncluida := MontaFormasPagamento;
    F_CadFormasPagamento.Show;
  end;
end;

procedure TF_CadDocumentos.lblCadastrarTipoDeContaClick(Sender: TObject);
begin
  inherited;
  if not Assigned(F_CadTipoDeConta) then
  begin
    F_CadTipoDeConta := TF_CadTipoDeConta.Create(Self, nil, FTipoDocumento);
    F_CadTipoDeConta.OnContaIncluida := MontaTipoContas;
    F_CadTipoDeConta.Show;
  end;
end;

procedure TF_CadDocumentos.MontaFormasPagamento();
var
  FormaPagamento: TFormaPagamento;
begin
  try
    cbFormaDePagamento.Items.Clear;
  except on Ex: Exception do
    begin
      ex.Message := 'Erro Montando Formas Pagamento(2): ' + ex.Message;
      raise;
    end;
  end;

  try
    FListaFormasPagamento := FControllerFormasPagamento.GetAll;
  except on Ex: Exception do
    begin
      ex.Message := 'Erro Montando Formas Pagamento(3): ' + ex.Message;
      raise;
    end;
  end;

  for FormaPagamento in FListaFormasPagamento do
  begin
    cbFormaDePagamento.Items.AddObject(FormaPagamento.Nome, FormaPagamento);
  end;
end;

procedure TF_CadDocumentos.MontaTela;
begin

end;

procedure TF_CadDocumentos.MontaTipoContas();
var
  TipoConta: TTipoConta;
begin
  try
    try
      cbTipoConta.Items.Clear;
    except on Ex: Exception do
      begin
        ex.Message := 'Erro MontaTipoContas(2): ' +ex.Message;
        raise;
      end;
    end;

    try
      FListaTipoContas := FControllerTipoContas.GetPorTipo(Integer(FTipoDocumento));
    except on Ex: Exception do
      begin
        ex.Message := 'Erro MontaTipoContas(3): ' + ex.Message;
        raise;
      end;
    end;

    try
      for TipoConta in FListaTipoContas do
      begin
        cbTipoConta.Items.AddObject(TipoConta.NomeConta, TipoConta);
      end;
    except on Ex: Exception do
      begin
        ex.Message := 'Erro MontaTipoContas(4): ' +ex.Message;
        raise;
      end;
    end;
  finally

  end;
end;

procedure TF_CadDocumentos.numberBoxValorEnter(Sender: TObject);
begin
  inherited;
  {$IFDEF ANDROID}
//    foco := TNumberBox(Sender);
//    Ajustar_Scroll();
  {$ENDIF}
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
    Valor            := numberBoxValor.Value;
    DataDocumento    := dataDoc.Date;
    QtdParcelas      := 1;
    Status           := 'P';
    CodigoMeta       := 0;
    FormaPagamentoId := TFormaPagamento(GetSelectedObject(cbFormaDePagamento)).Id;
    TipoContaId      := TTipoConta(GetSelectedObject(cbTipoConta)).Id;
    UsuarioId        := Dmprincipal.Usuario.Id;
  end;

  if FEditando then
    FControllerDocumento.Update(FDocumento)
  else
    FControllerDocumento.Add(FDocumento);
  Close;
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

  if numberBoxValor.Value <= 0 then
  begin
    ShowMessage('O valor da Entrada deve ser maior que 0');
    numberBoxValor.SetFocus;
    Exit;
  end;

  Result := True;
end;

end.
