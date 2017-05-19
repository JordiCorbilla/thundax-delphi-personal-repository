//  Copyright (c) 2017, Jordi Corbilla
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

unit thundax.refactoring.example;

interface

uses
  XMLDoc, xmldom, XMLIntf, msxmldom, IdHTTP, IdIOHandler, IdIOHandlerStream,
  IdIOHandlerSocket, IdIOHandlerStack, IDGlobal, Activex,
  IdSSL, IdSSLOpenSSL, MSHTML, generics.collections;

type
  TMyQuery = class(TObject)
    function Results(url : string) : TList<string>;
    function ResultsImperativeRefactoring(url : string) : TList<string>;
    function ParseHTML(response : string) : TList<string>;
  end;

implementation

{ TMyQuery }

function TMyQuery.ParseHTML(response: string): TList<string>;
var
  document: OleVariant;
  i : integer;
  element: OleVariant;
  value : string;
  urlList : TList<string>;
begin
  document := coHTMLDocument.Create as IHTMLDocument2;
  document.write(response);
  document.close;
  urlList := TList<string>.create();
  for i := 0 to document.body.all.length - 1 do
  begin
    element := document.body.all.item(i);
    if (element.tagName = 'A') then //the <a> anchors
      urlList.Add(element.href); //get the url
  end;
  result := urlList;
end;

function TMyQuery.Results(url: string): TList<string>;
var
  response: string;
  IdHTTP: TIdHTTP;
  IdIOHandler: TIdSSLIOHandlerSocketOpenSSL;
  document: OleVariant;
  i : integer;
  element: OleVariant;
  value : string;
  urlList : TList<string>;
begin
  CoInitialize(nil);
  try
    IdIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    IdIOHandler.ReadTimeout := IdTimeoutInfinite;
    IdIOHandler.ConnectTimeout := IdTimeoutInfinite;
    IdHTTP := TIdHTTP.Create(nil);
    try
      IdHTTP.IOHandler := IdIOHandler;
      response := IdHTTP.Get(url);
      document := coHTMLDocument.Create as IHTMLDocument2;
      document.write(response);
      document.close;
      urlList := TList<string>.create();
      for i := 0 to document.body.all.length - 1 do
      begin
        element := document.body.all.item(i);
        if (element.tagName = 'A') then //the <a> anchors
          urlList.Add(element.href); //get the url
      end;
      result := urlList;
    finally
      IdIOHandler.Free;
      IdHTTP.Free;
    end;
  finally
    CoUninitialize;
  end;
end;

function TMyQuery.ResultsImperativeRefactoring(url: string): TList<string>;
var
  response: string;
  IdHTTP: TIdHTTP;
  IdIOHandler: TIdSSLIOHandlerSocketOpenSSL;
begin
  CoInitialize(nil);
  try
    IdIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    IdIOHandler.ReadTimeout := IdTimeoutInfinite;
    IdIOHandler.ConnectTimeout := IdTimeoutInfinite;
    IdHTTP := TIdHTTP.Create(nil);
    try
      IdHTTP.IOHandler := IdIOHandler;
      response := IdHTTP.Get(url);
      result := ParseHTML(response);
    finally
      IdIOHandler.Free;
      IdHTTP.Free;
    end;
  finally
    CoUninitialize;
  end;
end;

end.
