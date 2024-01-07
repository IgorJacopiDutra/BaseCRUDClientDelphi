unit uClienteController;

interface

uses
   uClienteReq, uClienteModel;

type
   TClienteController = class
   public
      ClienteReq: TClienteReq;
      constructor Create();
      destructor Destroy();
      procedure Load(cliente: TClienteModel; id: Integer; out sError: string);
      procedure Search(value: string; out sError: string);
      function Insert(cliente: TClienteModel; out sError: string): Boolean;
      function Update(cliente: TClienteModel; out sError: string): Boolean;
      function Delete(id: Integer; out sError: string): Boolean;
   end;

implementation

uses
   System.SysUtils;

{ TClienteController }


{ TClienteController }

constructor TClienteController.Create;
begin
   ClienteReq := TClienteReq.Create();
end;

function TClienteController.Delete(id: Integer; out sError: string): Boolean;
begin
   result := ClienteReq.Delete(id, sError);
end;

destructor TClienteController.Destroy;
begin
   //FreeAndNil(DMCliente);
end;

function TClienteController.Insert(cliente: TClienteModel; out sError: string): Boolean;
begin
   result := ClienteReq.Post(cliente, sError);
end;

procedure TClienteController.Load(cliente: TClienteModel; id: Integer; out sError: string);
begin
   ClienteReq.Get(id.ToString(), sError);
end;

procedure TClienteController.Search(value: string; out sError: string);
begin
   ClienteReq.Get(value, sError);
end;

function TClienteController.Update(cliente: TClienteModel; out sError: string): Boolean;
begin
   result := ClienteReq.Put(cliente, sError);
end;

end.

