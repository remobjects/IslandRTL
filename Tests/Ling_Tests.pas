namespace RemObjects.Elements.Island.Tests;
{$DEFINE COMPILEBREAK}
interface

uses
  RemObjects.Elements.EUnit;

type
  Linq_Tests = public class(Test)
  private

   public
    method SingleWhere;
    method MultiWhere;
    method TestOrderBy;
    method TestOrderByDesc;

    method TestOrderByMulti;
    method TestJoin;
  end;


implementation

method Linq_Tests.SingleWhere;
begin
  var Users :=
     from User in Test_Data.PrepareUsers
     Where User.Age ≥ 20;
   Assert.AreEqual(Users.Count, 4);

end;

method Linq_Tests.MultiWhere;
begin
  var Users :=
     from User in Test_Data.PrepareUsers
     Where (User.Age ≥ 20) and (User.HomeCountry = 'USA');
   Assert.AreEqual(Users.Count, 2);
   Var UserArray := Users.ToArray;
  Assert.AreEqual(UserArray[0].ID, 1);
  Assert.AreEqual(UserArray[1].ID, 2);
end;

method Linq_Tests.TestOrderBy;
begin
  var Users :=
       from User in Test_Data.PrepareUsers
        Order by User.Age;
  for each User in Users index i do
   begin
    case i  of
      0 : Assert.AreEqual(User.Age, 8, $'Wrong Age in {i} is {User.Age}');
      1 : Assert.AreEqual(User.Age, 19, $'Wrong Age in {i} is {User.Age}');
      2 : Assert.AreEqual(User.Age, 20, $'Wrong Age in {i} is {User.Age}');
      3 : Assert.AreEqual(User.Age, 32, $'Wrong Age in {i} is {User.Age}');
    end;
   end;

end;

method Linq_Tests.TestOrderByDesc;
begin
  var Users :=
       from User in Test_Data.PrepareUsers
        Order by User.Age desc;
  for each User in Users index i do
    begin
    case i  of
      0 : Assert.AreEqual(User.Age, 42, $'Wrong Age in {i} is {User.Age}');
      1 : Assert.AreEqual(User.Age, 38, $'Wrong Age in {i} is {User.Age}');
      2 : Assert.AreEqual(User.Age, 32, $'Wrong Age in {i} is {User.Age}');
      3 : Assert.AreEqual(User.Age, 20, $'Wrong Age in {i} is {User.Age}');
    end;
  end;

end;

method Linq_Tests.TestOrderByMulti;
begin
  var Users :=
       from User in Test_Data.PrepareUsers
        Order by User.HomeCountry,  User.Age;

  for each User in Users index i do
    begin
    case i  of
      0 : Assert.AreEqual(User.Age, 32, $'Wrong Age in {i} is {User.ToString}');
      1 : Assert.AreEqual(User.Age, 19, $'Wrong Age in {i} is {User.ToString}');
      2 : Assert.AreEqual(User.Age, 20, $'Wrong Age in {i} is {User.ToString}');
      3 : Assert.AreEqual(User.Age, 8, $'Wrong Age in {i} is {User.ToString}');
    end;
  end;

end;

method Linq_Tests.TestJoin;
begin
 {$IFDEF COMPILEBREAK}
  var lJoinList :=
      from User in Test_Data.PrepareUsers
      order by User.HomeCountry
      join Company in Test_Data.PrepareCompanies on User.Company equals Company.ID
      select new class (CompanyName := Company.Name , Employe := User)// into P
    //  where P.CompanyName = 'USA'
    ;

  for each entry in lJoinList index i do begin
    case i  of
      0 : Assert.AreEqual(entry.CompanyName, 'Remobjects');
    end;
   end;
 {$ENDIF}
end;
end.