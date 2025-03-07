select nombre from proveedor where ciudad="La Plata"; #1
delete from articulo where codigo not in (select articulo_codigo from compuesto_por); #2
select articulo.codigo, descripcion from articulo join compuesto_por on articulo.codigo=articulo_codigo join provisto_por on compuesto_por.material_codigo=provisto_por.material_codigo join proveedor on proveedor_codigo=proveedor.codigo where nombre="Lopez SA"; #3
select proveedor.codigo, nombre from proveedor join provisto_por on proveedor.codigo = proveedor_codigo join material on material.codigo=provisto_por.material_codigo join compuesto_por on material.codigo=compuesto_por.material_codigo join articulo on articulo_codigo=articulo.codigo where precio > 10000; #4
select articulo.codigo from articulo where precio=(select max(precio) from articulo); #5
select descripcion from articulo join tiene on articulo.codigo=articulo_codigo group by codigo order by sum(stock) desc limit 1; #6
select almacen.codigo from almacen join tiene on almacen.codigo=almacen_codigo join articulo on tiene.articulo_codigo=articulo.codigo join compuesto_por on articulo.codigo=compuesto_por.articulo_codigo join material on material_codigo=material.codigo where material.codigo=2; #7
select descripcion from articulo join compuesto_por on articulo.codigo=compuesto_por.articulo_codigo where compuesto_por.material_codigo=(select max(compuesto_por.material_codigo) from compuesto_por); #8 
update tiene set stock=stock+0.2*stock where stock<20; #9
select avg(cant_materiales) from (select count(material.codigo) as cant_materiales from material) as a; #10
select max(precio), min(precio), avg(precio) from articulo join tiene on articulo.codigo=tiene.articulo_codigo group by almacen_codigo; #11
select almacen_codigo, sum(precio*stock) from tiene join articulo on tiene.articulo_codigo = articulo.codigo group by almacen_codigo; #12
select almacen_codigo, sum(precio*stock) from tiene join articulo on tiene.articulo_codigo = articulo.codigo where stock>100 group by almacen_codigo; #13
select distinct(descripcion) from articulo join compuesto_por on articulo.codigo = compuesto_por.articulo_codigo where precio>5000 and (select count(material_codigo) from compuesto_por)>3; 
select material.descripcion, precio, articulo.codigo from material join compuesto_por on 
material.codigo=material_codigo join articulo on articulo_codigo=articulo.codigo 
join tiene on articulo.codigo=tiene.articulo_codigo join almacen 
on tiene.almacen_codigo=almacen.codigo where precio>
(select avg(precio) from articulo where almacen.codigo=2); #15

