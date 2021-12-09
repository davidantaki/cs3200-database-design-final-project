import pymysql
from tabulate import tabulate


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
        4: "Update Property",
        5: "View Utility Bills",
        6: "Add Utility Bill",
        7: "Remove Utility Bill",
        8: "View Utility Providers",
        9: "Add Utility Provider",
        10: "View Appliances",
        11: "Add Appliance",
        12: "Remove Appliance",
        13: "Update Appliance",
        14: "View Energy Data for your State",
        15: "Compare Bill to Avg",
        16: "Logout"
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
            update_property(cnx, currentUser)
        elif menu_selection == 5:
            view_bills(cnx, currentUser)
        elif menu_selection == 6:
            add_bill(cnx, currentUser)
        elif menu_selection == 7:
            remove_bill(cnx, currentUser)
        elif menu_selection == 8:
            view_utility_providers(cnx, currentUser)
        elif menu_selection == 9:
            add_utility_provider(cnx, currentUser)
        elif menu_selection == 10:
            view_appliances(cnx, currentUser)
        elif menu_selection == 11:
            add_appliance(cnx, currentUser)
        elif menu_selection == 12:
            remove_appliance(cnx, currentUser)
        elif menu_selection == 13:
            update_appliance(cnx, currentUser)
        elif menu_selection == 14:
            get_state_avg_energy_data_input(cnx, currentUser)
        elif menu_selection == 15:
            compare_bill_to_avg(cnx, currentUser)
        elif menu_selection == 16:
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
            property = your_properties[selection]
            # Confirm removal
            print("Removing this property: " + property["address"] + ", " +
                  property["city"] + ", " + property["state"] + " " + property["zipcode"])

            # Confirm delete
            while True:
                confirm = input(
                    "Removing this property will also remove all bills associated with the property. Continue? (y/n)")
                if str.lower(confirm) == 'n':
                    print("Cancelling")
                    return
                elif str.lower(confirm) == 'y':
                    break
                else:
                    print("Invalid input.")

            cur = cnx.cursor()
            cur.execute("call removeProperty(%s, %s, %s, %s, %s)",
                        (currentUser, property["address"],
                         property["city"], property["state"], property["zipcode"]))
            cnx.commit()
            result = cur.fetchone()
            print(result["response_msg"])
            return


def update_property(cnx, currentUser):
    # Loop until valid selection or quit
    while (True):
        your_properties = view_properties(cnx, currentUser)
        selection = input("Select the property to update or 'q' to quit: ")
        # Check if quit
        if checkQuit(selection):
            return
        # Convert selection to integer index
        selection = int(selection)
        if not valid_tuple(your_properties, selection):
            print("Invalid selection.")
        else:
            origP = your_properties[selection]
            break

    address = input("Enter the new address, or leave blank to keep the same: ")
    city = input("Enter the new city, or leave blank to keep the same: ")
    state = str.upper(input("Enter the new 2 letter state, or leave blank to keep the same: "))
    zipcode = input("Enter the new zipcode, or leave blank to keep the same: ")

    # Check for blanks that are to be kept the same
    if address == "":
        address = origP["address"]
    if city == "":
        city = origP["city"]
    if state == "":
        state = origP["state"]
    if zipcode == "":
        zipcode = origP["zipcode"]

    cur = cnx.cursor()
    cur.execute("call updateProperty(%s, %s, %s, %s, %s, %s, %s, %s, %s)",
                (currentUser, origP["address"], origP["city"], origP["state"], origP["zipcode"], address, city, state,
                 zipcode))
    cnx.commit()
    result = cur.fetchone()
    print(result["response_msg"])


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
            break
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
                print("Invalid selection.")
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


