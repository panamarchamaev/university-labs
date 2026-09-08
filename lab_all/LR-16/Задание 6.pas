begin
  var n:=ReadInteger;
  var a:=arrrandominteger(n,-5,20);
  a.println();
  var L1:= new List<integer>;
  var L2:= new List<integer>;
  
  foreach var x in a do
    if x>0 then
      L1+= x
    else L2+=x;
    
    L1.Println;
    L2.Println;
end.