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
    menu_options = {
        1: "Login",
        2: "Register",
        3: "Exit"
    }

    while (True):
        print("Login Menu:")
        print_menu(menu_options)
        menu_selection = ''
        try:
            menu_selection = int(input('Menu Selection: '))
        except:
            print('Invalid selection. Please enter a number ...')
        # Check what choice was entered and act accordingly
        if menu_selection == 1:
            login(cnx)
        elif menu_selection == 2:
            register(cnx)
        elif menu_selection == 3:
            return
        else:
            print('Invalid selection.')


def login(cnx):
    # Get username and password
    username = input("Enter Username: ")
    password = input("Enter Password: ")
    # Check that the inputted account is in the database and is correct
    cur = cnx.cursor()
    cur.execute("select checkUserPass(%s, %s)", (username, password))
    result = list(cur.fetchone().values())[0]
    if result == -1:
        print("Invalid username or password.")
    else:
        print("Logged in.")
        main_menu(cnx, username)


def register(cnx):
    while True:
        username = input("Enter New Username: ")
        if username == "" or username is None:
            print("Username cannot be blank")
        else:
            break

    while True:
        password = input("Enter New Password: ")
        if password == "" or password is None:
            print("Password cannot be blank")
        else:
            password2 = input("Re-Enter New Password: ")
            if password != password2:
                print("Passwords did not match.")
            else:
                break

    cur = cnx.cursor()
    cur.execute("call addUser(%s, %s)", (username, password))
    cnx.commit()
    result = cur.fetchone()
    print(result["response_msg"])

    # If valid registration
    if not result["response_code"] == 1:
        print("Logged In.")
        main_menu(cnx, username)


def print_menu(menu_options):
    for key in menu_options.keys():
        print(key, '...', menu_options[key])


def checkQuit(s):
    if s == 'q' or s == 'Q':
        return True
    else:
        return False


def main_menu(cnx, currentUser):
    menu_options = {
        1: "View Properties",
        2: "Add Property",
        3: "Remove Property",
        4: "View Utility Bills",
        5: "Add Utility Bill",
        6: "Remove Utility Bill",
        7: "View Utility Providers",
        8: "Add Utility Provider",
        9: "Delete Account",
        10: "Logout"
    }

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
            view_properties(cnx, currentUser)
        elif menu_selection == 2:
            add_property(cnx, currentUser)
        elif menu_selection == 3:
            remove_property(cnx, currentUser)
        elif menu_selection == 4:
            view_bills(cnx, currentUser)
        elif menu_selection == 5:
            add_bill(cnx, currentUser)
        elif menu_selection == 6:
            remove_bill(cnx, currentUser)
        elif menu_selection == 7:
            view_utility_providers(cnx, currentUser)
        elif menu_selection == 8:
            add_utility_provider(cnx, currentUser)
        elif menu_selection == 9:
            continue
        elif menu_selection == 10:
            return
        else:
            print('Invalid selection.')


def view_properties(cnx, currentUser):
    print("Your properties: ")
    cur = cnx.cursor()
    cur.execute("call getAllProperties(%s)", currentUser)
    result = cur.fetchall()
    print(tabulate(result, headers={"address": "Address",
                                    "city": "City",
                                    "state": "State",
                                    "zipcode": "Zipcode"},
                   floatfmt=".2f", tablefmt="grid", showindex=True))
    return result


def add_property(cnx, currentUser):
    address = input("Enter the address: ")
    city = input("Enter the city: ")
    state = str.upper(input("Enter the 2 letter state: "))
    zipcode = input("Enter the zipcode: ")

    cur = cnx.cursor()
    cur.execute("call addProperty(%s, %s, %s, %s, %s)",
                (currentUser, address, city, state, zipcode))
    cnx.commit()
    result = cur.fetchone()
    print(result["response_msg"])


