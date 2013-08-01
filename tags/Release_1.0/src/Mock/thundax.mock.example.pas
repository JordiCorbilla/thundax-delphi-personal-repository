//  Copyright (c) 2012-2013, Jordi Corbilla
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  - Redistributions of source code must retain the above copyright notice,
//    this list of conditions and the following disclaimer.
//  - Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//  - Neither the name of this library nor the names of its contributors may be
//    used to endorse or promote products derived from this software without
//    specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.

unit thundax.mock.example;

interface

type
  TFuncParam<T, TResult> = reference to function(arg : T) : TResult;
  TFunc<T> = reference to function() : T;

  //Contract definition to be Mocked.
  IServer<T, TResult> = Interface
    //Send structure
    function GetSendMessage() : TFuncParam<T, TResult>;
    procedure SetSendMessage(const Value: TFuncParam<T, TResult>);
    property SendMessage : TFuncParam<T, TResult> read GetSendMessage write SetSendMessage;
    //Receive structure
    function GetReceiveMessage() : TFunc<T>;
    procedure SetReceiveMessage(const Value: TFunc<T>);
    property ReceiveMessage : TFunc<T> read GetReceiveMessage write SetReceiveMessage;
  End;

  //Class implementation to be Mocked
  TServer = class(TInterfacedObject, IServer<String,Boolean>)
  private
    FSendMessage : TFuncParam<String, Boolean>;
    FGetMessage : TFunc<String>;
    function GetSendMessage() : TFuncParam<String, Boolean>;
    procedure SetSendMessage(const Value: TFuncParam<String, Boolean>);
    function GetReceiveMessage() : TFunc<String>;
    procedure SetReceiveMessage(const Value: TFunc<String>);
    function SendServerMessage(message : String) : Boolean;
    function ReceiveServerMessage() : String;
  public
    property SendMessage : TFuncParam<String, Boolean> read GetSendMessage write SetSendMessage;
    property ReceiveMessage : TFunc<String> read GetReceiveMessage write SetReceiveMessage;
    constructor Create();
  end;

  TProtocolServer = class(TObject)
  private
    FServer: IServer<String, Boolean>;
    procedure SetServer(const Value: IServer<String, Boolean>);
  public
    property Server : IServer<String, Boolean> read FServer write SetServer;
    constructor Create(Server : IServer<String, Boolean>);
    destructor Destroy; override;
    function Communicate(): Boolean;
  end;

implementation

{ TServer<T, TResult> }

constructor TServer.Create;
begin
  SendMessage := SendServerMessage;
  ReceiveMessage := ReceiveServerMessage;
end;

function TServer.GetReceiveMessage: TFunc<String>;
begin
  Result := FGetMessage;
end;

function TServer.GetSendMessage: TFuncParam<String, Boolean>;
begin
  Result := FSendMessage;
end;

function TServer.ReceiveServerMessage: String;
begin
  Result := 'This is the message from the server!';
end;

function TServer.SendServerMessage(message: String): Boolean;
begin
  Result := ('Message from Client' = message);
end;

procedure TServer.SetReceiveMessage(const Value: TFunc<String>);
begin
  FGetMessage := Value;
end;

procedure TServer.SetSendMessage(const Value: TFuncParam<String, Boolean>);
begin
  FSendMessage := Value;
end;

{ TProtocolServer<T, TResult> }

function TProtocolServer.Communicate : Boolean;
var
  bStatus : Boolean;
begin
  bStatus := false;
  if FServer.SendMessage('Message from Client') = true then
    bStatus := (FServer.ReceiveMessage() = 'This is the message from the server!');
  Result := bStatus;
end;

constructor TProtocolServer.Create(Server: IServer<String, Boolean>);
begin
  SetServer(Server);
end;

destructor TProtocolServer.Destroy;
begin
  FServer := nil;
  inherited;
end;

procedure TProtocolServer.SetServer(const Value: IServer<String, Boolean>);
begin
  FServer := Value;
end;

end.
