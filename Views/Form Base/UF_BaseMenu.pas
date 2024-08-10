unit UF_BaseMenu;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, System.Classes, System.Generics.Collections;

type
<<<<<<< HEAD
  TMenuAtivo = (maGrafico, maPrincipal, maCadastros);

  TF_BaseMenu = class(TForm)
    recGeral: TRectangle;
    recMenu: TRectangle;
    rectMenuLateral: TRectangle;
    ImageMoney: TImage;
    recMenuLateralPerfil: TRectangle;
    Label6: TLabel;
    recMenuLateralSair: TRectangle;
    Label8: TLabel;
    recMenuLateralGrafico: TRectangle;
    Label7: TLabel;
    recMenuLateralCadastrar: TRectangle;
    Label9: TLabel;
    recMenuLateralInicio: TRectangle;
    Label10: TLabel;
    Image3: TImage;
    Image2: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    recMenuFooter: TRectangle;
    recHome: TRectangle;
    recGrafico: TRectangle;
    recCadastros: TRectangle;
    ImageUser: TImage;
    imageMenu: TImage;
    imageCadastro: TImage;
    imageHome: TImage;
    imagemGrafico: TImage;
=======
  TF_BaseMenu = class(TForm)
    recGeral: TRectangle;
    recMenu: TRectangle;
    imageMenu: TImage;
    ImageUser: TImage;
    recMenuFooter: TRectangle;
    imageHome: TImage;
    imagemGrafico: TImage;
    rectMenuLateral: TRectangle;
    ImageMoney: TImage;
    recMenuLateralPerfil: TRectangle;
    Image2: TImage;
    Label6: TLabel;
    recMenuLateralSair: TRectangle;
    Label8: TLabel;
    Image6: TImage;
    recMenuLateralGrafico: TRectangle;
    Label7: TLabel;
    Image5: TImage;
    recMenuLateralCadastrar: TRectangle;
    Label9: TLabel;
    Image4: TImage;
    recMenuLateralInicio: TRectangle;
    Label10: TLabel;
    Image3: TImage;
    imageCadastro: TImage;
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure imageMenuClick(Sender: TObject);
    procedure ImageMoneyClick(Sender: TObject);
    procedure recGeralClick(Sender: TObject);
    procedure recMenuLateralInicioClick(Sender: TObject);
    procedure recMenuLateralSairClick(Sender: TObject);
    procedure recMenuLateralCadastrarClick(Sender: TObject);
    procedure imagemGraficoClick(Sender: TObject);
  private
    { Private declarations }
<<<<<<< HEAD
    FMenuBottomAtivo: TMenuAtivo;
    procedure SetMenuAtivo(const Value: TMenuAtivo);
    procedure InicializaMenuBottom;
    procedure SetaCorMenuAtivo(const Value: TMenuAtivo);
    procedure AjustaVisibilidadeMenuLateral(Visivel: Boolean);
    procedure GoToHome();
  protected
    property MenuAtivo: TMenuAtivo read FMenuBottomAtivo write SetMenuAtivo;
=======
    procedure AjustaVisibilidadeMenuLateral(Visivel: Boolean);
    procedure GoToHome;
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
  public
    { Public declarations }
  end;

var
  F_BaseMenu: TF_BaseMenu;

<<<<<<< HEAD
const COR_ESCURA_MENU = $FF36512A;
const COR_CLARA_MENU  = $FF4F8835;

implementation

uses
  UF_Cadastros, funcoes, UF_RelatorioTicoContas, UF_Login, FMX.Ani, Loading;
=======
implementation

uses
  UF_Cadastros, funcoes;
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0

{$R *.fmx}

procedure TF_BaseMenu.AjustaVisibilidadeMenuLateral(Visivel: Boolean);
  const marginRightOriginal = 100;
  const widthOriginal = 169;
begin
  if Visivel then
  begin
    rectMenuLateral.Height     := Trunc(recGeral.Height - recMenuFooter.Height);
    rectMenuLateral.Width      := Trunc(recGeral.Width / 2);
    rectMenuLateral.Position.X := 0;
    rectMenuLateral.Position.Y := 0;
    rectMenuLateral.BringToFront;
    rectMenuLateral.Repaint;
    rectMenuLateral.Visible := True;

    ImageMoney.Margins.Right := (marginRightOriginal * rectMenuLateral.Width) / widthOriginal;
  end
  else
  begin
    rectMenuLateral.Visible := False;
  end;
