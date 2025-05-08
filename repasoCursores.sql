delimiter //
create procedure ActualizaProds ()
begin
	declare hayFilas boolean default 1;
    declare variable1 int default 0;
    declare variable2 int default 0;
    declare recorreProd cursor for select Producto_codProducto, cantidad from ingresostock_producto
    join ingresostock on IngresoStock_idIngreso=idIngreso where fecha>(current_date() - INTERVAL 7 DAY);
    declare continue handler for not found set hayFilas=0;
    open recorreProd;
    bucle:loop
		fetch recorreProd into variable1, variable2;
        if hayFilas = 0 then 
			leave bucle;
        end if;
        update producto set stock=stock+variable2 where Producto_codProducto=codProducto;
        end loop bucle;
        close recorreProd;
end //
delimiter ; #1

delimiter //
create procedure procediPrecio ()
begin
	declare hayFilas boolean default 1;
    declare variable1 int default 0;
    declare reducePrecio cursor for select codProducto from producto;
    declare continue handler for not found set hayFilas=0;
    open reducePrecio;
    bucle:loop
		fetch reducePrecio into variable1;
        if hayFilas = 0 then 
			leave bucle;
        end if;
	update producto join pedido_producto on producto_codProducto = codProducto join pedido on Pedido_idPedido=idPedido 
	set precio = precio - (precio * 0.10) where (select sum(cantidad) from pedido_producto where 
    Producto_codProducto=codProducto)<100 and pedido.fecha>(current_date() - INTERVAL 7 DAY);
	end loop bucle;
	close reducePrecio;
end //
delimiter ; #2

delimiter //
create procedure cambiaProd ()
begin
	declare hayFilas boolean default 1;
    declare variable1 int default 0;
    declare cambiaPrecio cursor for select codProducto from producto;
    declare continue handler for not found set hayFilas=0;
    open cambiaPrecio;
    bucle:loop
		fetch cambiaPrecio into variable1;
        if hayFilas = 0 then 
			leave bucle;
        end if;
	update producto set precio = (select max(producto_proveedor.precio) from producto_proveedor where codProducto=producto.codProducto) * 1.1
	where codProducto=producto.codProducto;
	end loop bucle;
	close cambiaPrecio;
end //
delimiter ;
drop procedure cambiaProd;
call cambiaProd();

delimiter //
create procedure actualiza ()
begin
	declare hayFilas boolean default 1;
    declare variable1 int default 0;
	declare variable2 int default 0;
	declare variable3 int default 0;
    declare actualiprecio cursor for select codProducto, precio, Pedido_idPedido from producto join pedido_producto on Producto_codProducto= codProducto 
    join pedido on Pedido_idPedido=idPedido join estado on Estado_idEstado=idEstado where estado.nombre="pendiente";
    declare continue handler for not found set hayFilas=0;
    open actualiprecio;
    bucle:loop
		fetch actualiprecio into variable1, variable2, variable3;
        if hayFilas = 0 then 
			leave bucle;
        end if;
        update pedido_producto set precioUnitario=variable2
        where Producto_codProducto = variable1 and Pedido_idPedido= variable3;
	end loop bucle;
	close actualiprecio;
end //
delimiter ; #5



      