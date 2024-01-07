unit uClienteReq;

interface

uses
   System.JSON, uClienteModel, System.Classes, IdHTTP, REST.Json;

type
   TClienteReq = class
   private
      function PerformHTTPRequest(const URL, UserName, Password, RequestMethod: string; out sError: string; RequestContent: TStream = nil): TJSONArray;
   public
      constructor Create();
      destructor Destroy();
      procedure Get(id: string; out sError: string);
      function Post(cliente: TClienteModel; out sError: string): Boolean;
      function Put(cliente: TClienteModel; out sError: string): Boolean;
      function Delete(id: Integer; out sError: string): Boolean;
   end;

implementation

uses
   System.SysUtils;

const
   userServer = 'ADMIN';
   passServer = '123456';
   URL = 'http://LOCALHOST:8080/datasnap/rest/';
   Resource = 'TUserControl/User';

{ TClienteReq }


{ TClienteReq }

constructor TClienteReq.Create;
begin
   //DMCliente := TDMCliente.Create(nil);
end;

function TClienteReq.Delete(id: Integer; out sError: string): Boolean;
var
   endpoint: string;
   JsonArray: TJSONArray;
begin
   if id = 0 then
   begin
      sError := 'Informar o ID';
      abort;
   end;

   endpoint := URL + Resource + '/' + id.ToString();

   try
      JsonArray := PerformHTTPRequest(endpoint, userServer, passServer, 'DELETE', sError);
   except
      on E: Exception do
      begin
         sError := E.Message;
      end;
   end;
end;

destructor TClienteReq.Destroy;
begin
   //FreeAndNil(DMCliente);
end;

function TClienteReq.Post(cliente: TClienteModel; out sError: string): Boolean;
var
   endpoint: string;
   RequestContent: TStringStream;
   JsonArray: TJSONArray;
begin
   if cliente.Nome = '' then
   begin
      sError := 'Informar o edDataCadastro';
      abort;
   end;

   if sError <> '' then
   begin
      endpoint := URL + Resource;

      RequestContent := TStringStream.Create('{"nome":"' + cliente.Nome + '","tpdocto":"' + cliente.TpDocto + '","docto":"' + cliente.Docto + '","telefone":"' + cliente.Telefone + '"', TEncoding.UTF8);

      try
         JsonArray := PerformHTTPRequest(endpoint, userServer, passServer, 'POST', sError, RequestContent);
      except
         on E: Exception do
         begin
            sError := E.Message;
         end;
      end;
   end;

   RequestContent.Free;
end;

procedure TClienteReq.Get(id: string; out sError: string);
var
   endpoint: string;
   JsonArray: TJSONArray;
   I, j: Integer;
   Cliente: TClienteModel;
   Clientes: TArray<TClienteModel>;
   ClienteValue: TJSONValue;
begin
   endpoint := URL + Resource;
   try
      if id <> '' then
         endpoint := endpoint + '?' + 'ID=' + id;

      JsonArray := PerformHTTPRequest(endpoint, userServer, passServer, 'GET', sError);

      if JsonArray <> nil then
      begin
         SetLength(Clientes, JsonArray.Count);

         for I := 0 to JsonArray.Count - 1 do
         begin
            ClienteValue := (JsonArray.Items[I] as TJSONObject).GetValue('user');

            if Assigned(ClienteValue) then
            begin
               if ClienteValue is TJSONArray then
               begin
                  if TJSONArray(ClienteValue).Count > 0 then
                  begin
                     for j := 0 to TJSONArray(ClienteValue).Count - 1 do
                     begin
                        Cliente := TJson.JsonToObject<TClienteModel>(TJSONArray(ClienteValue).Items[j].ToJSON);
                        Clientes[j] := Cliente;
                     end;
                  end
                  else
                  begin
                     sError := 'Array "user" vazio.';
                  end;
               end
               else if ClienteValue is TJSONString then
               begin
                  sError := 'Valor de User como string: ' + (ClienteValue as TJSONString).Value;
                  Continue;
               end
               else
               begin
                  sError := 'Valor inesperado para o campo "user".';
               end;
            end
            else
            begin
               sError := 'Campo "user" não encontrado.';
            end;
         end;
      end;
   except
      on E: Exception do
      begin
         sError := E.Message;
      end;
   end;
