namespace RemObjects.Elements.Island.Tests;
type
  TUser = public class
  public
    property ID : Integer;
    property Name : String;
    property Age : Integer;
    property HomeCountry : String;
    property Company : Integer;

    constructor (aID : Integer; aName : String; aAge : Integer; aHomeCountry : String; aCompany : Integer);
    begin
      ID := aID;
      Name := aName;
      Age := aAge;
      HomeCountry := aHomeCountry;
      Company := aCompany;
    end;

    [ToString]
    method ToString : String;
    begin
      exit $"ID: {ID}, Name: {Name}, Age: {Age}, Country : {HomeCountry}, CompanyId: {Company}";
    end;

  end;

  TCompany = public class
  public
  property ID : Integer;
  property Name : String;
  property HomeCountry : String;



  constructor (aID : Integer; aName : String; aHomeCountry : String);
  begin
    Name := aName;
    ID := aID;
    HomeCountry := aHomeCountry;
  end;
end;


  Test_Data =  static class
  public
   method PrepareUsers : List<TUser>;
    begin
      exit new List<TUser>([
      new TUser(1,'John Doe', 42, 'USA',1),
      new TUser(2,'Jane Doe', 38, 'USA',2),
      new TUser(3,'Joe Doe', 20, 'Germany',3),
      new TUser(4,'Jenna Doe', 19, 'Germany',4),
      new TUser(5,'Marc Hofmann', 32, 'Curacao',1),
      new TUser(6,'James Doe', 8, 'USA',6)
      ]);

    end;

    method PrepareCompanies : List<TCompany>;
    begin
      exit new List<TCompany>([
      new TCompany(1,'Remobjects', 'USA'),
      new TCompany(2,'Apple', 'USA'),
      new TCompany(3,'Microsoft', 'USA'),
      new TCompany(4,'Huawei', 'China'),
      new TCompany(5,'Nixdorf', 'Germany'),
      new TCompany(6,'SAP', 'Germany')
      ]);

    end;

  end;

end.