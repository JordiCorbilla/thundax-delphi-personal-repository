unit thundax.AbstractFactory;

interface

type
  IAbstractVehicle = interface
    procedure Run();
    function ToString() : string;
  end;

  TCar = class(TInterfacedObject, IAbstractVehicle)
    procedure Run();
    function ToString() : string; override;
  end;

  TTruck = class(TInterfacedObject, IAbstractVehicle)
    procedure Run();
    function ToString() : string; override;
  end;

  TBus = class(TInterfacedObject, IAbstractVehicle)
    procedure Run();
    function ToString() : string; override;
  end;

  TVan = class(TInterfacedObject, IAbstractVehicle)
    procedure Run();
    function ToString() : string; override;
  end;

  TAbstractFactory = class(TObject)
    constructor Create();
    destructor Destroy(); override;
    function CreateCar() : IAbstractVehicle; virtual; abstract;
    function CreateTruck() : IAbstractVehicle; virtual; abstract;
    function CreateBus() : IAbstractVehicle; virtual; abstract;
    function CreateVan() : IAbstractVehicle; virtual; abstract;
  end;

  TVehicleFactory = class(TAbstractFactory)
    constructor Create();
    destructor Destroy(); override;
    function CreateCar() : IAbstractVehicle; override;
    function CreateTruck() : IAbstractVehicle; override;
    function CreateBus() : IAbstractVehicle; override;
    function CreateVan() : IAbstractVehicle; override;
  end;

implementation

{ TCar }

procedure TCar.Run;
begin

end;

function TCar.ToString: string;
begin
  result := 'Car';
end;

{ TTruck }

procedure TTruck.Run;
begin

end;

function TTruck.ToString: string;
begin
  result := 'Truck';
end;

{ TBus }

procedure TBus.Run;
begin

end;

function TBus.ToString: string;
begin
  result := 'Bus';
end;

{ TVan }

procedure TVan.Run;
begin

end;

function TVan.ToString: string;
begin
  result := 'Van';
end;

{ TAbstractFactory }

constructor TAbstractFactory.Create;
begin

end;

destructor TAbstractFactory.Destroy;
begin

  inherited;
end;

{ TVehicleFactory }

constructor TVehicleFactory.Create;
begin

end;

function TVehicleFactory.CreateBus: IAbstractVehicle;
begin
  result := TBus.Create;
end;

function TVehicleFactory.CreateCar: IAbstractVehicle;
begin
  result := TCar.Create;
end;

function TVehicleFactory.CreateTruck: IAbstractVehicle;
begin
  result := TTruck.Create;
end;

function TVehicleFactory.CreateVan: IAbstractVehicle;
begin
  result := TVan.Create;
end;

destructor TVehicleFactory.Destroy;
begin

  inherited;
end;

end.
