CREATE DATABASE bank_ops;
USE bank_ops;
CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    AccountType VARCHAR(20), -- e.g., 'savings', 'checking'
    Balance DECIMAL(10, 2)
);
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100),
    Department VARCHAR(50),
    Salary DECIMAL(10, 2)
);
INSERT INTO Accounts VALUES
(1, 'Alice', 'savings', 10000.00),
(2, 'Bob', 'savings', 15000.00),
(3, 'Charlie', 'checking', 8000.00),
(4, 'Diana', 'savings', 20000.00);
INSERT INTO Employees VALUES
(101, 'John', 'Finance', 50000.00),
(102, 'Jane', 'IT', 60000.00),
(103, 'Mark', 'Finance', 55000.00),
(104, 'Sara', 'HR', 48000.00);
SET SQL_SAFE_UPDATES = 0;
DELIMITER //

CREATE PROCEDURE ProcessMonthlyInterest()
BEGIN
    UPDATE Accounts
    SET Balance = Balance + (Balance * 0.01)
    WHERE AccountType = 'savings';
END;
//

DELIMITER ;

-- ✅ Call it
CALL ProcessMonthlyInterest();
DELIMITER //

CREATE PROCEDURE UpdateEmployeeBonus(
    IN dept_name VARCHAR(50),
    IN bonus_percent DECIMAL(5,2)
)
BEGIN
    UPDATE Employees
    SET Salary = Salary + (Salary * bonus_percent / 100)
    WHERE Department = dept_name;
END;
//

DELIMITER ;

-- ✅ Call it: e.g., give 10% bonus to Finance
CALL UpdateEmployeeBonus('Finance', 10);
DELIMITER //

CREATE PROCEDURE TransferFunds(
    IN source_id INT,
    IN destination_id INT,
    IN amount DECIMAL(10,2)
)
BEGIN
    DECLARE src_balance DECIMAL(10,2);

    -- Get current balance of source account
    SELECT Balance INTO src_balance FROM Accounts WHERE AccountID = source_id;

    -- Check if sufficient balance
    IF src_balance >= amount THEN
        -- Deduct from source
        UPDATE Accounts
        SET Balance = Balance - amount
        WHERE AccountID = source_id;

        -- Add to destination
        UPDATE Accounts
        SET Balance = Balance + amount
        WHERE AccountID = destination_id;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient funds in source account';
    END IF;
END;
//

DELIMITER ;

-- ✅ Call it: Transfer 2000 from Alice (1) to Bob (2)
CALL TransferFunds(1, 2, 2000);
SELECT * FROM Accounts;
SELECT * FROM Employees;








