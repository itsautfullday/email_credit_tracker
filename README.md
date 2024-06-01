This is a personal project for the purpose of ingesting transactions directly from a user's google account and directly adding them to a user's Expense tracker. 

Firstly this should be called an Email automated Debit Manager. This name is not simple hence we will name it Simple Expense tracker.

MVP as of 26/02/24 :
1.CRUD operations on an Expense 
2.All Expenses viewable in a single list
3.Automated Email reading and Creation of Expenses
4.Highlighting of Email read expenses and their annotation flow

MVP Update as of 1/06/24
1.CRU operations on an Expense :white_check_mark:
2.Delete operation yet to be added : not P0 
2.All Expenses viewable in a single list :white_check_mark:
3.Automated Email reading and Creation of Expenses :white_check_mark:
4.Highlighting of Email read expenses and their annotation flow : not done, not P0


Good to have features:
1.Server storage of expense tracking on the basis of Google oAuth
2.Sort and Filter of Expenses
3.Multi device login : FAR FAR FAR INTO THE FUTURE


Currently this will have no backend deployment necessary
App architecture:

Model: Layer for storing data. It is responsible for handling the domain logic(real-world business rules) and communication with the database and network layers.

Transaction class : which will also have save and load functionality from JSON
Transaction Manager class : Will contain the source of truth to transactions : SingleTon
GmailManager Class : Will manage the google login : Singleton
TimedTransactionIngestor Class : Will manage the automated ingestion of transactions from Email reads : For MVP do on App open!




View: UI(User Interface) layer. It provides the visualization of the data stored in the Model.
Introduction view : Asks the user to google login
TransactionsView: View class which deals with read and display
TransactionsEditView: View class which deals with create and update of a transaction : has to be opened with a singular parameter of transaction ID, which if blank opens a blank slate for the same



Controller: Layer which contains core logic. It gets informed of the user’s 
behavior and updates the Model as per the need.
TransactionUpsertController : Upserts the transaction into the Transaction Manager class
EmailLoginController : Will ask the user to google login and will create the Gmail Manager class etc!



Execution:
1. Create the Introduction View and the Introduction controller - boring but necessary work
2. Create the login flow - Allow for a user's email access on the basis of successfull google login!
4. Create the Transaction class, and the Transaction Manager
5. Create the Transaction Upsert controller and the Transaction Insert flow
6. Create the Transaction view flow
7. Check save and load for transactions
8. Add the TimedTransactionIngestor class : This should then interact with the GmailManager class and read the ingestions and add the unannotated expenses
9. Beautification, documentation


Ideas I want documented from this experience:
1. Overall Documentation of a codebas3
2. For Flutter Apps what and how to create a firebase google auth project that allows for reading of email : Good resources for the same
3. Usage od providers etc