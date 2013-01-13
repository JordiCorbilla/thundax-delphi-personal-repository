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

unit thundax.logging;

interface

type
  TLog = class(TObject)
  private
    FLogTextFile : TextFile;
  public
    constructor Create(logFileName : string);
    destructor Destroy(); override;
    class function Start(logFileName : string): TLog;
    procedure Print(msg : string);
    procedure ConsoleOutput(msg : string);
    procedure OutputDebug(msg : string);
  end;

implementation

uses
  Windows;

{ TLog }

procedure TLog.ConsoleOutput(msg: string);
begin
  WriteLn(Output, msg);
end;

constructor TLog.Create(logFileName: string);
begin
  AssignFile(FLogTextFile, logFileName);
  ReWrite(FLogTextFile);
end;

destructor TLog.Destroy;
begin
  CloseFile(FLogTextFile);
  inherited;
end;

procedure TLog.OutputDebug(msg: string);
begin
  OutputDebugString(PChar(Msg));
end;

procedure TLog.Print(msg: string);
begin
  Write(FLogTextFile, msg);
end;

class function TLog.Start(logFileName: string): TLog;
begin
  result := Create(logFileName);
end;

end.