end;

procedure TF_BaseMenu.FormCreate(Sender: TObject);
begin
  inherited;
  AjustaVisibilidadeMenuLateral(False);

end;

procedure TF_BaseMenu.FormResize(Sender: TObject);
begin
  inherited;
  if rectMenuLateral.Visible then
  begin
    rectMenuLateral.Height     := Trunc(recGeral.Height - recMenuFooter.Height);
    rectMenuLateral.Width      := Trunc(recGeral.Width / 2);
    rectMenuLateral.Position.X := 0;
    rectMenuLateral.Position.Y := 0;
    rectMenuLateral.Repaint;
  end;
end;

procedure TF_BaseMenu.imageMenuClick(Sender: TObject);
begin
  AjustaVisibilidadeMenuLateral(True);
end;

procedure TF_BaseMenu.imagemGraficoClick(Sender: TObject);
begin
<<<<<<< HEAD
  AjustaVisibilidadeMenuLateral(False);
  if not Assigned(F_RelatorioTipoContas) then
  begin
    GoToHome;
    F_RelatorioTipoContas := TF_RelatorioTipoContas.Create(nil);
  end;
  F_RelatorioTipoContas.Show;
=======
  MenuAtivo := taRelatorio;
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
end;

procedure TF_BaseMenu.ImageMoneyClick(Sender: TObject);
begin
  inherited;
  AjustaVisibilidadeMenuLateral(False);
end;

<<<<<<< HEAD
procedure TF_BaseMenu.InicializaMenuBottom;
begin
  recGrafico.Fill.Color   := COR_CLARA_MENU;
  recHome.Fill.Color      := COR_CLARA_MENU;
  recCadastros.Fill.Color := COR_CLARA_MENU;
end;

=======
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
procedure TF_BaseMenu.recGeralClick(Sender: TObject);
begin
  inherited;
  AjustaVisibilidadeMenuLateral(False);
end;

procedure TF_BaseMenu.recMenuLateralCadastrarClick(Sender: TObject);
begin
<<<<<<< HEAD
  AjustaVisibilidadeMenuLateral(False);
  if not Assigned(F_Cadastros) then
  begin
    GoToHome;
    F_Cadastros := TF_Cadastros.create(nil);
  end;
  F_Cadastros.show;
=======
  MenuAtivo := taCadastro;
  AjustaVisibilidadeMenuLateral(False);
  if not Assigned(F_Cadastros) then
  begin
    F_Cadastros := TF_Cadastros.create(Self);
    F_Cadastros.show;
  end;
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
end;

procedure TF_BaseMenu.recMenuLateralInicioClick(Sender: TObject);
begin
  inherited;
<<<<<<< HEAD
=======
  MenuAtivo := taHome;
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
  AjustaVisibilidadeMenuLateral(False);
  GoToHome;
end;

<<<<<<< HEAD
procedure TF_BaseMenu.GoToHome();
=======
procedure TF_BaseMenu.GoToHome;
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
var
  I: Integer;
  Form: TForm;
begin
  for I := Screen.FormCount - 1 downto 0 do
  begin
    Form := TForm(Screen.Forms[I]);
    if (Form <> Application.MainForm) then
      Form.Close;
  end;
end;

procedure TF_BaseMenu.recMenuLateralSairClick(Sender: TObject);
begin
  inherited;
<<<<<<< HEAD
  Application.CreateForm(TF_Login, F_Login);
  Application.MainForm := F_Login;
  F_Login.Show;
  GoToHome();
end;

procedure TF_BaseMenu.SetaCorMenuAtivo(const Value: TMenuAtivo);
begin
  case Value of
    maGrafico:   recGrafico.Fill.Color   := COR_ESCURA_MENU;
    maPrincipal: recHome.Fill.Color      := COR_ESCURA_MENU;
    maCadastros: recCadastros.Fill.Color := COR_ESCURA_MENU;
  end;
end;

procedure TF_BaseMenu.SetMenuAtivo(const Value: TMenuAtivo);
begin
  FMenuBottomAtivo := Value;
  InicializaMenuBottom;
  SetaCorMenuAtivo(Value);
=======
  Application.Terminate;
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
end;

end.
