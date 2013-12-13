program Prova (input, output);
var i, res : integer;

procedure p (n : integer; var fat:integer);
begin
   if (n=1) then
      fat:=1
   else
   begin
      p(n-1, fat);
      fat:=n*fat
   end
end;

begin
   read (i);
   p(i, res);
   write(i, res)
end.

   