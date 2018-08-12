
DROP FUNCTION TEST_2;
GO
CREATE FUNCTION TEST_2()
RETURNS @reporte TABLE
(
	id uniqueidentifier NOT NULL,
	poa1 nvarchar(500) not null,
	poa2 nvarchar(500) not null
)
AS
BEGIN
   DECLARE @mi_id uniqueidentifier, @mi_hacienda nvarchar(500), @POA1 nvarchar(500),@POA2 nvarchar(500)  ; 

   --PRINT '-------- Vendor Products Report --------';  

	DECLARE mi_cursor CURSOR FOR  SELECT id, hacienda  FROM Hacienda
	OPEN mi_cursor  
	FETCH NEXT FROM mi_cursor INTO @mi_id, @mi_hacienda  
	WHILE @@FETCH_STATUS = 0  
	BEGIN  
         (select @POA1 =CAMPO_VALUE from TablaABC T2 inner join Historial H2 on T2.ID_HACIENDA = (cast(LTRIM((SUBSTRING(H2.SERIAL_HACIENDA,6,36))) as uniqueidentifier)) 
				    WHERE H2.CAMPO_DETALLE = 'POA1' AND  T2.ID_HACIENDA = @mi_id )
		(select  @POA2 = CAMPO_VALUE from TablaABC T2 inner join Historial H2 on T2.ID_HACIENDA = (cast(LTRIM((SUBSTRING(H2.SERIAL_HACIENDA,6,36))) as uniqueidentifier)) 
				    WHERE H2.CAMPO_DETALLE = 'POA2' AND  T2.ID_HACIENDA = @mi_id )

        INSERT @reporte SELECT id_hacienda, @POA1, @POA2 FROM TablaABC where id_hacienda=@mi_id
		
		FETCH NEXT FROM mi_cursor INTO @mi_id, @mi_hacienda  
	END
    CLOSE mi_cursor;  
	DEALLOCATE mi_cursor;    
	
	RETURN
END;
GO
 select * from TEST_2();