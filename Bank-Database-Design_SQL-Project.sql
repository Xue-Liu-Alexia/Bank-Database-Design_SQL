/*Create a database for a banking application called “Bank”.
Create all the tables mentioned in the database diagram.
Create all the constraints based on the database diagram.
Insert at least 3 rows in each table*/

CREATE DATABASE Bank
ON
  (Name = 'Bank',
   FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\BankData.mdf',
   SIZE = 10,
   MAXSIZE = 50,
   FILEGROWTH = 5)
 LOG ON
  (Name = 'AccountingLog',
   FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\BankLog.ldf',
   SIZE = 5MB,
   MAXSIZE = 50MB,
   FILEGROWTH = 5MB)
Go;

CREATE TABLE Account
(
AccountID				int			NOT NULL PRIMARY KEY, 
CurrentBalance			int			NOT NULL, 
AccountTypeID			tinyint		NOT NULL 
	foreign key references AccountType(AccountTypeID), 
AccountStatusTypeID		tinyint		NOT NULL 
	foreign key references AccountStatusType(AccountStatusTypeID), 
InterestSavingsRateID	tinyint		NOT NULL 
	foreign key references SavingsInterestRates(InterestSavingsRateID));

--Different accounts may have different account types and account status
INSERT INTO Account
(AccountID, CurrentBalance, AccountTypeID, AccountStatusTypeID, InterestSavingsRateID)
VALUES
	(100001, 8996, 1, 1, 1),
	(100002, 0, 1, 3, 2),
	(100003, 112565, 2, 1, 3),
	(100004, 584, 1, 5, 4),
	(100005, 7894, 2, 1, 5);

SELECT *
FROM Account;


/*There are only two types of accounts at this time: 
Checking and Savings accounts. */
CREATE TABLE AccountType
(
AccountTypeID			tinyint		NOT NULL PRIMARY KEY, 
AccountTypeDescription	varchar(30)	NOT NULL);

INSERT INTO AccountType 
(AccountTypeID, AccountTypeDescription)
VALUES 
	(1, 'Checking Account'), 
	(2, 'Savings Account');

SELECT *
FROM AccountType;


--There are various account statuses, I give this table 5 account types
CREATE TABLE AccountStatusType
(
AccountStatusTypeID			tinyint		NOT NULL PRIMARY KEY, 
AccountStatusDescription	varchar(30)	NOT NULL);

INSERT INTO AccountStatusType 
(AccountStatusTypeID, AccountStatusDescription)
VALUES 
	(1, 'Active'), 
	(2, 'Inactive'), 
	(3, 'Closed'), 
	(4, 'Pending'), 
	(5, 'Suspended');

SELECT *
FROM AccountStatusType;


CREATE TABLE SavingsInterestRates
(
InterestSavingsRateID	tinyint		NOT NULL PRIMARY KEY, 
InterestRateValue		numeric(9,9)NOT NULL, 
InterestRateDescription	varchar(20)	NOT NULL);

--Every person who opens a savings account does not get the same rate.
--I give each account a different interest rate
INSERT INTO SavingsInterestRates 
(InterestSavingsRateID, InterestRateValue, InterestRateDescription)
VALUES 
	(1, ROUND(RAND()*(0.1-0.01)+0.01, 9), 'Customized Rates'), 
	(2, ROUND(RAND()*(0.1-0.01)+0.01, 9), 'Customized Rates'), 
	(3, ROUND(RAND()*(0.1-0.01)+0.01, 9), 'Customized Rates'), 
	(4, ROUND(RAND()*(0.1-0.01)+0.01, 9), 'Customized Rates'), 
	(5, ROUND(RAND()*(0.1-0.01)+0.01, 9), 'Customized Rates');

SELECT *
FROM SavingsInterestRates;


CREATE TABLE OverDraftLog
(
OverDraftAccountID			int			NOT NULL PRIMARY KEY, 
OverDraftDate				datetime	NOT NULL, 
OverdraftAmount				money		NOT NULL, 
OverdraftTransactionXML		xml			NOT NULL);

Alter Table OverDraftLog
Add Foreign Key (OverDraftAccountID) references Account(AccountID);

--The last OverDraftAccountID, I give it the time at this moment
INSERT INTO OverDraftLog 
(OverDraftAccountID, OverDraftDate, OverdraftAmount, OverdraftTransactionXML)
VALUES 
	(100001, '2022-05-24', 556, 'D:\Alexia\SQL_XML\20220524.xml'), 
	(100002, '2022-06-08', 15, 'D:\Alexia\SQL_XML\20220608.xml'), 
	(100003, '2022-10-15', 99, 'D:\Alexia\SQL_XML\20221015.xml'), 
	(100004, '2023-04-21', 1456, 'D:\Alexia\SQL_XML\20230421.xml'), 
	(100005, GETDATE(), 1598, 'D:\Alexia\SQL_XML\Today.xml');

