CREATE DATABASE DBEmpresa;
	USE DbEmpresa;
	CREATE TABLE Trabajadores (
		ID INT PRIMARY KEY IDENTITY(1,1),
		Nombre NVARCHAR(100),
		Apellidos NVARCHAR(100),
		SueldoBruto DECIMAL(10, 2),
		Categoria CHAR(1)
	);

	CREATE PROCEDURE CalcularSueldoNeto
	AS
	BEGIN
		DECLARE PorcentajeAumento DECIMAL(5, 2);
		DECLARE MontoAumento DECIMAL(10, 2);
		DECLARE SueldoNeto DECIMAL(10, 2);
		DECLARE TotalSueldosNetos DECIMAL(10, 2);
		SET TotalSueldosNetos = 0;

		DECLARE cursorTrabajadores CURSOR FOR
		SELECT Nombre, Apellidos, SueldoBruto, Categoria
		FROM Trabajadores;
		OPEN cursorTrabajadores;

		DECLARE Nombre NVARCHAR(100);
		DECLARE Apellidos NVARCHAR(100);
		DECLARE SueldoBruto DECIMAL(10, 2);
		DECLARE Categoria CHAR(1);

		FETCH NEXT FROM cursorTrabajadores INTO Nombre, Apellidos, SueldoBruto, Categoria;
		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF SueldoBruto <= 1000
				SET PorcentajeAumento = 0.1;
			ELSE IF SueldoBruto <= 2000
				SET PorcentajeAumento = 0.2;
			ELSE IF SueldoBruto <= 4000
				SET PorcentajeAumento = 0.3;
			ELSE
				SET PorcentajeAumento = 0.4;

			SET MontoAumento = PorcentajeAumento * SueldoBruto;

			SET SueldoNeto = SueldoBruto + MontoAumento;

			SET TotalSueldosNetos = TotalSueldosNetos + SueldoNeto;

			PRINT Nombre + ' ' + Apellidos + ' - ' + CAST(SueldoBruto AS NVARCHAR(20)) + ' - ' + CAST(MontoAumento AS NVARCHAR(20)) + ' - ' + CAST(SueldoNeto AS NVARCHAR(20));

			FETCH NEXT FROM cursorTrabajadores INTO Nombre, Apellidos, SueldoBruto, Categoria;
		END

		CLOSE cursorTrabajadores;
		DEALLOCATE cursorTrabajadores;

		PRINT 'Total de Sueldos Netos: ' + CAST(TotalSueldosNetos AS NVARCHAR(20));
	END;

	--- datos de trabajadores
	INSERT INTO Trabajadores (Nombre, Apellidos, SueldoBruto, Categoria) VALUES ('Antony', 'Torres Mendoza',3500, 'A');
	INSERT INTO Trabajadores (Nombre, Apellidos, SueldoBruto, Categoria) VALUES ('Maario', 'Vargas Llosa', 6200, 'B');
	INSERT INTO Trabajadores (Nombre, Apellidos, SueldoBruto, Categoria) VALUES ('Miguel', 'Araujo Quino', 2500, 'C');
	INSERT INTO Trabajadores (Nombre, Apellidos, SueldoBruto, Categoria) VALUES ('Juan', 'Mendoza Tello', 2500, 'A');
	INSERT INTO Trabajadores (Nombre, Apellidos, SueldoBruto, Categoria) VALUES ('Mariana', 'Olivera Flores', 2500, 'B');
	select * from Trabajadores

	EXEC CalcularSueldoNeto;
