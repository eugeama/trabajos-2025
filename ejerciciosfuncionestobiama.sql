delimiter //
create function orden_estado (fechainicio date, fechaentrega date, estado varchar(45)) returns int deterministic
begin
declare Cant_ordenes int default 0;
select count(*) into Cant_ordenes from orders where status=estado and orderDate between 
fechainicio and fechaentrega;
return Cant_ordenes;
end //  #1

delimiter //
create function Fecha_envío (fechaenvio1 date, fechaenvio2 date) returns int deterministic
begin
declare CantOrdenes int default 0;
select count(status) into CantOrdenes from orders where shippedDate between fechaenvio1 and fechaenvio2;
return CantOrdenes;
end// #2

delimiter //
create function devolver_ciudad (Numcliente int) returns int deterministic
begin 
declare Ciudad varchar(45);
select offices.city into Ciudad from offices join employees on offices.officeCode=employees.officeCode join customers on
employeeNumber=salesRepEmployeeNumber where customerNumber=Numcliente;
return Ciudad;
end// #3

delimiter //
create function Productline(LineaProducto varchar(45)) returns int deterministic
begin
declare CantidadP int default 0;
select count(*) into CantidadP from products where productLine=LineaProducto;
return CantidadP;
end// #4

delimiter //
create function CodigoOfi (officeCode int) returns int deterministic
begin
declare Cant_clientes int default 0;
select count(*) into Cant_clientes from customers join employees
on salesRepEmployeeNumber=employeeNumber where employees.officeCode=CodigoOfi;
return Cant_clientes; 
end// #5

delimiter //
create function CodigoOfi(officeCode int)returns int deterministic
begin
declare CantOrdenes int default 0;
select count(*) into CantOrdenes from orders join customers on customers.customerNumber=orders.customerNumber join employees
on salesRepEmployeeNumber=employeeNumber where employees.officeCode=CodigoOfi;
return CantOrdenes;
end// #6

delimiter //
create function CodiOrden (NroOrden int, NroProducto int) returns int deterministic
begin
declare Beneficio DECIMAL default 0;
select (priceEach-buyPrice) into Beneficio from orderdetails join products on orderdetails.productCode=
products.productCode where orderdetails.orderNumber=NroOrden and orderdetails.productCode=NroProducto;
return Beneficio;
end// #7

delimiter //
create function Cancelado(NroOrden int)returns int deterministic
begin
if (select status from orders where orderNumber = NroOrden) = "cancelado" then
	return -1;
else
	return 0;
end if;
end// #8

delimiter //
create function DevuelveFecha(NroCliente int) returns date deterministic
begin
declare DevFecha DATE;
select min(orderDate) into DevFecha from orders join customers on
orders.customerNumber=customers.customerNumber where
customers.customerNumber=NroCliente limit 1;

return DevFecha;
end//#9

delimiter //
create function PorcentajePrecio(CodProducto int) returns date deterministic
begin
declare VPorDebajo int default 0;
declare Total int default 0;
declare Porcentaje int default 0;

select buyPrice into VPorDebaje from products where buyPrice<MSRP;
select sum(buyPrice) into Total from products;
select (VPorDebajo/Total)*100 into Porcentaje from products where productCode=CodProducto;

return Porcentaje;
end//#10

delimiter //
create function UltimaFecha(CodProducto int) returns int deterministic
begin
declare UltimaFecha date;

select max(orderDate) into UltimaFecha from orders join orderdetails on orders.orderNumber=orderdetails.orderNumber 
join products on orderDetails.productCode=products.productCode where products.productCode= CodProducto;

return UltimaFecha;
end//#11

delimiter //
create function Ordenado(FechaDesde date, FechaHasta date, CodProducto int) returns date deterministic
begin
declare MayorPrecio int default 0;
if (select orderDate from orders join orderdetails on orders.orderNumber=orderdetails.orderNumber) between FechaDesde and FechaHasta
and productCode = CodProducto then
select max(priceEach) into MayorPrecio from orderdetails;
return MayorPrecio;
else
return 0;
end if;
end//#12

delimiter //
create function CantidadClientes(NumeroEmp int) returns date deterministic
begin
declare CantClient int default 0;
select count(customerNumber) into CantClient from customers where salesRepEmployeeNumber = NumeroEmp;
return CantClient;
end//#13

delimiter //
create function ApellidoEmpleado(NumEmpleado int) returns date deterministic
begin
declare ApEmpleado varchar(45);
select lastName into ApEmpleado from employees where employeeNumber = NumEmpleado;
return ApEmpleado;
end//#14