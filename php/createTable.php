<!doctype html>

<html>
<head>
	<title>Create an Instructor Table</title>
	<link rel="stylesheet" href="../css/style.css" />
</head>

<body>

	<?php

	$servername = "localhost";
	$dbname = "Instructor_Schedule_Management";
	$username = "root";
	$password = "";

	/* Try MySQL server connection. Assuming you are running MySQL
server with default setting (user 'root' with no password).
If the connection was tried and it was successful the code between braces after try is executed, if any error happened while running the code in try-block, 
the code in catch-block is executed. */
	try {
        $conn = new PDO("mysql:host=$GLOBALS[servername];dbname=$GLOBALS[dbname]", $GLOBALS['username'], $GLOBALS['password']);
		$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION); // Sets the error mode of PHP engine to Exception to display all the errors
		echo "<p style='color:green'>Connection Was Successful</p>";
	} catch (PDOException $err) {
		echo "<p style='color:red'>Connection Failed: " . $err->getMessage() . "</p>\r\n";
	}

	$sql = "CREATE TABLE Instructor (
		
		Instructor_id NUMERIC(9,0) PRIMARY KEY ,
		Instructor_name VARCHAR(35) NOT NULL ,
    	Title CHAR(20),
    	email_address VARCHAR(35) UNIQUE NOT NULL ,
    	office_phone NUMERIC(10) UNIQUE NOT NULL ,
    
    	CONSTRAINT Instructor_id_constraint CHECK(Instructor_id BETWEEN 0 AND 1000000000),
    	CONSTRAINT Instructor_em_constraint CHECK(email_address LIKE '%@douglascollege.ca'),
    	CONSTRAINT Instructor_ph_constraint CHECK(999999999 < office_phone < 10000000000)
	);";

	try {
		$conn->exec($sql);
		echo "<p style='color:green'>Instructor Table Created Successfully</p>";
	} catch (PDOException $err) {
		echo "<p style='color:red'>Table Creation Failed: " . $err->getMessage() . "</p>\r\n";
	}

	// Close the connection
	unset($conn);

	echo "<a href='../index.html'>Back to the Homepage</a>";

	?>

</body>

</html>