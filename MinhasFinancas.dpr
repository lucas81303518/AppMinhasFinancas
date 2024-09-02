program MinhasFinancas;

uses
  System.StartUpCopy,
  FMX.Forms,
  UF_BaseMenu in 'Views\Form Base\UF_BaseMenu.pas' {F_BaseMenu},
  UF_Principal in 'Views\UF_Principal.pas' {F_Principal},
  UF_BaseCadastro in 'Views\Form Base\UF_BaseCadastro.pas' {F_BaseCadastro},
  UF_Cadastros in 'Views\UF_Cadastros.pas' {F_Cadastros},
  UF_CadTipoDeConta in 'Views\UF_CadTipoDeConta.pas' {F_CadTipoDeConta},
  Dmodulo in 'Data\Dmodulo.pas' {DmPrincipal: TDataModule},
  Model.TipoDeConta in 'Models\Model.TipoDeConta.pas',
  UIDAOTipoDeContas in 'DAO\Interfaces\UIDAOTipoDeContas.pas',
  DAO.TipoDeConta in 'DAO\DAO.TipoDeConta.pas',
  Controller.TipoDeContas in 'Controllers\Controller.TipoDeContas.pas',
  UF_CadFormasPagamento in 'Views\UF_CadFormasPagamento.pas' {F_CadFormasPagamento},
  Model.FormaDePagamento in 'Models\Model.FormaDePagamento.pas',
  UIDAOFormasDePagamento in 'DAO\Interfaces\UIDAOFormasDePagamento.pas',
  DAO.FormasDePagamento in 'DAO\DAO.FormasDePagamento.pas',
  Controller.FormasDePagamento in 'Controllers\Controller.FormasDePagamento.pas',
  Model.Documentos in 'Models\Model.Documentos.pas',
  UIDAODocumentos in 'DAO\Interfaces\UIDAODocumentos.pas',
  DAO.Documento in 'DAO\DAO.Documento.pas',
  Controller.Documento in 'Controllers\Controller.Documento.pas',
  funcoes in 'Utils\funcoes.pas',
  UF_CadDocumentos in 'Views\UF_CadDocumentos.pas' {F_CadDocumentos},
  UF_Login in 'Views\UF_Login.pas' {F_Login},
  UF_RelatorioTicoContas in 'Views\UF_RelatorioTicoContas.pas' {F_RelatorioTipoContas},
  UF_RelatorioTipoContasDetalhado in 'Views\UF_RelatorioTipoContasDetalhado.pas' {F_RelatorioTipoDeContasDetalhado},
  UnitSplash in 'Views\UnitSplash.pas' {FrmSplash},
  Loading in 'Utils\Loading.pas',
  Frame.Legenda in 'Frames\Frame.Legenda.pas' {FrameLegenda: TFrame},
  Frame.Detalhes in 'Frames\Frame.Detalhes.pas' {FrameDetalhes: TFrame},
  Controller.Usuario in 'Controllers\Controller.Usuario.pas',
  DAO.Usuario in 'DAO\DAO.Usuario.pas',
  Model.Usuario in 'Models\Model.Usuario.pas',
  ThreadingEx in 'Utils\ThreadingEx.pas',
  FMX.Dialogs {F_PerfilUsuario},
  UCamera in 'Views\UCamera.pas' {F_Camera},
  UF_InformacoesUsuario in 'Views\UF_InformacoesUsuario.pas' {F_InformacoesUsuario},
  DAO.Saldo in 'DAO\DAO.Saldo.pas',
  Controller.Saldo in 'Controllers\Controller.Saldo.pas',
  DAO.Gastos in 'DAO\DAO.Gastos.pas',
  Controller.Gastos in 'Controllers\Controller.Gastos.pas',
  DAO.Receitas in 'DAO\DAO.Receitas.pas',
  Controller.Receitas in 'Controllers\Controller.Receitas.pas',
  HelperLabel in 'Views\Helpers\HelperLabel.pas',
  UF_ConfirmacaoEmail in 'Views\UF_ConfirmacaoEmail.pas' {F_ConfirmacaoEmail},
  UAtualizaFoto in 'Data\DTO\Usuario\UAtualizaFoto.pas',
  UCreateUsuario in 'Data\DTO\Usuario\UCreateUsuario.pas',
  ULoginUsuario in 'Data\DTO\Usuario\ULoginUsuario.pas',
  UReadUsuario in 'Data\DTO\Usuario\UReadUsuario.pas',
  UUpdateUsuario in 'Data\DTO\Usuario\UUpdateUsuario.pas',
  CreateMeta in 'Data\DTO\Metas\CreateMeta.pas',
  DAO.Metas in 'DAO\DAO.Metas.pas',
  Controller.Metas in 'Controllers\Controller.Metas.pas',
  UF_CadastroMetas in 'Views\UF_CadastroMetas.pas' {F_CadastroMetas},
  Frame.MetasFormPrincipal in 'Frames\Frame.MetasFormPrincipal.pas' {FrameMetasFormPrincipal: TFrame},
  ReadMeta in 'Data\DTO\Metas\ReadMeta.pas',
  UF_DetalhesMeta in 'Views\UF_DetalhesMeta.pas' {F_DetalhesMeta},
  UF_AtribuirSaldoMetas in 'Views\UF_AtribuirSaldoMetas.pas' {F_AtribuirSaldoMetas},
  ReadMovimentacaoMetas in 'Data\DTO\Movimentacao meta\ReadMovimentacaoMetas.pas',
  DAO.MovimentacaoMetas in 'DAO\DAO.MovimentacaoMetas.pas',
  Controller.MovimentacaoMetas in 'Controllers\Controller.MovimentacaoMetas.pas',
  Frame.Movimentacao in 'Frames\Frame.Movimentacao.pas' {FrameMovimentacao: TFrame},
  ReadDocumentos in 'Data\DTO\Documentos\ReadDocumentos.pas',
  ReadTipoConta in 'Data\DTO\Tipo Contas\ReadTipoConta.pas',
  ReadFormaPagamento in 'Data\DTO\Formas pgto\ReadFormaPagamento.pas';

{$R *.res}

begin
//  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.CreateForm(TDmPrincipal, DmPrincipal);
  Application.CreateForm(TFrmSplash, FrmSplash);
  Application.Run;
  {$IFDEF DEBUG}
    ShowMessage('Você está no modo DEBUG (Somente para testes!)');
  {$ENDIF}
end.
