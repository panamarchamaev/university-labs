begin
  var q:=ReadInteger;
  var a:=arrrandominteger(q);
  a[:].Println();
  var n:=ReadInteger('Введите число n');
  a:= a[:a.IndexMin] + arr(n) + a[a.IndexMin:];
  a.Println();
  
end.