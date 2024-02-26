This project is a personal project for the purpose of ingesting transactions directly from a user's google account and directly adding them to a user's Expense tracker. 

Firstly this should be called an Email automated Debit Manager. This name is not simple hence we will name it Simple Expense tracker.

MVP as of 26/02/24 :
1.CRUD operations on an Expense
2.All Expenses viewable in a single list
3.Automated Email reading and Creation of Expenses
4.Highlighting of Email read expenses and their annotation flow


Good to have features:
1.Server storage of expense tracking on the basis of Google oAuth
2.Sort and Filter of Expenses


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
TransactionsEditew: View class which deals with create and update of a transaction : has to be opened with a singular parameter of transaction ID, which if blank opens a blank slate for the same



Controller: Layer which contains core logic. It gets informed of the user’s 
behavior and updates the Model as per the need.
TransactionUpsertController : Upserts the transaction into the Transaction Manager class
EmailLoginController : Will ask the user to google login and will create the Gmail Manager class etc!



