# Application Description
This is a simple application that allows a user to store basic energy usage information
about various properties they may own. This could be used by homeowners, 
commercial property owners, or business owners who may want to track their
properties' energy usage.

# Lessons Learned
## Technical expertise gained
* More knowledge on how to design and build an application that uses a
database for storing data as opposed to storing data in the application itself
or in a simple text file.
* Learned how to connect a user facing application (frontend) to a database
(backend).
## Insights, time management insights, data domain insights etc.
* We thought our time was managed well to complete this application.
* About 16 total hours was spent writing the application itself (SQL and Python).
* The frontend code has a lot of duplication. This is a future improvement
for the design. But since the focus was on the overall interaction between
a database and a user application, code resuse was not a priority.
* The user application code was not tested..unfortuntely. This is a future improvement
that would make future development significantly faster.
## Realized or contemplated alternative design / approaches to the project
* We purposely made a utilityBill belong to a property and then a utilityProvider
belong to a utilityBill because we believed this was the simplest approach.
However, it also makes sense that a utilityProvider provides power to a
property (a relationship we didn't directly represent) and a utilityProvider
also issues bills to a property (a relationship we did represent). 
We could have made a 3-way relation in a
separate table which would represent the relationship between a property,
utilityBill, and a utilityProvider.
* The code is contained in 2 files only: 1 for SQL, and 1 for python
code. In the future, or if this application were to extend, the code should be
better segmented out. i.e. SQL schema should be in one file, procedures in another.
## Document any code not working in this section
* All code works as intended that we know of. We did not write tests for our
code which we have noted as a future improvement to the robustness of this
application.

# Future Work
## Planned uses of the database
* For a home user to track their homes energy usage.
* For a commercial property manager to track their properties' energy usages
and costs to give insights into how they could optmize their properties' energy.
## Potential areas for added functionality
* The ability to see how much energy you used for a specific month compared to
national average.
* Ability to see how much an appliance you have costs you for a year based
on your bills if you have at least 1 year's worth of bills.
* More insights into the users data based on more real time energy market data
and costs to help optimize which energy source they are using at a given time.
Such as using stationary storage during peak demand, while using grid power
during low demand.
* Only the most basic information for each entity was included in this application,
following the philosphy of keeping it simple and not adding features or
information that are not absolutely necessary. We think more data could be
added in the future that would be useful to the user.
* Ability to delete a user's entire account.
* The ability to MOVE utility bills or appliances between properties.
This is currently not supported.
## No future uses or work can be documented if justification is provided.