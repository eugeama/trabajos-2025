delimiter //
create event actualizarPedidos on schedule every 1 day starts now() do
begin
	update orders set status = "Delayed" where shippedDate<current_date() and status="In Process";
end; #1

delimiter //
create event eliminaPagos on schedule every 1 month starts now() do
begin
	delete from payments where paymentDate<(DATE_SUB(now(),INTERVAL 5 YEAR));
end; #2

create event identificarCliente on schedule every 1 month starts now() ends now()+INTERVAL 1 YEAR do
begin
declare contador int default 0;
declare persona Varchar(45);
select count(*) into contador, customerNumber into persona from orders 
where orderDate=DATE_SUB(now(),INTERVAL 1 YEAR) group by persona;
if contador > 10 then
	update customers set creditLimit= creditLimit*1.10;
end if;
end; #3
/* timestamp */
create event pagoPendientes on schedule every 1 week starts now()+INTERVAL 1 day do
begin
end;
