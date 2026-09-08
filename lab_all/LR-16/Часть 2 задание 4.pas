type
  toy = record
    name: string;
    price: real;
    age: string;
  end;

var
  toys: array[1..100] of toy;
  f: text;  
  i, n: integer;

begin
 
  n := 4;
  
  with toys[1] do
  begin
    name := 'Конструктор LEGO';
    price := 2499;
    age := '4-7 лет';
  end;
  
  with toys[2] do
  begin
    name := 'Мягкая игрушка "Мишка"';
    price := 899;
    age := '0-3 лет';
  end;
  
  with toys[3] do
  begin
    name := 'Настольная игра "Монополия"';
    price := 1799;
    age := '8+ лет';
  end;
  
  with toys[4] do
  begin
    name := 'Развивающий коврик';
    price := 3299;
    age := '0-1 год';
  end;
  
  Assign(f, 'toys.txt');
  Rewrite(f);
  
  
  writeln(f, n);
  
 
  for i := 1 to n do
  begin
    with toys[i] do
    begin
      writeln(f, name);
      writeln(f, price);
      writeln(f, age);
    end;
  end;
  
  Close(f);
  writeln('Данные успешно записаны в файл toys.txt');
  
 
  writeln;
  writeln('Чтение данных из файла:');

  
  var toysRead: array[1..100] of toy;
  var count: integer;
  
  Assign(f, 'toys.txt');
  Reset(f);
  

  readln(f, count);

  for i := 1 to count do
  begin
    with toysRead[i] do
    begin
      readln(f, name);
      readln(f, price);
      readln(f, age);
    end;
  end;
  
  Close(f);
  

  for i := 1 to count do
  begin
    with toysRead[i] do
    begin
      writeln('Игрушка №', i);
      writeln('  Название: ', name);
      writeln('  Цена: ', price:0:2, ' руб.');
      writeln('  Возрастной диапазон: ', age);

    end;
  end;
end.