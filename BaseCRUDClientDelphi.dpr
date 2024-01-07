program BaseCRUDClientDelphi;

uses
  Vcl.Forms,
  uPrincipal in 'View\uPrincipal.pas' {frmPrincipal},
  uClienteModel in 'model\uClienteModel.pas',
  uClienteController in 'controller\uClienteController.pas',
  uBase in 'view\uBase.pas' {frmBase},
  uUsuario in 'view\uUsuario.pas' {frmUsuario},
  uCliente in 'view\uCliente.pas' {frmCliente},
  uClienteReq in 'request\uClienteReq.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TfrmBase, frmBase);
  Application.Run;
end.