SELECT *
FROM OverDraftLog;


CREATE TABLE UserLogins
(
UserLoginID				smallint	NOT NULL PRIMARY KEY, 
UserName				char(15)	NOT NULL, 
UserPassword			varchar(20)	NOT NULL);

INSERT INTO UserLogins 
(UserLoginID, UserName, UserPassword)
VALUES
	(1, 'Join', 'joinpswd2023'), 
	(2, 'Carry', 'carrypswd2023'), 
	(3, 'Nick', 'nickpswd2023'), 
	(4, 'Kyle', 'kylepswd2023'), 
	(5, 'Anna', 'annapswd2023');

SELECT *
FROM UserLogins;


--Correspond the data of UserLogins and Account
CREATE TABLE Login_Account
(
UserLoginID			smallint	NOT NULL 
	foreign key references UserLogins(UserLoginID), 
AccountID			int			NOT NULL 
	foreign key references Account(AccountID));

INSERT INTO Login_Account 
(UserLoginID, AccountID)
VALUES 
	(1, 100001), 
	(2, 100002), 
	(3, 100003), 
	(4, 100004), 
	(5, 100005);

SELECT *
FROM Login_Account;


--Name the .xml file with the ErrorTime
CREATE TABLE LoginErrorLog
(
ErrorLogID				int			NOT NULL PRIMARY KEY, 
ErrorTime				datetime	NOT NULL, 
FailedTransactionXML	xml			NOT NULL);

INSERT INTO LoginErrorLog 
(ErrorLogID, ErrorTime, FailedTransactionXML)
VALUES 
	(9901, '2022-06-24', 'D:\Alexia\SQL_XML\20220624.xml'), 
	(9902, '2022-07-08', 'D:\Alexia\SQL_XML\20220708.xml'), 
	(9903, '2022-11-15', 'D:\Alexia\SQL_XML\20221115.xml'), 
	(9904, '2023-05-21', 'D:\Alexia\SQL_XML\20230521.xml'), 
	(9905, '2023-05-23', 'D:\Alexia\SQL_XML\20230523.xml');

SELECT *
FROM LoginErrorLog;


--Security questions are randomly generated
--And everyone's security questions may be different
CREATE TABLE UserSecurityQuestions
(
UserSecurityQuestionID	tinyint		NOT NULL PRIMARY KEY, 
UserSecurityQuestion	varchar(50)	NOT NULL, 
UserSecurityQuestion2	varchar(50)	NOT NULL, 
UserSecurityQuestion3	varchar(50)	NOT NULL);

INSERT INTO UserSecurityQuestions (UserSecurityQuestionID, UserSecurityQuestion, UserSecurityQuestion2, UserSecurityQuestion3)
VALUES
	(101, 'What is your favorite color?', 'What is your pet''s name?', 'Where were you born?'),
	(102, 'What is your mother''s maiden name?', 'What is your favorite movie?', 'What is your favorite book?'),
	(103, 'What is the name of your first school?', 'Who is your favorite actor?', 'What is your favorite food?'),
	(104, 'What is your childhood nickname?', 'What is your favorite sports team?', 'What is your dream vacation destination?'),
	(105, 'What is your favorite hobby?', 'What is your favorite song?', 'What is your favorite animal?');

SELECT *
FROM UserSecurityQuestions;


--UserLoginID is both a Primary Key and a Foreign Key
CREATE TABLE UserSecurityAnswers
(
UserLoginID					smallint	NOT NULL PRIMARY KEY, 
UserSecurityQuestionID		tinyint		NOT NULL 
	foreign key references UserSecurityQuestions(UserSecurityQuestionID), 
UserSecurityQuestionAnswer	varchar(25)	NOT NULL, 
UserSecurityQuestionAnswer2	varchar(25)	NOT NULL, 
UserSecurityQuestionAnswer3	varchar(25)	NOT NULL);

Alter Table UserSecurityAnswers
Add Foreign Key (UserLoginID) references UserLogins(UserLoginID);

INSERT INTO UserSecurityAnswers (UserLoginID, UserSecurityQuestionID, 
	UserSecurityQuestionAnswer, UserSecurityQuestionAnswer2, UserSecurityQuestionAnswer3)
VALUES
	(1, 101, 'Blue', 'Max', 'New York'),
	(2, 102, 'Smith', 'The Shawshank Redemption', 'To Kill a Mockingbird'),
	(3, 103, 'ABC School', 'Tom Hanks', 'Pizza'),
	(4, 104, 'Sunny', 'Manchester United', 'Bora Bora'),
	(5, 105, 'Gardening', 'Hotel California', 'Dolphin');

