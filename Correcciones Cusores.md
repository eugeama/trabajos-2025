### Correcciones Cusores

Cuidado que cuando definimos un cursor que selecciona muchas columnas (como hacen el ejercicio 10) en el fetch vamos a tener que poner tantas variables como columnas hayamos seleccionado. Sería:

fetch Rec_Ordenes into numOrden, fechaOrden, fechaRequerida, fechaEntrega, estado, comentarios, numCliente;

En el ejercicio 11 recuerden multiplicar la cantidad ordenada por el precio del producto, para poder obtener el total gastado.