end;

function TClienteReq.Put(cliente: TClienteModel; out sError: string): Boolean;
var
   endpoint: string;
   RequestContent: TStringStream;
   JsonArray: TJSONArray;
begin
   if cliente.ID.ToString() = '' then
   begin
      sError := 'Informar o ID';
      abort;
   end;
   if cliente.Nome = '' then
   begin
      sError := 'Informar o Nome';
      abort;
   end;

   endpoint := URL + Resource + '/' + cliente.ID.ToString();
   RequestContent := TStringStream.Create('{"nome":"' + cliente.Nome + '","tpdocto":"' + cliente.TpDocto + '","docto":"' + cliente.Docto + '","telefone":"' + cliente.Telefone + '"', TEncoding.UTF8);

   try
      JsonArray := PerformHTTPRequest(endpoint, userServer, passServer, 'PUT', sError, RequestContent);
   except
      on E: Exception do
      begin
         sError := E.Message;
      end;
   end;

   RequestContent.Free;
end;

function TClienteReq.PerformHTTPRequest(const URL, UserName, Password, RequestMethod: string; out sError: string; RequestContent: TStream = nil): TJSONArray;
var
   IdHTTP1: TIdHTTP;
   ResponseContent: string;
   JsonValue: TJSONValue;
   ResultArray: TJSONArray;
   ResultObject: TJSONObject;
   Detalhe: string;
   ResultValue: TJSONValue;
begin
   IdHTTP1 := TIdHTTP.Create(nil);

   try
      try
         with IdHTTP1 do
         begin
            ConnectTimeout := 10000;
            Request.Clear;
            Request.BasicAuthentication := True;
            Request.Username := UserName;
            Request.Password := Password;
         end;

         if Assigned(RequestContent) then
         begin
            if RequestMethod = 'PUT' then
               ResponseContent := IdHTTP1.Put(URL, RequestContent)
            else
               ResponseContent := IdHTTP1.Post(URL, RequestContent);
         end
         else if RequestMethod = 'DELETE' then
            ResponseContent := IdHTTP1.Delete(URL)
         else
         begin
            ResponseContent := IdHTTP1.Get(URL);
         end;

         JsonValue := TJSONObject.ParseJSONValue(ResponseContent);

         if Assigned(JsonValue) and (JsonValue is TJSONObject) then
         begin
            ResultArray := (JsonValue as TJSONObject).GetValue('result') as TJSONArray;

            if Assigned(ResultArray) then
            begin
               if ResultArray.Count > 0 then
               begin
                  ResultObject := ResultArray.Items[0] as TJSONObject;
                  if ResultObject.TryGetValue<TJSONValue>('result', ResultValue) then
                  begin
                     if ResultValue.TryGetValue<string>('detalhe', Detalhe) then
                     begin
                        sError := Detalhe;
                     end
                     else
                     begin
                        sError := 'Detalhe não encontrado no JSON.';
                     end;
                  end
                  else
                  begin
                     result := ResultArray;
                  end;
               end
               else
               begin
                  sError := 'Resposta inesperada do serviço - array vazio.';
               end;
            end
            else
            begin
               sError := 'Resposta inesperada do serviço - "result" não encontrado.';
            end;
         end
         else
         begin
            sError := 'Erro na solicitação: ' + IdHTTP1.ResponseText;
         end;
      except
         on E: Exception do
         begin
            sError  := 'Erro: ' + E.Message;
         end;
      end;
   finally
      IdHTTP1.Free;
   end;
end;

end.

