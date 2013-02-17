// Copyright (c) 2012-2013, Jordi Corbilla
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// - Redistributions of source code must retain the above copyright notice,
// this list of conditions and the following disclaimer.
// - Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation
// and/or other materials provided with the distribution.
// - Neither the name of this library nor the names of its contributors may be
// used to endorse or promote products derived from this software without
// specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

unit thundax.UML;

interface

uses
  thundax.logging;

type
  TUML = class(TObject)
  private
    FFormat: string;
    FOutFile: TLog;
    FUmlFileName: string;
  public
    property Format: string read FFormat write FFormat;
    constructor Create(umlFileName: string);
    destructor Destroy(); override;
    class function Start(umlFileName: string): TUML;
    procedure Define(name : String; kind : String); overload;
    procedure Define(); overload;
    procedure Call(caller: string; callee: string; method: string; params: string); overload;
    procedure Call(caller: string; callee: string; method: string; params: string; result: string); overload;
    procedure Convert();
  end;

const
  DefaultFormat = 'jpg';
  DefaultLocationLibrary = '..\..\thirdpartylibs\sdedit\sdedit.jar';

implementation

uses
  ShellAPI, Windows;

{ TUML }

procedure TUML.Call(caller, callee, method, params: string);
begin
  FOutFile.print(caller + ':' + callee + '.' + method + '(' + params + ')');
end;

procedure TUML.Call(caller, callee, method, params, result: string);
begin
  FOutFile.print(caller + ':' + result + '=' + callee + '.' + method + '(' + params + ')');
end;

procedure TUML.Convert();
var
  params: string;
  FileINFormat: string;
  FileOutFormat: string;
begin
  FileINFormat := FUmlFileName + '.sdx';
  FileOutFormat := FUmlFileName + '.' + FFormat;
  params := '-jar ' + DefaultLocationLibrary + ' -o ' + FileOutFormat + ' -t ' + FFormat + ' -r landscape ' + FileINFormat;
  ShellExecute(0, nil, 'java.exe', PChar(params), nil, SW_HIDE);
end;

constructor TUML.Create(umlFileName: string);
begin
  FOutFile := TLog.Start(umlFileName + '.sdx');
  FFormat := DefaultFormat;
  FUmlFileName := umlFileName;
end;

procedure TUML.Define;
begin
  FOutFile.print('');
end;

destructor TUML.Destroy;
begin
  FOutFile.Free;
  inherited;
end;

procedure TUML.Define(name, kind: String);
begin
  FOutFile.print(name + ':' + kind);
end;

class function TUML.Start(umlFileName: string): TUML;
begin
  result := Create(umlFileName);
end;

end.
