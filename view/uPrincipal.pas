unit uPrincipal;

interface

uses
   Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
   System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
   Vcl.StdCtrls;

type
   TfrmPrincipal = class(TForm)
      btnCliente: TButton;
      procedure btnClienteClick(Sender: TObject);
      procedure FormShow(Sender: TObject);
   private
    { Private declarations }
      procedure OpenCliente();
      procedure ConnectDataBase;
   public
    { Public declarations }
   end;

var
   frmPrincipal: TfrmPrincipal;

implementation

uses
   uCliente;

{$R *.dfm}

procedure TfrmPrincipal.btnClienteClick(Sender: TObject);
begin
   frmCliente := TfrmCliente.Create(nil);
   try
      frmCliente.ShowModal;
   finally
      FreeAndNil(frmCliente);
   end;

end;

procedure TfrmPrincipal.ConnectDataBase;
var
   pathData: string;
begin
   pathData := ExtractFilePath(ParamStr(0));
   pathData := StringReplace(pathData, 'exe\', '', [rfReplaceAll, rfIgnoreCase]);
   pathData := IncludeTrailingPathDelimiter(pathData) + 'data\DATA.FDB';

   with DM do
   begin
      con.Close;

      con.Params.Clear;

      con.Params.Add('DriverID=FB');
      con.Params.Add('Database=' + pathData);
      con.Params.Add('User_Name=SYSDBA');
      con.Params.Add('Password=masterkey');

      con.Open;
   end;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
   ConnectDataBase();
end;

procedure TfrmPrincipal.OpenCliente;
begin

end;

end.

