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
    username = ""
    password = ""
    # Login Menu
    validMenuOptions = ['1', '2']
    while True:
        #  Login menu
        print("Login Menu:")
        print(validMenuOptions[0] + ". Login")
        print(validMenuOptions[1] + ". Register")
        menuSelection = input("Menu Selection: ")
        # Check menu input
        if menuSelection not in validMenuOptions:
            print("Invalid menu selection")
        else:
            break

    # Login
    if menuSelection == validMenuOptions[0]:
        # Get username and password
        username = input("Enter Username: ")
        password = input("Enter Password: ")
        # Check that the inputted account is in the database and is correct

        return {"username": username, "password": password}

    # Register
    elif menuSelection == validMenuOptions[1]:
        while (True):
            username = input("Enter New Username: ")
            if username == "" or username == None:
                print("Username cannot be blank")
            else:
                break

        while (True):
            password = input("Enter New Password: ")
            if password == "" or password == None:
                print("Password cannot be blank")
            else:
                break

        cur = cnx.cursor()
        cur.execute("call addUser(%s, %s)", (username, password))
        cnx.commit()
        result = cur.fetchone()
        print(result["response_msg"])

        # If not valid registration, go back to login menu
        if result["response_code"] == 1:
            loginRegister(cnx)
        else:
            return {"username": username, "password": password}


def mainMenu():
    print("Main Menu:")


def main():
    # Connection to energy_app database
    cnx = openDatabaseUserConnection()
    # Stores the current users credentials
    currUserPassDict = loginRegister(cnx)
    # Go to main menu
    mainMenu(currUserPassDict)


    # Close connection to database
    cnx.close()


if __name__ == '__main__':
    main()
