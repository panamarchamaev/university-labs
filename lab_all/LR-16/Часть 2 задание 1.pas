type anketa = record
  fio : string;
  birth: string;
  kurs: 1..5;
end;
var student:anketa;
begin
  readln(student.fio);
  readln(student.birth);
  student.kurs:=2;
  writeln(student.fio,'/',student.birth,'/',student.kurs);
end.



