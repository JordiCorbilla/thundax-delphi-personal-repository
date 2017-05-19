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

unit thundax.Multithreading.example;

interface

uses
  SyncObjs, Contnrs, Generics.Collections, Classes;

type
  IBruteForce = interface
    function Solve() : string;
  end;

  TBruteForceThreading = class(TInterfacedObject, IBruteForce)
  private
    FCriticalSection: TCriticalSection;
    FCountDown: TCountdownEvent;
    FNumberOfProcessors : Integer;
    FHash : String;
    FSolve : String;
    FSubChar : String;
    function GetNumberProcessors() : integer;
  public
    constructor Create(hash : string);
    class function new(hash : string) : TBruteForceThreading;
    function Solve() : string;
    destructor Destroy(); override;
    class function md5(const text: string): string;
  end;

  TThreadList = TObjectList<TThread>;

const
  chars = 'abcdefghijklmnopqrstuvwxyz';

implementation

uses
  IdHashMessageDigest, SysUtils, Windows, AnsiStrings, thundax.stringHelper,
  IdGlobal;

{ TBruteForceThreading }

constructor TBruteForceThreading.Create(hash: string);
begin
  FHash := hash;
  FCriticalSection := TCriticalSection.Create;
  FNumberOfProcessors := GetNumberProcessors;
  FCountDown := TCountdownEvent.Create(FNumberOfProcessors);
end;

class function TBruteForceThreading.new(hash: string): TBruteForceThreading;
begin
  result := Create(hash);
end;

function TBruteForceThreading.Solve: string;
var
  i : Integer;
  num : integer;
  subChar : string;
  charsTemp : string;
  thread1, threads: TThread;
  threadList : TThreadList;
begin
  charsTemp := chars;
  FSolve := '';
  num := 1;
  while (num <= Length(chars)) and (FSolve = '') do
  begin
    if Length(charsTemp) >= GetNumberProcessors() then
      subChar := TStringHelper.New(charsTemp).Left(FNumberOfProcessors).ToString()
    else
      subChar := TStringHelper.New(charsTemp).Left(Length(charsTemp)).ToString();
    charsTemp := TStringHelper.New(charsTemp).Right(Length(charsTemp)-Length(subChar)).ToString();

    threadList := TThreadList.Create(false);
    try
      for i := 1 to Length(subChar) do
      begin
        FSubChar := subChar[i];
        thread1 := TThread.CreateAnonymousThread(procedure
        var
          m, n, o: integer;
          md5Hash : string;
          hashWord : string;
          found : Boolean;
        begin
          found := (FSolve <> '');
          m := 1;
          while (m <= Length(chars)) and (not found) do
          begin
            found := (FSolve <> '');
            n := 1;
            while (n <= Length(chars)) and (not found) do
            begin
              found := (FSolve <> '');
              o := 1;
              while (o <= Length(chars)) and (not found) do
              begin
                FCriticalSection.Acquire;
                hashWord := FSubChar+chars[m]+chars[n]+chars[o];
                md5Hash := md5(hashWord);
                found := (md5Hash = FHash);
                if found then
                begin
                  FSolve := hashWord;
                  OutputdebugString(PWideChar('Found by :' + Inttostr(thread1.ThreadID)));
                end;
                inc(o);
                FCriticalSection.Release;
              end;
              inc(n);
            end;
            inc(m);
          end;
        end
        );
        threadList.Add(thread1);
        thread1.NameThreadForDebugging(AnsiString('Thread ' + IntToStr(threadList.count)));
        thread1.FreeOnTerminate := false;
        OutputdebugString(PWideChar('Starting :' + Inttostr(thread1.ThreadID) + ' Char: ' + subChar));
        thread1.Start;
      end;

      for threads in threadList do
        threads.WaitFor;

      for threads in threadList do
      begin
        threads.Terminate;
        threads.Free;
      end;
      num := num + Length(subChar);
    finally
      threadList.Free;
    end;
  end;

  result := FSolve;
end;

destructor TBruteForceThreading.Destroy;
begin
  if Assigned(FCriticalSection) then
    FreeAndNil(FCriticalSection);
  if Assigned(FCountDown) then
    FreeAndNil(FCountDown);
  inherited;
end;

function TBruteForceThreading.GetNumberProcessors: integer;
var
  MySystem: TSystemInfo;
begin
  GetSystemInfo(MySystem);
  result := MySystem.dwNumberOfProcessors;
end;

class function TBruteForceThreading.md5(const text: string) : string;
var
  md5 : TIdHashMessageDigest5;
begin
  try
    md5 := TIdHashMessageDigest5.Create;
    Result := LowerCase(md5.HashStringAsHex(text, IndyTextEncoding_OSDefault()));
    md5.Free;
  except
  end;
end;

end.