def view_appliances(cnx, currentUser):
    # Loop until valid selection or quit
    while (True):
        properties = view_properties(cnx, currentUser)
        property_selection = input("Select the property to view the appliances of or 'q' to quit: ")
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
                "Appliances for Property " + selected_property["address"] + ", " + selected_property["city"] + ", " +
                selected_property["state"] + " " + selected_property["zipcode"] + ": ")
            cur = cnx.cursor()
            cur.execute("call getAllAppliances(%s, %s, %s, %s)", (
                selected_property["address"], selected_property["city"], selected_property["state"],
                selected_property["zipcode"]))
            result = cur.fetchall()
            print(tabulate(result, headers={"applianceName": "Name",
                                            "avgDailyUsageHr": "Avg Daily Usage (hr)",
                                            "energyRatingKW": "Energy Rating (KW)"},
                           floatfmt=".2f", tablefmt="grid", showindex=True))
            selected_property.update({'appliances': result})
            return selected_property


def add_appliance(cnx, currentUser):
    # Get appliance name and validate
    while True:
        name = input("Enter the appliance name or 'q' to quit: ")
        if checkQuit(name):
            return
        else:
            break

    # Get average usage
    while True:
        avgDailyUsageHr = input("Enter this appliance's average daily usage in hours or 'q' to quit: ")
        if checkQuit(avgDailyUsageHr):
            return
        else:
            try:
                avgDailyUsageHr = float(avgDailyUsageHr)
            except ValueError:
                print("Invalid number of hours.")
            else:
                break

    # Get energy rating
    while True:
        energyRatingKW = input("Enter this appliance's energy rating in kilowatts or 'q' to quit: ")
        if checkQuit(energyRatingKW):
            return
        else:
            try:
                energyRatingKW = float(energyRatingKW)
            except ValueError:
                print("Invalid energy rating.")
            else:
                break

    # Get associated property
    properties = view_properties(cnx, currentUser)
    while True:
        property_selection = input("Select the property this appliance is associated with: ")
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

    p = properties[property_selection]
    cur = cnx.cursor()
    cur.execute("call addAppliance(%s, %s, %s, %s, %s, %s, %s)",
                (name, avgDailyUsageHr, energyRatingKW, p["address"], p["city"], p["state"], p["zipcode"]))
    cnx.commit()
    result = cur.fetchone()
    print(result["response_msg"])


def update_appliance(cnx, currentUser):
    # Get appliance to update and validate selection
    while True:
        property_and_appliances = view_appliances(cnx, currentUser)
        appliances = property_and_appliances["appliances"]
        # Check if there are appliances
        if not appliances:
            print("There are no appliances for this property.")
            return

        selection = input("Select the appliance to update or 'q' to quit: ")
        if checkQuit(selection):
            return
        else:
            try:
                selection = int(selection)
            except ValueError:
                print("Invalid selection.")
            if not valid_tuple(appliances, selection):
                print("Invalid selection.")
            else:
                old_appliance = appliances[selection]
                break

    # Get new appliance name and validate
    while True:
        newName = input("Enter the new appliance name, or leave blank to keep the same, or 'q' to quit: ")
        if checkQuit(newName):
            return
        elif newName == "":
            newName = old_appliance["applianceName"]
            break
        else:
            break

    # Get average usage
    while True:
        avgDailyUsageHr = input(
            "Enter this appliance's new average daily usage in hours, or leave blank to keep the same, or 'q' to quit: ")
        if checkQuit(avgDailyUsageHr):
            return
        elif avgDailyUsageHr == "":
            avgDailyUsageHr = old_appliance["avgDailyUsageHr"]
            break
        else:
            try:
                avgDailyUsageHr = int(avgDailyUsageHr)
            except ValueError:
                print("Invalid number of hours.")
            else:
                break

    # Get energy rating
    while True:
        energyRatingKW = input(
            "Enter this appliance's new energy rating in kilowatts, or leave blank to keep the same, or 'q' to quit: ")
        if checkQuit(energyRatingKW):
            return
        elif energyRatingKW == "":
            energyRatingKW = old_appliance["energyRatingKW"]
            break
        else:
            try:
                energyRatingKW = int(energyRatingKW)
            except ValueError:
                print("Invalid energy rating.")
            else:
                break

    cur = cnx.cursor()
    cur.execute("call updateAppliance(%s, %s, %s, %s, %s, %s, %s, %s)",
                (old_appliance["applianceName"], newName, avgDailyUsageHr, energyRatingKW,
                 property_and_appliances["address"], property_and_appliances["city"],
                 property_and_appliances["state"], property_and_appliances["zipcode"]))
    cnx.commit()
    result = cur.fetchone()
    print(result["response_msg"])


