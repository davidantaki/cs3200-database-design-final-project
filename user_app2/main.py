import pymysql
from tabulate import tabulate


# Opens a connection to the energy_app database. A single user account is used for this connection, but multiple
# user accounts are used for the user application with the user account info stored in the energy_user database.
def openDatabaseUserConnection():
    # global cnx

    # Get username and password
    dbUserPassDict = {}
    dbUserPassDict["username"] = "energy_app_user"
    dbUserPassDict["password"] = "1234"

    # Open database connection
    try:
        cnx = pymysql.connect(host='localhost', user=dbUserPassDict["username"],
                              password=dbUserPassDict["password"],
                              db='energy_app', charset='utf8mb4',
                              cursorclass=pymysql.cursors.DictCursor)

    except pymysql.err.OperationalError as e:
        print('Error: %d: %s' % (e.args[0], e.args[1]))

    return cnx


# Displays login menu for logging into an existing user account or creating a new one.
def loginRegister(cnx):
    currUserPassDict = {}
    # Login Menu
    validMenuOptions = ['1', '2']
    while True:
        #  Login menu
        print(validMenuOptions[0] + ". Login")
        print(validMenuOptions[1] + ". Register")
        menuSelection = input("Menu Selection: ")
        # Check menu input
        if menuSelection not in validMenuOptions:
            print("Invalid menu selection")
        else:
            break

    if menuSelection == validMenuOptions[0]:
        # Get username and password
        currUserPassDict["username"] = input("Enter Username: ")
        currUserPassDict["password"] = input("Enter Password: ")
        # Check that the inputted account is in the database and is correct


        return currUserPassDict

    elif menuSelection == validMenuOptions[1]:
        print()


def main():
    # Connection to energy_app database
    cnx = openDatabaseUserConnection()
    # Stores the current users credentials
    loginRegister(cnx)
    currUserPassDict = {}


if __name__ == '__main__':
    main()