SELECT *
FROM UserSecurityAnswers;


--EmployeeID is automatically generated
CREATE TABLE Employee
(
EmployeeID				int		IDENTITY NOT NULL PRIMARY KEY, 
EmployeeFirstName		varchar(25)		NOT NULL, 
EmployeeMiddleInitial	char(1)			NOT NULL, 
EmployeeLastName		varchar(25)		NOT NULL, 
EmployeeIsManager		bit				NOT NULL);

INSERT INTO Employee (EmployeeFirstName, EmployeeMiddleInitial, 
	EmployeeLastName, EmployeeIsManager)
VALUES
    ('Nick', 'D', 'Doe', 1),
    ('Jane', 'M', 'Smith', 0),
    ('Michael', 'S', 'Johnson', 1),
    ('Emily', 'R', 'Davis', 0),
    ('Kyle', 'L', 'Wilson', 0);

SELECT *
FROM Employee;


--When inserting data, match AccountID and UserLoginID to keep the data consistent
CREATE TABLE Customer
(
CustomerID				int		IDENTITY NOT NULL PRIMARY KEY, 
AccountID				int			NOT NULL foreign key references Account(AccountID), 
CustomerAddress1		varchar(30)	NOT NULL, 
CustomerAddress2		varchar(30)	NOT NULL, 
CustomerFirstName		varchar(30)	NOT NULL, 
CustomerMiddleInitial	char(1)		NOT NULL, 
CustomerLastName		varchar(30)	NOT NULL, 
City					varchar(20)	NOT NULL, 
State					char(2)		NOT NULL, 
ZipCode					char(10)	NOT NULL, 
EmailAddress			varchar(40)	NOT NULL, 
HomePhone				char(10)	NOT NULL, 
CellPhone				char(10)	NOT NULL, 
WorkPhone				char(10)	NOT NULL, 
SSN						char(9)		NOT NULL, 
UserLoginID				smallint	NOT NULL foreign key references UserLogins(UserLoginID));

INSERT INTO Customer (AccountID, CustomerAddress1, CustomerAddress2, CustomerFirstName, CustomerMiddleInitial, CustomerLastName, City, State, ZipCode, EmailAddress, HomePhone, CellPhone, WorkPhone, SSN, UserLoginID)
VALUES
    (100001, '123 Main Street', 'Apt 456', 'Join', 'S', 'Johnson', 'New York', 'NY', '12345', 'john.doe@example.com', '1234567890', '9876543210', '5555555555', '123456789', 1),
    (100002, '456 Elm Street', 'Apt 789', 'Carry', 'L', 'White', 'Los Angeles', 'CA', '67890', 'jane.smith@example.com', '1111111111', '9999999999', '4444444444', '987654321', 2),
    (100003, '789 Oak Street', 'Suite 123', 'Nick', 'D', 'Doe', 'Chicago', 'IL', '45678', 'michael.johnson@example.com', '2222222222', '8888888888', '3333333333', '654321987', 3),
    (100004, '321 Pine Street', 'Apt 567', 'Kyle', 'L', 'Wilson', 'San Francisco', 'CA', '56789', 'emily.davis@example.com', '4444444444', '7777777777', '2222222222', '789456123', 4),
    (100005, '654 Cedar Street', 'Suite 890', 'Anna', 'A', 'Green', 'Seattle', 'WA', '89012', 'david.wilson@example.com', '5555555555', '6666666666', '1111111111', '456123789', 5);

SELECT *
FROM Customer;


--Correspond the data of Account and Customer
CREATE TABLE Customer_Account
(
AccountID		int		NOT NULL foreign key references Account(AccountID), 
CustomerID		int		NOT NULL foreign key references Customer(CustomerID));

INSERT INTO Customer_Account 
(AccountID, CustomerID)
VALUES 
	(100001, 1), 
	(100002, 2), 
	(100003, 3), 
	(100004, 4), 
	(100005, 5);

SELECT *
FROM Customer_Account;


--When an employee opens an account, performs a transaction on or reactivates an account 
--there must be a record of which employee  performed the action
--So EmployeeID must be NOT NULL
CREATE TABLE TransactionLog
(
TransactionID			int		IDENTITY	NOT NULL PRIMARY KEY, 
TransactionDate			datetime	NOT NULL, 
TransactionTypeID		tinyint		NOT NULL foreign key references TransactionType(TransactionTypeID), 
TransactionAmount		money		NOT NULL, 
AccountID				int			NOT NULL foreign key references Account(AccountID),
CustomerID				int			NOT NULL foreign key references Customer(CustomerID),
EmployeeID				int			NOT NULL foreign key references Employee(EmployeeID),
UserLoginID				smallint	NOT NULL foreign key references UserLogins(UserLoginID),
DateOpened				datetime	NOT NULL, 
OpeningBalance			money		NOT NULL, 
ReactivationDate		datetime	NOT NULL, 
OldBalance				money		NOT NULL, 
NewBalance				money		NOT NULL);

