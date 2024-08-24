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
  UF_ConfiguracaoAPI in 'Views\UF_ConfiguracaoAPI.pas' {F_ConfiguracaoAPI},
  UF_CadDocumentos in 'Views\UF_CadDocumentos.pas' {F_CadDocumentos},
  UF_Login in 'Views\UF_Login.pas' {F_Login},
  UF_RelatorioTicoContas in 'Views\UF_RelatorioTicoContas.pas' {F_RelatorioTipoContas},
  UF_RelatorioTipoContasDetalhado in 'Views\UF_RelatorioTipoContasDetalhado.pas' {F_RelatorioTipoDeContasDetalhado},
  UnitSplash in 'Views\UnitSplash.pas' {FrmSplash},
  Loading in 'Utils\Loading.pas',
  Frame.Legenda in 'Frames\Frame.Legenda.pas' {FrameLegenda: TFrame},
  Frame.TipoContaDetalhado in 'Frames\Frame.TipoContaDetalhado.pas' {FrameTipoContaDetalhado: TFrame},
  Controller.Usuario in 'Controllers\Controller.Usuario.pas',
  DAO.Usuario in 'DAO\DAO.Usuario.pas',
  Model.Usuario in 'Models\Model.Usuario.pas',
  UCreateUsuario in 'Data\DTO\UCreateUsuario.pas',
  ULoginUsuario in 'Data\DTO\ULoginUsuario.pas',
  ThreadingEx in 'Utils\ThreadingEx.pas',
  FMX.Dialogs {F_PerfilUsuario},
  UReadUsuario in 'Data\DTO\UReadUsuario.pas',
  UCamera in 'Views\UCamera.pas' {F_Camera},
  UF_InformacoesUsuario in 'Views\UF_InformacoesUsuario.pas' {F_InformacoesUsuario},
  UAtualizaFoto in 'Data\DTO\UAtualizaFoto.pas',
  UUpdateUsuario in 'Data\DTO\UUpdateUsuario.pas',
  DAO.Saldo in 'DAO\DAO.Saldo.pas',
  Controller.Saldo in 'Controllers\Controller.Saldo.pas',
  DAO.Gastos in 'DAO\DAO.Gastos.pas',
  Controller.Gastos in 'Controllers\Controller.Gastos.pas',
  DAO.Receitas in 'DAO\DAO.Receitas.pas',
  Controller.Receitas in 'Controllers\Controller.Receitas.pas',
  HelperLabel in 'Views\Helpers\HelperLabel.pas';

{$R *.res}

begin
//  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.CreateForm(TDmPrincipal, DmPrincipal);
  Application.CreateForm(TFrmSplash, FrmSplash);
  Application.Run;
  {$IFDEF DEBUG}
    ShowMessage('Voc� est� no modo DEBUG (Somente para testes!)');
  {$ENDIF}
end.
