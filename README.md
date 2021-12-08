# cs3200-database-design-final-project

# “Lessons Learned” section that contains report sections for the following:
## Technical expertise gained
* More knowledge on how to design and build an application that uses a
database for storing data as opposed to storing data in the application itself.
* Learned how to connect a user facing application (frontend) to a database
(backend).
## Insights, time management insights, data domain insights etc.
* We thought our time was managed well to complete this project.
## Realized or contemplated alternative design / approaches to the project
* We purposely made a utilityBill belong to a property and then a utilityProvider
belong to a utilityBill because we believed this was the simplest approach.
However, it also makes sense that a utilityProvider provides power to a
property (a relationship we didn't directly represent) and a utilityProvider
also issues bills to a property (a relationship we did represent). 
We could have made a 3-way relation in a
separate table which would represent the relationship between a property,
utilityBill, and a utilityProvider.
## Document any code not working in this section

# Provide a “Future work” section containing:
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
* Only the most basic information for each entity was included in this project,
following the philosphy of keeping it simple and not adding features or
information that are not absolutely necessary. We think more data could be
added in the future that would be useful to the user.
* Ability to delete a user's entire account.
## No future uses or work can be documented if justification is provided.