def remove_appliance(cnx, currentUser):
    # Get appliance to remove and validate selection
    while True:
        property_and_appliances = view_appliances(cnx, currentUser)
        appliances = property_and_appliances["appliances"]
        # Check if there are appliances
        if not appliances:
            print("There are no appliances for this property.")
            return

        selection = input("Select the appliance to remove or 'q' to quit: ")
        if checkQuit(selection):
            return
        else:
            try:
                selection = int(selection)
            except ValueError:
                print("Invalid selection. Month must be an integer between 1 and 12")
            if not valid_tuple(appliances, selection):
                print("Invalid selection.")
            else:
                appliance = appliances[selection]
                cur = cnx.cursor()
                cur.execute("call removeAppliance(%s, %s, %s, %s, %s)",
                            (appliance["applianceName"], property_and_appliances["address"],
                             property_and_appliances["city"],
                             property_and_appliances["state"], property_and_appliances["zipcode"]))
                cnx.commit()
                result = cur.fetchone()
                print(result["response_msg"])
                return


# Gets and prints the avg energy data from the database of the given state
def get_state_avg_energy_data_input(cnx, currentUser):
    while True:
        state = input("Enter the 2 letter state name you want to get energy data of: ")
        cur = cnx.cursor()
        try:
            cur.execute("call getAvgData(%s)", state)
            break
        except pymysql.err.DataError:
            print("Invalid State. Must be a 2 letter state name."
                  "")

    result = cur.fetchall()
    print(tabulate(result, headers={"twoLetterState": "State",
                                    "avgMonthlyConsumptionKWh": "Avg Monthly Consumption (KWh)",
                                    "avgPriceCentsPerKWh": "Avg Price (Cents/KWh)",
                                    "avgMonthlyBillDollars": "Avg Monthly Bill ($)"},
                   floatfmt=".2f", tablefmt="grid", showindex=True))
    return result


def get_state_avg_energy_data(cnx, currentUser, state):
    cur = cnx.cursor()
    try:
        cur.execute("call getAvgData(%s)", state)
    except pymysql.err.DataError:
        print("Invalid State. Must be a 2 letter state name.")
    return cur.fetchone()


def compare_bill_to_avg(cnx, currentUser):
    # Get bill to compare and validate selection
    while True:
        property_and_bills = view_bills(cnx, currentUser)
        bills = property_and_bills["bills"]
        # Check if there are bills
        if not bills:
            print("There are no bills for this property.")
            return

        selection = input("Select the bill to compare to avg or 'q' to quit: ")
        if checkQuit(selection):
            return
        else:
            try:
                selection = int(selection)
            except ValueError:
                print("Invalid selection.")
            if not valid_tuple(bills, selection):
                print("Invalid selection.")
            else:
                break

    bill = bills[selection]
    avg_energy_data = get_state_avg_energy_data(cnx, currentUser, property_and_bills["state"])
    avg_consumption = avg_energy_data["avgMonthlyConsumptionKWh"]
    your_consumption_KWh = bill["energyConsumptionKWh"]
    difference = avg_consumption - your_consumption_KWh

    if difference > 0:
        print("You used " + str(abs(difference)) + "KWh less energy than the average in your state for the month: " +
              str(bill["month"]) + "/" + str(bill["year"]))
    else:
        print("You used " + str(abs(difference)) + "KWh more energy than the average in your state for the month: " +
              str(bill["month"]) + "/" + str(bill["year"]))


def main():
    # Connection to energy_app database
    cnx = openDatabaseUserConnection()
    # Login/register menu
    loginRegister(cnx)
    # Close connection to database
    cnx.close()


if __name__ == '__main__':
    main()
