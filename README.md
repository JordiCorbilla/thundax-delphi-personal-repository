bits and pieces from everyday coding
==============
**Thundax repository contains Delphi examples on:**
  - Mock Objects
  - Custom Attributes
  - Fluent interfaces
  - Regular Expressions
  - UML Diagrams
  - Logging
  - Design Patterns
  - Code Coverage
  - Class Operator
  - Class Helper
  - Multi-threading
  - Anonymous methods
  - Unit testing
  - Profiling
  - Debugging
  - Plotting

Feel free to use them to improve your applications.

**Mimicking LINQ:** 

```delphi
function TQueryImplementation.GetIntegerListQueryValues: TList<Integer>;
var
  IqueryList : IQueryList<Integer, Boolean>;
  item : integer;
begin
  Result := TList<Integer>.Create;
  IqueryList := TQueryList<Integer, Boolean>
    .New()
    .FillList(function ( list : TList<Integer> ) : Boolean
              var k : integer;
              begin
                for k := 0 to 100 do
                  list.Add(Random(100));
                result := true;
              end);

  //Display filtered values
  for item in IqueryList
    .Select(function ( list : TList<Integer> ) : TList<Integer>
              var
                k : integer;
                selectList : TList<Integer>;
              begin
                selectList := TList<Integer>.Create;
                for k := 0 to list.Count-1 do
                begin
                  if Abs(list.items[k]) > 0 then
                    selectList.Add(list.items[k]);
                end;
                list.Free;
                result := selectList;
              end)
    .Where(function ( i : integer) : Boolean
          begin
            result := (i > 50);
          end)
    .Where(function ( i : integer) : Boolean
          begin
            result := (i < 75);
          end)
    .OrderBy(TComparer<integer>.Construct(
         function (const L, R: integer): integer
         begin
           result := L - R; //Ascending
         end
     )).Distinct.List do
          result.add(item);
end;
```

**Example DUnit:**
  - ![](http://1.bp.blogspot.com/-mb1KplJPRiw/T34MqyCpSeI/AAAAAAAAC8A/yHV49FyXM50/s1600/dunit.png)

**Example using Fluent Interfaces:**
  - ![](http://1.bp.blogspot.com/-84yLJgLe274/T8n9K_orp1I/AAAAAAAAC9A/vSBdhs9upgw/s1600/dunit.png)

**Example using Quick Sequence Diagram Editor (sdedit):**
  - ![](http://4.bp.blogspot.com/-CSdelCTJM2o/UPRixFPjUwI/AAAAAAAADuU/WgYv2FabNV0/s1600/TestDiagramUML.jpg)
