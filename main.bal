import ballerina/io;
import ballerinax/mysql;
import ballerina/sql;

// Defines a record to load the query result schema as shown below in the
// 'getDataWithTypedQuery' function. In this example, all columns of the 
// customer table will be loaded. Therefore, the `Customer` record will be 
// created with all the columns. The column name of the result and the 
// defined field name of the record will be matched regardless of the letters' case.
type Customer record {|
    int PersonID;
    string LastName;
    string FirstName;
    string Address;
    string City;
|};

public function main() returns error? {
    // Runs the prerequisite setup for the example.
    // check beforeExample();

    


    // Initializes the MySQL client.
   mysql:Client mysqlClient = check new  (host = "obs-pixie-mysql.mysql.database.azure.com", user = "obspixieuser", password = "Test@1995",
                               database = "pixie");

    // Select the rows in the database table via the query remote operation.
    // The result is returned as a stream and the elements of the stream can
    // be either a record or an error. The name and type of the attributes 
    // within the record from the `resultStream` will be automatically 
    // identified based on the column name and type of the query result.
    stream<Customer, error?> resultStream = mysqlClient->query(`SELECT * FROM Persons`);

    // If there is any error during the execution of the SQL query or
    // iteration of the result stream, the result stream will terminate and
    // return the error.
    check from Customer customer in resultStream
        do {
            io:println("Full Customer details: ", customer);
        };

    int customerId = 1;
    // Select a row in the database table via the query row operation.
    // This will return utmost one record. If no record is found, it will
    // throw an `sql:NoRowsError`.
    Customer customer = check mysqlClient->queryRow(
        `SELECT * FROM Persons where PersonId = ${customerId}`);
    io:println("\nCustomer (customerId = 1) : ", customer);


    _ = check mysqlClient->execute(`INSERT INTO pixie.Persons
            (PersonID, LastName, FirstName, Address, City) VALUES
            (2, 'Lakshan Karunathilake', 'sdasdsad 21', '14212312', '4006')`);

    // The result of the count operation is provided as an int variable.
    // As this query returns only a single column on top of a single row,
    // this can be provided as an int variable.
    int totalCustomers = check mysqlClient->queryRow(
                    `SELECT COUNT(*) AS total FROM Persons`);
    io:println("\nTotal customers in the table : ", totalCustomers);

}