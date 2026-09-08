type
    PNode = ^Node;
    Node = record
        data: integer;
        next: PNode;
    end;

var
    Head: PNode;
    i: integer;
    Current, NewNode: PNode;

//Создание нового узла
function CreateNode(Value: integer): PNode;
var NewNode: PNode;
begin
    New(NewNode);
    NewNode^.data := Value;
    NewNode^.next := nil;
    Result := NewNode;
end;

//Добавление элемента в конец списка
procedure AddToEnd(var Head: PNode; Value: integer);
var Current: PNode;
    NewNode: PNode;
begin
    NewNode := CreateNode(Value);
    
    if Head = nil then
        Head := NewNode
    else begin
        Current := Head;
        while Current^.next <> nil do
            Current := Current^.next;
        Current^.next := NewNode;
    end;
end;

//Вывод всего списка
procedure PrintList(Head: PNode);
var Current: PNode;
begin
    if Head = nil then
        writeln('Список пуст')
    else begin
        Current := Head;
        while Current <> nil do begin
            write(Current^.data, ' ');
            Current := Current^.next;
        end;
        writeln;
    end;
end;

//Вывод максимума и минимума
procedure PrintEvenElements(Head: PNode);
var Current: PNode;

    Max,Min:integer;
begin
  Max:=0;
  Min:=10;
    if Head = nil then
        writeln('Список пуст')
    else begin
        Current := Head;
        
        writeln('Максимум и минимум:');
        
        while Current <> nil do begin
            if Current^.data > Max  then begin
               Max:=Current^.data;
            end; 
            if Current^.data < Min then begin
            Min:=Current^.data;
            end;
            Current := Current^.next;
        end;
        
        end;        
        write(Max,' и ',Min);
       
    
end;

// Основная программа
begin
    Head := nil;
    
  
    randomize;
    
 
    writeln('Создание списка из 10 случайных элементов:');
    for i := 1 to 10 do begin
        AddToEnd(Head, random(100) + 1);
    end;
    
  
    writeln('Весь список:');
    PrintList(Head);
    writeln;
    

    PrintEvenElements(Head);
    

end.