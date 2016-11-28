connStrSql <- "Driver=SQL Server;Server=MIPRASAD-X1;Database=IRISDB;Trusted_Connection=Yes"
sqlShareDir <- paste("C:\\All\\", Sys.getenv("USERNAME"), sep = "") # shared use by the local R session and by the remote SQL Server computer
sqlWait <- TRUE # R session on the workstation should always wait for R job results
sqlConsoleOutput <- FALSE # No return of console output from remote computations

sqlcc <- RxInSqlServer(connectionString = connStrSql, shareDir = sqlShareDir,
                    wait = sqlWait, consoleOutput = sqlConsoleOutput)

rxSetComputeContext(sqlcc)

sampleDataQuery <- "SELECT * from [dbo].[iris]"
inDataSource <- RxSqlServerData(sqlQuery = sampleDataQuery,
     connectionString = connStrSql,
     rowsPerRead = 500)


head(inDataSource)

sumOut <- rxSummary(formula = ~sepalwidth, data = inDataSource)
