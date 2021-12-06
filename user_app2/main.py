import string

import pymysql
from tabulate import tabulate


# TODO: validate all user input to correct lengths (i.e. varchar(255))
# TODO: add comments


# Opens a connection to the energy_app database. A single user account is used for this connection, but multiple
# user accounts are used for the user application with the user account info stored in the energy_user database.
def openDatabaseUserConnection():
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
        cur = cnx.cursor()
        cur.execute("select checkUserPass(%s, %s)", (username, password))
        result = list(cur.fetchone().values())[0]
        if result == -1:
            print("Invalid username or password.")
            loginRegister(cnx)
        else:
            print("Logged in.")
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


def print_menu(menu_options):
    for key in menu_options.keys():
        print(key, '. ', menu_options[key])


def main_menu(cnx, currUserPassDict):
    menu_options = {
        1: "View Properties",
        2: "Add Property",
        3: "Remove Property"}

    while (True):
        print("Main Menu:")
        print_menu(menu_options)
        menu_selection = ''
        try:
            menu_selection = int(input('Menu Selection: '))
        except:
            print('Invalid selection. Please enter a number ...')
        # Check what choice was entered and act accordingly
        if menu_selection == 1:
            view_properties(cnx, currUserPassDict)
        elif menu_selection == 2:
            add_property(cnx, currUserPassDict)
        elif menu_selection == 3:
            remove_property(cnx, currUserPassDict)
        else:
            print('Invalid selection.')


def view_properties(cnx, currUserPassDict):
    print("Your properties: ")
    cur = cnx.cursor()
    cur.execute("call getAllProperties(%s)", (currUserPassDict["username"]))
    result = cur.fetchall()
    for i in range(len(result)):
        print(str(i + 1) + ". " + result[i]["address"] + " " + result[i]["city"] + ", " + result[i]["state"] + " " +
              result[i]["zipcode"])
    return result


def add_property(cnx, currUserPassDict):
    address = input("Enter the address: ")
    city = input("Enter the city: ")
    state = str.upper(input("Enter the 2 letter state: "))
    zipcode = input("Enter the zipcode: ")

    cur = cnx.cursor()
    cur.execute("call addProperty(%s, %s, %s, %s, %s)",
                (currUserPassDict["username"], address, city, state, zipcode))
    cnx.commit()
    result = cur.fetchone()
    print(result["response_msg"])


def remove_property(cnx, currUserPassDict):
    # Loop until valid selection or quit
    while (True):
        your_properties = view_properties(cnx, currUserPassDict)
        selection = input("Select the property to remove or 'q' to quit: ")
        # Check if quit
        if selection == 'q' or selection == 'Q':
            return
        # Convert selection to integer index
        selection = int(selection) - 1
        if selection not in range(len(your_properties)):
            print("Invalid selection.")
        else:
            cur = cnx.cursor()
            cur.execute("call removeProperty(%s, %s, %s, %s, %s)",
                        (
                            currUserPassDict["username"], your_properties[selection]["address"],
                            your_properties[selection]["city"],
                            your_properties[selection]["state"], your_properties[selection]["zipcode"]))
            cnx.commit()
            result = cur.fetchone()
            print(result["response_msg"])
            return


def main():
    # Connection to energy_app database
    cnx = openDatabaseUserConnection()
    # Stores the current users credentials
    currUserPassDict = loginRegister(cnx)
    # Go to main menu
    main_menu(cnx, currUserPassDict)

    # Close connection to database
    cnx.close()


if __name__ == '__main__':
    main()
