delimiter //
create procedure ListarProds (out Cant_Prods int)
begin
	select productCode from orderdetails 
    where priceEach>(select avg(priceEach) from orderdetails);
    select count(*) into Cant_Prods from orderdetails 
    where priceEach>(select avg(priceEach) from orderdetails);
end // #1 

delimiter //
create procedure LineaProduc (inout NroOrden int)
begin
delete from orderdetails where NroOrden= orderNumber;
if (select NroOrden = orderNumber)=NULL then
	set orderNumber = 0;
else if exists (select NroOrden = orderNumber) then
	delete from orders where NroOrden = orderNumber;
end if;
end if;
end //#2

delimiter //
create procedure Borrarlineas (in nombre varchar(45), out respuesta varchar(45))
begin
if not exists(select * from products where products.productLine=nombre) then
delete from products where products.productLine=nombre;
delete from productlines where productLine=nombre;
 set respuesta ="La línea de productos fue borrada";
else
set respuesta ="La línea de productos no pudo borrarse porque contiene productos asociados";
end if;
end//#3

delimiter //
create procedure CantidadOrdenes (in NumOrden int, out CantOrdenes int)
begin
select count(orderNumber), orders.status into CantOrdenes from orders group by orders.status; 
end // #4

delimiter //
create procedure Listarempleados ()
begin
select count(reportsTo), reportsTo from employees group by reportsTo;
end // #5 

delimiter //
create procedure Listaremplea2 ()
begin
select count(*), jefe.lastname from employees as empleado
join employee as jefe on employeeNumber=reportsTo group by empleado.reportsTo;
end // #otra alternativa del 5 (con un join a la misma tabla)
delimiter ;

delimiter //
create procedure Productos ()
begin
select orderNumber, (priceEach*quantityOrdered) from orderdetails group by orderNumber;
end // #6

delimiter //
create procedure Listarclientes()
begin
select customerNumber, customerName from customers 
join orders on customers.customerNumber=orders.customerNumber
join orderdetails on orders.orderNumber=orderdetails.orderNumber
where orderdetails.orderNumber=(priceEach*quantityOrdered) and customers.customerNumber=customerNumber
group by orderNumber;
end // #7
delimiter ;

delimiter //
create procedure CampoOrd (in NumOrden int, in Comentario varchar(45))
begin
declare respuesta int;
if exists(select orderNumber = NumOrden from orders) then
update orders set comments = Comentario;
set respuesta=1;
else
set respuesta = 0;
end if;
end //#8

delimiter //
create procedure getCiudadesOffices(out cities varchar(4000))
begin
	declare Hayoficinas boolean default 1;
    declare ciudadActual varchar(45);
    declare Rec_ciudades cursor for select city from offices;
    declare continue handler for not found set Hayoficinas=0;
    set cities="";
    open Rec_ciudades;
    bucle:loop
		fetch Rec_ciudades into ciudadActual;
        if Hayoficinas=0 then
			leave bucle;
			end if;    
		set cities=concat(ciudadActual,",",cities);
        end loop bucle;
        close Rec_ciudades;
end //
delimiter ; #9

create table CancelledOrders (
orderNumber int,
  orderDate date NOT NULL,
  customerNumber int NOT NULL,
  PRIMARY KEY (orderNumber),
  FOREIGN KEY (customerNumber) REFERENCES customers (customerNumber)
)

delimiter //
create procedure insertCancelledOrders(out orders varchar(4000))
begin
	declare HayOrdenes boolean default 1;
    declare OrdenesCanceladas varchar(45);
    declare Rec_Ordenes cursor for select * from orders where status = "Cancelled";
    declare continue handler for not found set HayOrdenes=0;
    open Rec_Ordenes;
    bucle:loop
		fetch Rec_Ordenes into OrdenesCanceladas;
        insert into CancelledOrders values (OrdenesCanceladas);
        if HayOrdenes=0 then
			leave bucle;
			end if;    
			select count(*) from CancelledOrders;
        end loop bucle;
        close Rec_ciudades;
end //
delimiter; #10

delimiter //
create procedure alterCommentOrder(in clienteNum int)
begin 
	
    declare prod int default 0;
	declare variablee text;
    declare NumOr int default 0;
    declare hayFilas int default 1;
	declare recorreOrdenes cursor for select comments, orderNumber from orders where customerNumber=clienteNum;
	declare continue handler for NOT FOUND set hayFilas=0;
    
    open recorreOrdenes;
    bucle:loop
		fetch recorreOrdenes into variablee, NumOr;
        if hayFilas=0 then
			leave bucle;
        end if;
        
        if variablee is null then
        select sum(quantityOrdered) into prod from orderdetails od
        join orders ord on od.orderNumber = ord.orderNumber where ord.orderNumber = NumOr;
        update orders ord set comments= concat("El total de la orden es: ", prod) where ord.orderNumber = NumOr;
        end if;
        end loop bucle;
        close recorreOrdenes;
 end //
delimiter ;

delimiter //
create procedure cancelOrder(in clienteNum int)
begin 
	
	declare variable2 text;
    declare hayFilas int default 1;
	declare recorrePhones cursor for select columna from tabla;
	declare continue handler for NOT FOUND set hayFilas=0;
    open recorrePhones;
    bucle:loop
		fetch recorreOrdenes into variablee;
        if hayFilas=0 then
			leave bucle;
        end if;
        #CODIGO
	end loop bucle;
	close recorrePhones;
end //
delimiter ;    