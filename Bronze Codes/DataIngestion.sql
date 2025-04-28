Create or alter procedure bronze.load_bronze As
Begin
      DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '================================================';

		PRINT '------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '------------------------------------------------';

		SET @start_time = GETDATE();
			
		PRINT '>> Truncating Table: bronze.crm_cust_info';
		
		Truncate Table bronze.crm_cust_info;

		PRINT '>> Inserting Data Into: bronze.crm_cust_info';
		--Data Ingestion
		Bulk insert bronze.crm_cust_info
		from 'E:\Projects\Datawarehouse with ETLs project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
			With
				( 
				firstrow = 2,
				FieldTerminator = ',',
				Tablock )
				SET @end_time = GETDATE();
		
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_prd_info';
		--Prd_Info
		Truncate table bronze.crm_prd_info;

		PRINT '>> Inserting Data Into: bronze.crm_prd_info';

		bulk insert bronze.crm_prd_info
		from 'E:\Projects\Datawarehouse with ETLs project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		With (
				FirstRow = 2,
				FieldTerminator = ',',
				Tablock )

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_sales_details';
		
		--Sales Details
		Truncate table bronze.crm_sales_details;
		
		PRINT '>> Inserting Data Into: bronze.crm_sales_details';

		bulk insert bronze.crm_sales_details
		from 'E:\Projects\Datawarehouse with ETLs project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		With (
				FirstRow = 2,
				FieldTerminator = ',',
				Tablock )
		
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		PRINT '------------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '------------------------------------------------';
		
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_cust_az12';

		--ERP Cust
		Truncate Table bronze.erp_cust_az12;
		
		PRINT '>> Inserting Data Into: bronze.erp_cust_az12';
		
		bulk insert bronze.erp_cust_az12
		from 'E:\Projects\Datawarehouse with ETLs project\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
		With (
				FirstRow = 2,
				FieldTerminator = ',',
				Tablock )
		
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';


		--Erp_Loc

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_loc_a101';
		
		Truncate Table bronze.erp_loc_a101

		PRINT '>> Inserting Data Into: bronze.erp_loc_a101';

		bulk insert bronze.erp_loc_a101
		from 'E:\Projects\Datawarehouse with ETLs project\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
		With (
				FirstRow = 2,
				FieldTerminator = ',',
				Tablock )

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
		--Erp Px Cat
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
		
		Truncate Table bronze.erp_px_cat_g1v2;
		
		PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
		
		bulk insert bronze.erp_px_cat_g1v2
		from 'E:\Projects\Datawarehouse with ETLs project\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
		With (
				FirstRow = 2,
				FieldTerminator = ',',
				Tablock )
				SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Bronze Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END			