def remove_property(cnx, currentUser):
    # Loop until valid selection or quit
    while (True):
        your_properties = view_properties(cnx, currentUser)
        selection = input("Select the property to remove or 'q' to quit: ")
        # Check if quit
        if selection == 'q' or selection == 'Q':
            return
        # Convert selection to integer index
        selection = int(selection)
        if selection not in range(len(your_properties)):
            print("Invalid selection.")
        else:
            cur = cnx.cursor()
            cur.execute("call removeProperty(%s, %s, %s, %s, %s)",
                        (
                            currentUser, your_properties[selection]["address"],
                            your_properties[selection]["city"],
                            your_properties[selection]["state"], your_properties[selection]["zipcode"]))
            cnx.commit()
            result = cur.fetchone()
            print(result["response_msg"])
            return


# Returns a list of bills for the selected property and the selected property info in a dictionary.
# {'address': ..., 'city': ..., 'state': ..., 'zipcode': ..., 'bills': [...]}
def view_bills(cnx, currentUser):
    # Loop until valid selection or quit
    while (True):
        properties = view_properties(cnx, currentUser)
        property_selection = input("Select the property to view the bills of or 'q' to quit: ")
        # Check if quit
        if property_selection == 'q' or property_selection == 'Q':
            return
        # Convert selection to integer index
        property_selection = int(property_selection)
        if property_selection not in range(len(properties)):
            print("Invalid selection.")
        else:
            selected_property = properties[property_selection]
            print(
                "Bills for Property " + selected_property["address"] + ", " + selected_property["city"] + ", " +
                selected_property["state"] + " " + selected_property["zipcode"] + ": ")
            cur = cnx.cursor()
            cur.execute("call getAllBills(%s, %s, %s, %s)", (
                selected_property["address"], selected_property["city"], selected_property["state"],
                selected_property["zipcode"]))
            result = cur.fetchall()
            print(tabulate(result, headers={"month": "Month",
                                            "year": "Year",
                                            "energyConsumptionKWh": "Energy Consumption (KWh)",
                                            "energyCost": "Cost ($)",
                                            "providerName": "Provider"},
                           floatfmt=".2f", tablefmt="grid", showindex=True))
            selected_property.update({'bills': result})
            return selected_property


# Gets an input from user selecting a tuple from a list.
# Assumes a table of tuples has been given to the user to select.
# Validates whether the selected tuple index is in the range of tuples.
# Returns true index if valid, false otherwise.
def valid_tuple(list_of_tuples, selection):
    if selection in range(len(list_of_tuples)):
        return True
    else:
        return False


def add_bill(cnx, currentUser):
    # Get month and validate
    while True:
        month = input("Enter the bill's month: ")
        if checkQuit(month):
            return
        else:
            try:
                month = int(month)
            except ValueError:
                print("Invalid month. Month must be an integer between 1 and 12")
            if month < 1 or month > 12:
                print("Invalid month. Month must be an integer between 1 and 12")
            else:
                break

    # Get year and validate
    while True:
        year = input("Enter the bill's year: ")
        if checkQuit(year):
            return
        else:
            try:
                year = int(year)
            except ValueError:
                print("Invalid year. Year must be an integer between 1 and 9999")
            if year < 1 or year > 9999:
                print("Invalid year. Year must be an integer between 1 and 9999")
            else:
                break

    # Get associated property
    properties = view_properties(cnx, currentUser)
    while True:
        property_selection = input("Select the property this bill is associated with: ")
        if checkQuit(property_selection):
            return
        else:
            try:
                property_selection = int(property_selection)
                if not valid_tuple(properties, property_selection):
                    print("Invalid selection")
                else:
                    break
            except ValueError:
                print("Invalid selection.")

    # Get provider
    utility_providers = view_utility_providers(cnx, currentUser)
    while True:
        utility_provider_selection = input(
            "Select the utility provider that this bill is from, or enter \"add\""
            " if the provider is not listed, or 'q' to quit: ")
        if checkQuit(utility_provider_selection):
            return
        elif utility_provider_selection == "add":
            provider = add_utility_provider(cnx, currentUser)
        else:
            try:
                utility_provider_selection = int(utility_provider_selection)
                if not valid_tuple(properties, utility_provider_selection):
                    print("Invalid selection")
                else:
                    provider = utility_providers[utility_provider_selection]["providerName"]
                    break
            except ValueError:
                print("Invalid selection.")

    # Get cost
    while True:
        cost = input("Enter the cost of this bill in $, or 'q' to quit: ")
        if checkQuit(cost):
            return
        else:
            try:
                cost = int(cost)
                if cost < 0:
                    print("Invalid cost.")
                else:
                    break
            except ValueError:
                print("Invalid cost.")

    # Get usage
    while True:
        usage = input("Enter the usage of this bill in KWh, or 'q' to quit: ")
        if checkQuit(usage):
            return
        else:
            try:
                usage = int(usage)
                if usage < 0:
                    print("Invalid usage. Must be greater than 0")
                else:
                    break
            except ValueError:
                print("Invalid usage. Must be greater than 0.")

    p = properties[property_selection]
    cur = cnx.cursor()
    cur.execute("call addBill(%s, %s, %s, %s, %s, %s, %s, %s, %s)",
                (month, year, p["address"], p["city"], p["state"], p["zipcode"], usage, cost, provider))
    cnx.commit()
    result = cur.fetchone()
    print(result["response_msg"])


