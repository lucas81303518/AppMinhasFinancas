unit UF_Principal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Layouts, FMX.ListBox, UF_BaseMenu,
  funcoes;

type
  TF_Principal = class(TF_BaseMenu)
    S: TRectangle;
    Label1: TLabel;
    Rectangle1: TRectangle;
    imageOlhoSaldoAtual: TImage;
    lblSaldoAtual: TLabel;
    RecGastoMes: TRectangle;
    Label2: TLabel;
    Rectangle3: TRectangle;
    ImageOlhoGastoMes: TImage;
    lblGastoMes: TLabel;
    recMetas: TRectangle;
    Label3: TLabel;
    lbMetas: TListBox;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Principal: TF_Principal;

implementation

uses
  Dmodulo;

{$R *.fmx}

{ TF_Principal }

procedure TF_Principal.FormCreate(Sender: TObject);
begin
  MenuAtivo := TMenuAtivo.maPrincipal;
  inherited;
end;

end.

