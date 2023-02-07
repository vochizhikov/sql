declare
   numCons integer := 731694975;
   IIN     string(40);
   rnd     string(4);  
   vGender string(2); 
   CheckDigit number:= 0;
begin
  <<M1>>
--1-6 разряд дата рождения ymmdd     
   select yymmdd 
     into iin 
     from (Select to_char(sysdate-30*12*30, 'yymmdd') yymmdd  from dual);
   select sGender 
     into vGender
     from (select 'f' "sGender" from dual);
-- 7 разряд в заваисимости от пола и века, в котором человек родился
   if Gender = 'm' then
      if to_number(substr(iin, 0, 2)) <= 23 then 
         iin:= concat(iin, '5'); 
      else 
         iin:= concat(iin, '3');
      end if;
   else
      if to_number(substr(iin, 0, 2)) <= 23 then  select 
         iin:= concat(iin, '6');
      else 
         iin:= concat(iin, '4');
      end if;
   end if;
-- 8-11 разряды — заполняет орган Юстиции   
   rnd := to_char(round(dbms_random.value(1,9999),0)); 
   rnd := concat(substr('0000', 0, 4-length(rnd)), rnd); --rnd := substr('0000', 0, 4-length(rnd)) || rnd;
   iin := concat(iin,rnd);                               --iin || rnd;
-- 12 разряд контрольная цифра
   for n in 1..11
     loop
      CheckDigit := CheckDigit +(n*to_number(substr(iin,n,1)));
     end loop;    
   if mod(CheckDigit,11) = 10 then
       CheckDigit := 0;
       for n in 1..9
         loop
          CheckDigit := CheckDigit +((n+2)*to_number(substr(iin,n,1)));
         end loop;
         
       for n in 10..11
         loop 
          CheckDigit:= CheckDigit + ((n-9)*to_number(substr(iin,n,1)));
         end loop;
    end if; 
  
    CheckDigit := mod(CheckDigit,11);
    iin := Concat(iin, to_char(CheckDigit)); -- IIN || TO_CHAR(CHECKDIGIT)  
dbms_output.put_line('Консультант ' || numCons);
dbms_output.put_line('ИИН ' || iin);
dbms_output.put_line(' ');
dbms_output.put_line('https://ru.wikipedia.org/wiki/Индивидуальный_идентификационный_номер');

end;
   
