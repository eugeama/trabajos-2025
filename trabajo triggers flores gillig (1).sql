/* ejercicios triggers ClassicModels*/
delimiter ;
create table customers_audit (
idAudit int auto_increment not null primary key,
Operacion char(6), 
User varchar(45), 
Last_date_modified date, 
customerNumber int, 
customerName varchar(45)

);

create table employees_audit (
idEAudit int auto_increment not null primary key,
operacion char(6),
user varchar(45),
Ultima_modificacion date,  
employeeNumber int,
firstName varchar(45)
);

delimiter //
create trigger after_insert_info after insert on customers for each row
begin
	insert into customers_audit values (null, "insert", current_user(), 
    current_date(), new.customerNumber, new.customerName);
end // #1 a
delimiter ;
insert into customers values ('232', 'Alpha Cognac', 'Roulet', 'Annette ', '61.77.6555', '1 rue Alsace-Lorraine', NULL, 'Toulouse', NULL, '31000', 'France', '1370', '61100.00');


delimiter ;
insert into customers values(

delimiter //
create trigger before_update_data before update on customers for each row
begin
	insert into customers_audit values (null, "update", current_user(),
    current_date(), new.customerNumber, new.customerName);
end // #1 b
delimiter ;
update customers set contactLastName= "silly" where customerName= "Royal Canadian Collectables, Ltd.";

delimiter //
create trigger before_delete_data before delete on customers for each row
begin
	insert into customers_audit values (null, "delete", current_user(),
    current_date(), old.customerNumber, old.customerName);
end // #1 c

delimiter //
create trigger afIn_employee after insert on employees for each row
begin
	insert into employees_audit values(null, "insert", current_user(), current_date(), 
    new.employeeNumber, new.firstName);
end // #2 a

delimiter //
create trigger beDel_employee before delete on employees for each row 
begin
	insert into employees_audit values(null, "delete", 
	current_user(),current_date(),old.employeeNumber, old.firstName);
end // #2 b

delimiter //
create trigger befUp_employee before update on employees for each row
begin
	insert into employees_audit values (null, "update", 
	current_user(),current_date(),old.employeeNumber, old.firstName);
end // #2 c

delimiter //
create trigger befDel_producto before delete on products for each row
begin
	declare ProdOrd int default 0;
	if exists (select * from orders join orderdetails on  
		orders.orderNumber = orderdetails.orderNumber where orderDate < current_date()-interval 2 month) then
       signal sqlstate '45000' set message_text="Error, tiene órdenes asociadas.";
	end if;
end // #3
delimiter ;
/* ejercicios triggers Stock*/

delimiter //
create trigger before_insert_productos before insert on pedido_producto for each row
    begin
        update ingresostock_producto set cantidad = cantidad - new.cantidad;
    end // #1
delimiter ;
insert into pedido_producto values ('9', '12', '20.00', '1', '2');

delimiter //
create trigger AnBo_ingresoStock before delete on ingresostock for each row
	begin
		delete from ingresostock_producto;
end // #2
delimiter ;

create table categoria_cliente (
categ_id int primary key, categ_nom VARCHAR(45), categ_precio int); 
delimiter ;
#Creo una nueva tabla "categoría" para el ejercicio 3

alter table cliente add column categoriaCl int references categoria_cliente(categ_id);

delimiter //
create trigger after_insert_plata after insert on pedidos for each row
begin
	declare gastado int default 0;
	select SUM(precioUnitario*cantidad) into gastado FROM pedidos where cliente_id = new.cliente_id and
	fecha >=current_date() - interval 2 year;
    if gastado > 50000 then
		update cliente set categoriaCl = "bronce";
	else if gastado > 50000 and gastado < 100000 then
		update cliente set categoriaCl= "Plata";
	else if gastado > 100000 then
		update cliente set categoriaCl= "Oro";
	end if;
    end if;
    end if;
end // #3

delimiter //
create trigger after_insertar_ingStockProd after insert on ingresostock_producto for each row
begin
	update producto set stock= stock + new.cantidad;
end //

delimiter //
create trigger after_update_pedidos after insert on pedido for each row 
begin
	update pedido set idPedido= null, fecha= null, Estado_idEstado= null, Cliente_codCliente= null;
end // #5
delimiter ;
drop trigger after_update_pedidos;