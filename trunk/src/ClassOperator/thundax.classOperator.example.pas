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

unit thundax.classOperator.example;

interface

//Only valid for records
//List of operators
//Add        Binary   Add(a: type; b: type): resultType;         +
//Subtract   Binary   Subtract(a: type; b: type) : resultType;   -
//Multiply   Binary   Multiply(a: type; b: type) : resultType;   *
//Divide     Binary   Divide(a: type; b: type) : resultType;     /
//IntDivide  Binary   IntDivide(a: type; b: type): resultType;   div
//Modulus    Binary   Modulus(a: type; b: type): resultType;     mod
//LeftShift  Binary   LeftShift(a: type; b: type): resultType;   shl
//RightShift Binary   RightShift(a: type; b: type): resultType;  shr
//LogicalAnd Binary   LogicalAnd(a: type; b: type): resultType;  and
//LogicalOr  Binary   LogicalOr(a: type; b: type): resultType;   or
//LogicalXor Binary   LogicalXor(a: type; b: type): resultType;  xor
//BitwiseAnd Binary   BitwiseAnd(a: type; b: type): resultType;  and
//BitwiseOr  Binary   BitwiseOr(a: type; b: type): resultType;   or
//BitwiseXor Binary   BitwiseXor(a: type; b: type): resultType;  xor

type
   TMyRecord = record
     value : integer;
     class operator Add(a, b: TMyRecord): TMyRecord;      // Addition of two operands of type TMyRecord
     class operator Subtract(a, b: TMyRecord): TMyRecord; // Subtraction of type TMyRecord
     class operator Implicit(a: Integer): TMyRecord;      // Implicit conversion of an Integer to type TMyRecord
     class operator Implicit(a: TMyRecord): Integer;      // Implicit conversion of TMyRecordto Integer
     class operator Explicit(a: Double): TMyRecord;       // Explicit conversion of a Double to TMyRecord
     class operator Equal(a, b: TMyRecord): Boolean;      // Equality operand
     class operator NotEqual(a, b: TMyRecord): Boolean;   // Inequality operand
     class operator Multiply(a, b: TMyRecord): TMyRecord;
     class operator IntDivide(a, b: TMyRecord): TMyRecord;
   end;

implementation

class operator TMyRecord.Add(a, b: TMyRecord): TMyRecord;
begin
  result.value := a.value + b.value;
end;

class operator TMyRecord.IntDivide(a, b: TMyRecord): TMyRecord;
begin
  result.value := a.value div b.value;
end;

class operator TMyRecord.Equal(a, b: TMyRecord): Boolean;
begin
  Result := a.value = b.value;
end;

class operator TMyRecord.Explicit(a: Double): TMyRecord;
begin
  result.value := Round(a);
end;

class operator TMyRecord.Implicit(a: Integer): TMyRecord;
begin
  result.value := a;
end;

class operator TMyRecord.Implicit(a: TMyRecord): Integer;
begin
  result := a.value;
end;

class operator TMyRecord.Multiply(a, b: TMyRecord): TMyRecord;
begin
  result.value := a.value * b.value;
end;

class operator TMyRecord.NotEqual(a, b: TMyRecord): Boolean;
begin
  Result := a.value <> b.value;
end;

class operator TMyRecord.Subtract(a, b: TMyRecord): TMyRecord;
begin
  Result := a.value - b.value;
end;

end.
