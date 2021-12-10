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
    validMenuOptions = ['0', '1']
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
    currUserPassDict = {}



    # Get all characters names from lotrfinal db
    cur = cnx.cursor()
    cur.execute("select character_name from lotr_character order by character_name")
    allCnamesDict = cur.fetchall()
    allCnamesList = list(map(lambda x: x["character_name"], allCnamesDict))
    allCnamesListLower = list(map(lambda x: x.lower(), allCnamesList))

    # Print all character names and get one character name from user
    print("Here is a list of all the characters currently in the lotr database:")
    cnameStrList = ""
    for cname in allCnamesList:
        cnameStrList += cname
        if cname is not allCnamesList[-1]:
            cnameStrList += ", "
    print(cnameStrList)

    # Loop if there are characters in the database and until valid character name is inputted
    inputtedCname = None
    if len(allCnamesList) != 0:
        while not inputtedCname:
            # Get character name
            inputtedCname = input("Enter a character's name from the list above: ")

            # Validate the user inputted character name and print error message if character name was invalid
            if inputtedCname.lower() not in allCnamesListLower:
                print("The entered character name was not found in the database: " + inputtedCname)
                inputtedCname = None
    else:
        print("There are no characters in the database. Exiting...")
        exit()

    # Call procedure track_character()
    cur = cnx.cursor()
    cur.callproc('track_character', (inputtedCname,))

    # Print result set
    print("Result set of track_character procedure call with " + inputtedCname + ":")
    print()
    resultSetRows = cur.fetchall()
    print(tabulate(resultSetRows, headers="keys"))
    print()

    # Close database connection
    print("Closing database connection and exiting...")
    cnx.close()


if __name__ == '__main__':
    main()