INSERT INTO TransactionLog (TransactionDate, TransactionTypeID, TransactionAmount, AccountID, CustomerID, EmployeeID, UserLoginID, DateOpened, OpeningBalance, ReactivationDate, OldBalance, NewBalance)
VALUES
    ('2022-03-11 09:00:00', 1, 395.00, 100003, 3, 2, 3, '2022-01-01 08:00:00', 500.00, '2022-01-01 10:00:00', 995.00, 600.00),
    ('2022-05-02 10:00:00', 3, 5000.00, 100002, 2, 1, 2, '2022-01-02 09:00:00', 1000.00, '2022-01-02 11:00:00', 1000.00, 6000.00),
    ('2022-08-21 11:00:00', 4, 200.00, 100004, 4, 4, 4, '2021-05-13 10:00:00', 1500.00, '2022-06-14 12:00:00', 1500.00, 1700.00),
    ('2022-11-18 12:00:00', 5, 175.00, 100001, 1, 5, 1, '2022-03-04 11:00:00', 2000.00, '2022-03-04 13:00:00', 2000.00, 1825.00),
    ('2023-01-05 13:00:00', 2, 1500.00, 100004, 4, 2, 4, '2023-01-01 12:00:00', 2500.00, '2023-01-01 14:00:00', 2500.00, 1000.00);

SELECT *
FROM TransactionLog;


--There are various Transaction Type, I give this table 5 types
CREATE TABLE TransactionType
(
TransactionTypeID			tinyint		NOT NULL PRIMARY KEY, 
TransactionTypeName			char(10)	NOT NULL, 
AccountReactivationLogID	int			NOT NULL, 
TransactionTypeDescription	varchar(50)	NOT NULL, 
TransactionFeeAmount		smallmoney	NOT NULL);

INSERT INTO TransactionType (TransactionTypeID, TransactionTypeName, 
	AccountReactivationLogID, TransactionTypeDescription, TransactionFeeAmount)
VALUES
    (1, 'Purchase', 101, 'Purchase transaction', 1.00),
    (2, 'Withdrawal', 102, 'Withdrawal transaction', 5.00),
    (3, 'Deposit', 103, 'Deposit transaction', 1.00),
    (4, 'Transfer', 104, 'Transfer transaction', 2.00),
    (5, 'Payment', 105, 'Payment transaction', 0.00);

SELECT *
FROM TransactionType;


--There are various Transaction ErrorType, I give this table 5 types
CREATE TABLE FailedTransactionErrorType
(
FailedTransactionErrorTypeID		tinyint		NOT NULL PRIMARY KEY, 
FailedTransactionDescription		varchar(50)	NOT NULL);

INSERT INTO FailedTransactionErrorType (FailedTransactionErrorTypeID, 
	FailedTransactionDescription)
VALUES
	(201, 'Invalid Account Number'),
	(202, 'Insufficient Funds'),
	(203, 'Invalid Transaction Amount'),
	(204, 'Transaction Timeout'),
	(205, 'Network Connection Failure');

SELECT *
FROM FailedTransactionErrorType;


--Name the .xml file with the FailedTransactionID
CREATE TABLE FailedTransactionLog
(
FailedTransactionID				int			NOT NULL PRIMARY KEY, 
FailedTransactionErrorTypeID	tinyint		NOT NULL 
	foreign key references FailedTransactionErrorType(FailedTransactionErrorTypeID), 
FailedTransactionErrorTime		datetime	NOT NULL, 
FailedTransactionXML			xml			NOT NULL);

INSERT INTO FailedTransactionLog (FailedTransactionID, FailedTransactionErrorTypeID, 
	FailedTransactionErrorTime, FailedTransactionXML)
VALUES
	(8801, 202, '2022-05-01 09:00:00', 'D:\Alexia\SQL_XML\8801.xml'),
	(8802, 204, '2022-07-22 10:00:00', 'D:\Alexia\SQL_XML\8802.xml'),
	(8803, 204, '2023-01-03 11:00:00', 'D:\Alexia\SQL_XML\8803.xml'),
	(8804, 205, '2023-01-30 12:00:00', 'D:\Alexia\SQL_XML\8804.xml'),
	(8805, 203, '2023-03-15 13:00:00', 'D:\Alexia\SQL_XML\8805.xml');

SELECT *
FROM FailedTransactionLog;




