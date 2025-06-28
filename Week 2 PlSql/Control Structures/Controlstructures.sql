CREATE DATABASE bank_db;
USE bank_db;
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Age INT,
    Balance DECIMAL(10,2),
    IsVIP BOOLEAN DEFAULT FALSE,
    LoanInterestRate DECIMAL(5,2)
);

CREATE TABLE Loans (
    LoanID INT PRIMARY KEY,
    CustomerID INT,
    DueDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
SET SQL_SAFE_UPDATES = 0;
INSERT INTO Customers VALUES
(1, 'Alice', 65, 12000.00, FALSE, 8.5),
(2, 'Bob', 45, 8000.00, FALSE, 9.0),
(3, 'Charlie', 70, 15000.00, FALSE, 7.5),
(4, 'Diana', 30, 11000.00, FALSE, 10.0);

INSERT INTO Loans VALUES
(101, 1, CURDATE() + INTERVAL 15 DAY),
(102, 2, CURDATE() + INTERVAL 40 DAY),
(103, 3, CURDATE() + INTERVAL 5 DAY),
(104, 4, CURDATE() - INTERVAL 2 DAY);  -- Already due
DELIMITER //

CREATE PROCEDURE ApplySeniorDiscount()
BEGIN
    UPDATE Customers
    SET LoanInterestRate = LoanInterestRate - 1
    WHERE Age > 60;
END;
//

DELIMITER ;

-- Run it:
CALL ApplySeniorDiscount();
DELIMITER //

CREATE PROCEDURE PromoteToVIP()
BEGIN
    UPDATE Customers
    SET IsVIP = TRUE
    WHERE Balance > 10000;
END;
//

DELIMITER ;

-- Run it:
CALL PromoteToVIP();

DELIMITER //

CREATE PROCEDURE SendLoanReminders()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE cust_name VARCHAR(100);
    DECLARE loan_id INT;
    DECLARE due_date DATE;

    DECLARE cur CURSOR FOR
        SELECT l.LoanID, c.CustomerName, l.DueDate
        FROM Loans l
        JOIN Customers c ON l.CustomerID = c.CustomerID
        WHERE l.DueDate BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY);

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO loan_id, cust_name, due_date;
        IF done THEN
            LEAVE read_loop;
        END IF;

        SELECT CONCAT('Reminder: Loan ', loan_id, ' for ', cust_name,
                      ' is due on ', DATE_FORMAT(due_date, '%d-%b-%Y')) AS Reminder;
    END LOOP;

    CLOSE cur;
END;
//

DELIMITER ;

-- Run it:
CALL SendLoanReminders();










