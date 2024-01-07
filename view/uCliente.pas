unit uCliente;

interface

uses
   Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
   System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBase,
   Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,
   Vcl.ComCtrls, uClienteModel, uClienteController;

type
   TfrmCliente = class(TfrmBase)
      lbledtTelefone: TLabeledEdit;
      cbTpDocumento: TComboBox;
      lbledtDocumento: TLabeledEdit;
      lbTpDocumento: TLabel;
      lbledtNome: TLabeledEdit;
      procedure gdrListDblClick(Sender: TObject);
      procedure sbDetailClick(Sender: TObject);
      procedure sbSaveClick(Sender: TObject);
      procedure sbEditClick(Sender: TObject);
      procedure sbDeleteClick(Sender: TObject);
      procedure FormDestroy(Sender: TObject);
      procedure FormCreate(Sender: TObject);
      procedure FormShow(Sender: TObject);
      procedure sbSearchClick(Sender: TObject);
   private
      oCliente: TClienteModel;
      oClienteController: TClienteController;
      procedure Detail;
      procedure Load;
      procedure Gravar;
      procedure Search;
      procedure toNew;
      procedure toAlter;
      procedure EnableControls(aOperation: TOperation); overload;
      procedure Delete;
      procedure Initialized;
    { Private declarations }
   public
    { Public declarations }
   end;

var
   frmCliente: TfrmCliente;

implementation

{$R *.dfm}

procedure TfrmCliente.Detail;
begin
   Load;
end;

procedure TfrmCliente.EnableControls(aOperation: TOperation);
begin
   lbledtNome.Enabled := (aOperation in [opNew, opAlter]);
   lbledtDocumento.Enabled := (aOperation in [opNew, opAlter]);
   lbledtTelefone.Enabled := (aOperation in [opNew, opAlter]);
   inherited;
end;

procedure TfrmCliente.FormCreate(Sender: TObject);
begin
   inherited;
   Initialized();
end;

procedure TfrmCliente.FormDestroy(Sender: TObject);
begin
   inherited;
   FreeAndNil(oCliente);
   FreeAndNil(oClienteController);
end;

procedure TfrmCliente.FormShow(Sender: TObject);
begin
   inherited;
   Search;
end;

procedure TfrmCliente.Initialized;
begin
   oCliente := TClienteModel.Create;
   oClienteController := TClienteController.Create;
   DesignOperation(opSearch);
end;

procedure TfrmCliente.gdrListDblClick(Sender: TObject);
begin
   Detail;
   inherited;
end;

procedure TfrmCliente.Load;
var
   ClienteID: Integer;
   sError: string;
begin
   ClienteID := dsSearch.dataset.FieldByName('ID').AsInteger;
   oClienteController.Load(oCliente, ClienteID, sError);
   if Assigned(oCliente) then
   begin
      lbledtCodigo.Text := oCliente.ID.ToString;
      lbledtNome.Text := oCliente.Nome;
      lbledtDocumento.Text := oCliente.Docto;
      lbledtTelefone.Text := oCliente.Telefone;
   end;
end;

procedure TfrmCliente.Delete;
var
   sError: string;
begin
   if (DMCliente.cdsSearch.Active) and (DMCliente.cdsSearch.RecordCount > 0) then
   begin
      if MessageDlg('Deseja realmente excluir este cliente', mtConfirmation, [mbYes, mbNo], 0) = IdYes then
         if (oClienteController.Delete(DMCliente.cdsSearchID.AsInteger, sError)) = true then
         begin
            showmessage('Excluído com sucesso');
         end
         else
         begin
            raise Exception.Create(sError);
         end;
      oClienteController.Search(lbledtSearch.Text);
   end
   else
      raise Exception.Create('Não há registro para ser excluído');
end;

procedure TfrmCliente.sbDeleteClick(Sender: TObject);
begin
   Delete();
   inherited;
end;

procedure TfrmCliente.sbDetailClick(Sender: TObject);
begin
   Detail;
   inherited;
end;

procedure TfrmCliente.sbEditClick(Sender: TObject);
begin
   Detail;
   inherited;
end;

procedure TfrmCliente.sbSaveClick(Sender: TObject);
begin
   inherited;
   Gravar;
end;

procedure TfrmCliente.sbSearchClick(Sender: TObject);
begin
   inherited;
   Search();
end;

procedure TfrmCliente.toAlter;
var
   sError: string;
begin
   with oCliente do
   begin
      ID := StrToIntDef(lbledtCodigo.text, 0);
      Nome := lbledtNome.Text;
      Docto := lbledtDocumento.Text;
      Telefone := lbledtTelefone.Text;
   end;
   if not oClienteController.Update(oCliente, sError) then
      raise Exception.Create(sError);
end;

procedure TfrmCliente.Gravar;
begin
   try
      case FOperation of
         opNew:
            toNew;
         opAlter:
            toAlter;
      end;
      oClienteController.Search(lbledtSearch.Text);
   except
      on E: Exception do


   end;

   ClearFields();
   if FOperation = opNew then
   begin
      if MessageDlg('Salvo com sucesso. Deseja incluir mais?', mtConfirmation, [mbYes, mbNo], 0) = IdYes then
         DesignOperation(opNew)
      else
      begin
         DesignOperation(opSearch);
         Search;
      end;
   end
   else
   begin
      showmessage('Editado com sucesso');
      DesignOperation(opSearch);
      Search;
   end;
end;

procedure TfrmCliente.Search;
begin
   oClienteController.Search(lbledtSearch.Text);
end;

procedure TfrmCliente.toNew;
var
   sError: string;
begin
   with oCliente do
   begin
      ID := 0;
      Nome := lbledtNome.Text;
      Docto := lbledtDocumento.Text;
      Telefone := lbledtTelefone.Text;
   end;
   if (oClienteController.Insert(oCliente, sError)) = false then
      raise Exception.Create(sError);
end;

end.

