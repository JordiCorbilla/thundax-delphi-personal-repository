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

unit thundax.fluentInterface.example;

interface

uses
  Generics.Collections, Generics.Defaults;

type
  TProc<T> = procedure (n : T) of Object;
  TProcList<T> = procedure (n : TList<T>) of Object;
  TFunc<T> = reference to function() : T;
  TFuncParam<T, TResult> = reference to function(param : T) : TResult;
  TFuncList<T, TResult> = reference to function(n : TList<T>) : TResult;
  TFuncListSelect<T, TResult> = reference to function(n : TList<T>) : TList<T>;

  //Simulation of LINQ
  IQueryList<T, TResult> = interface
    function Where(const param : TFuncParam<T, TResult>) : IQueryList<T, TResult>;
    function OrderBy(const AComparer: IComparer<T>) : IQueryList<T, TResult>;
    function Select(const param : TFuncListSelect<T, TResult>) : IQueryList<T, TResult>;
    function FillList(const param : TFuncList<T, TResult>) : IQueryList<T, TResult>;
    function Distinct() : IQueryList<T, TResult>;
    function List() : TList<T>;
  end;

  TQueryList<T, TResult> = class(TInterfacedObject, IQueryList<T, TResult>)
  private
    FList : TList<T>;
  protected
    function Where(const param : TFuncParam<T, TResult>) : IQueryList<T, TResult>;
    function FillList(const param : TFuncList<T, TResult>) : IQueryList<T, TResult>;
    function Select(const param : TFuncListSelect<T, TResult>) : IQueryList<T, TResult>;
    function Distinct() : IQueryList<T, TResult>;
    function List() : TList<T>;
    function OrderBy(const AComparer: IComparer<T>) : IQueryList<T, TResult>;
  public
    constructor Create();
    destructor Destroy(); override;
    class function New: IQueryList<T, TResult>;
  end;

implementation

constructor TQueryList<T, TResult>.Create();
begin
  FList := TList<T>.Create;
end;

destructor TQueryList<T, TResult>.Destroy;
begin
  if Assigned(FList) then
    FList.Free;
  inherited;
end;

function TQueryList<T, TResult>.Distinct: IQueryList<T, TResult>;
var
  list : TList<T>;
  i : integer;
begin
  list := TList<T>.Create();
  for i := 0 to FList.Count-1 do
  begin
    if not list.Contains(FList[i]) then
      list.Add(FList[i]);
  end;
  FList.Free;
  FList := list;
  result := Self;
end;

function TQueryList<T, TResult>.FillList(const param : TFuncList<T, TResult>): IQueryList<T, TResult>;
begin
  param(FList);
  Result := Self;
end;

function TQueryList<T, TResult>.List: TList<T>;
begin
  result := FList;
end;

class function TQueryList<T, TResult>.New: IQueryList<T, TResult>;
begin
  result := Create;
end;

function TQueryList<T, TResult>.OrderBy(const AComparer: IComparer<T>): IQueryList<T, TResult>;
begin
  FList.Sort(AComparer);
  result := Self;
end;

function TQueryList<T, TResult>.Select(const param: TFuncListSelect<T, TResult>): IQueryList<T, TResult>;
begin
  FList := param(FList);
  result := Self;
end;

function TQueryList<T, TResult>.Where(const param: TFuncParam<T, TResult>): IQueryList<T, TResult>;
var
  list : TList<T>;
  i: Integer;
  Comparer: IEqualityComparer<TResult>;
begin
  list := TList<T>.Create();
  for i := 0 to FList.Count-1 do
  begin
    Comparer := TEqualityComparer<TResult>.Default;
    if not Comparer.Equals(Default(TResult), param(FList[i])) then
      list.Add(FList[i]);
  end;
  FList.Free;
  FList := list;
  result := Self;
end;

end.
