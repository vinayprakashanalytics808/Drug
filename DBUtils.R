library(RODBC)
myconn <- odbcDriverConnect(connection = "Driver={SQL Server Native client 11.0};
                            server=localhost;database=NewDatabase;trusted_connection=yes;")

##172.17.34.17