def remove_bill(cnx, currentUser):
    # Get bill to remove and validate selection
    while True:
        property_and_bills = view_bills(cnx, currentUser)
        bills = property_and_bills["bills"]
        # Check if there are bills
        if not bills:
            print("There are no bills for this property.")
            return

        selection = input("Select the bill to remove or 'q' to quit: ")
        if checkQuit(selection):
            return
        else:
            try:
                selection = int(selection)
            except ValueError:
                print("Invalid selection. Month must be an integer between 1 and 12")
            if not valid_tuple(bills, selection):
                print("Invalid selection.")
            else:
                bill = bills[selection]
                cur = cnx.cursor()
                cur.execute("call removeBill(%s, %s, %s, %s, %s, %s, %s)",
                            (bill["month"], bill["year"], property_and_bills["address"],
                             property_and_bills["city"],
                             property_and_bills["state"], property_and_bills["zipcode"], bill["providerName"]))
                cnx.commit()
                result = cur.fetchone()
                print(result["response_msg"])
                return


def view_utility_providers(cnx, currentUser):
    print("Utility Providers: ")
    cur = cnx.cursor()
    cur.execute("call getAllProviders()")
    result = cur.fetchall()
    print(tabulate(result, headers={"providerName": "Provider"}, showindex=True, tablefmt="grid"))
    return result


def add_utility_provider(cnx, currentUser):
    provider_name = input("Enter the utility providers name: ")

    cur = cnx.cursor()
    cur.execute("call addProvider(%s)", provider_name)
    cnx.commit()
    result = cur.fetchone()
    print(result["response_msg"])

    return provider_name


def remove_utility_provider(cnx, currentUser):
    # Loop until valid selection or quit
    while (True):
        your_properties = view_properties(cnx, currentUser)
        selection = input("Select the property to remove or 'q' to quit: ")
        # Check if quit
        if selection == 'q' or selection == 'Q':
            return
        # Convert selection to integer index
        selection = int(selection)
        if selection not in range(len(your_properties)):
            print("Invalid selection.")
        else:
            cur = cnx.cursor()
            cur.execute("call removeProperty(%s, %s, %s, %s, %s)",
                        (
                            currentUser, your_properties[selection]["address"],
                            your_properties[selection]["city"],
                            your_properties[selection]["state"], your_properties[selection]["zipcode"]))
            cnx.commit()
            result = cur.fetchone()
            print(result["response_msg"])
            return


def main():
    # Connection to energy_app database
    cnx = openDatabaseUserConnection()

    # Login/register menu
    loginRegister(cnx)

    # Close connection to database
    cnx.close()


if __name__ == '__main__':
    main()
