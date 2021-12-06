--  -------------------------------------------------------------------------------------------------------------------------------
create database if not exists energy_app;
use energy_app;
--  -------------------------------------------------------------------------------------------------------------------------------
select * from mysql.user;

--  -------------------------------------------------------------------------------------------------------------------------------
-- The default SQL user account used for the connection between the user application and the energy_app database.
-- Different from the user applications user accounts.
CREATE USER if not exists 'energy_app_user'@'%' IDENTIFIED BY '1234';
grant select on energy_app.* to 'energy_app_user'@'%';
grant insert on energy_app.* to 'energy_app_user'@'%';
grant update on energy_app.* to 'energy_app_user'@'%';
grant execute on energy_app.* to 'energy_app_user'@'%';

show grants for energy_app_user;
select * from mysql.user;
--  -------------------------------------------------------------------------------------------------------------------------------
drop table if exists properties;
drop table if exists users;

create table if not exists users(
    username varchar(256) not null unique primary key,
    passwordHash binary(32) not null
);

create table if not exists properties (
    address varchar(256) not null,
    city varchar(256) not null,
    state varchar(2) not null,
    zipcode varchar(32) not null,
    primary key (address, city, state, zipcode),
    username varchar(256) not null,
    FOREIGN KEY (username)
        REFERENCES users (username)
        ON UPDATE RESTRICT ON DELETE RESTRICT
);

--  -------------------------------------------------------------------------------------------------------------------------------
-- For adding a new user to the database.
-- Returns reponse message, 0 for success or 1 otherwise
drop procedure if exists addUser;   
delimiter $$
CREATE procedure addUser(in _username varchar(256), in _pass varchar(256)) 
BEGIN
	declare duplicate_entry_for_key tinyint default false;
    declare continue handler for 1062 set duplicate_entry_for_key = true;
	INSERT INTO users (username, passwordHash) VALUES(_username, md5(_pass));
    
    if duplicate_entry_for_key = true then
		select 'That user already exists.' as response_msg,
			1 as response_code;
	else
		select 'User added.' as response_msg,
			0 as response_code;	-- on success
	end if;
END
$$
delimiter ;

-- TESTS
select * from users;
delete from users where username = "testuser";
call addUser('testuser', '1234');
delete from users where username = "testuser";
--  -------------------------------------------------------------------------------------------------------------------------------

-- Checks whether the given username and password are correct.
-- Returns 0 if both username and password are correct.
-- Returns 1 if either username or password are incorrect
drop function if exists checkUserPass;
delimiter $$
create function checkUserPass(_username varchar(256), _pass varchar(256))
	returns int deterministic contains sql
    begin
		declare stored_password_hash binary(32);
        declare inputted_password_hash binary(32);
		set inputted_password_hash = md5(_pass);
		
        select passwordHash into stored_password_hash from users where username = _username;
        
        if stored_password_hash = inputted_password_hash then
			return 0;
		else
			return -1;
		end if;
    end $$
delimiter ;

-- TESTS
select * from users;
delete from users where username = "testuser";
call addUser('testuser', '1234');
select checkUserPass("testuser", "1234");	-- should return 0
select checkUserPass("testuser", "12345");	-- should return -1
delete from users where username = "testuser";

--  -------------------------------------------------------------------------------------------------------------------------------
-- For adding a new property to the database
-- Returns response message, 0 for success or 1 otherwise
drop procedure if exists addProperty;
delimiter $$
CREATE procedure addProperty(in _username varchar(256), in _address varchar(256), in _city varchar(256), in _state varchar(2), in _zipcode varchar(32))
BEGIN
	declare duplicate_entry_for_key tinyint default false;
    declare user_does_not_exist tinyint default false;
    declare continue handler for 1062 set duplicate_entry_for_key = true;
    declare continue handler for 1452 set user_does_not_exist = true;
    
    
	INSERT INTO properties (address, city, state, zipcode, username) VALUES(_address, _city, _state, _zipcode, _username);
    
    if user_does_not_exist = true then
		select 'The current user does not exist in the database.' as response_msg,
			1 as response_code;
    elseif duplicate_entry_for_key = true then
		select 'That property already exists.' as response_msg,
			1 as response_code;
	else
		select 'Property added to your portfolio.' as response_msg,
			0 as response_code;	-- on success
	end if;
END
$$
delimiter ;

-- TESTS
select * from users;
select * from properties;
delete from properties where username = "dantaki";
delete from users where username = "dantaki";
call addProperty('dantaki', '1','2','MA','3'); -- should fail
call addUser('dantaki', '1234');	-- should work
call addProperty('dantaki', '1','2','MA','3'); -- should work
call addProperty('dantaki', '1','2','MA','3'); -- should fail
call addProperty('bob', '1','2','MA','3'); -- should fail
--  -------------------------------------------------------------------------------------------------------------------------------
-- For removing a property from the database
-- Returns response message, 0 for success or 1 otherwise
drop procedure if exists removeProperty;
delimiter $$
CREATE procedure removeProperty(in _username varchar(256), in _address varchar(256), in _city varchar(256), in _state varchar(2), in _zipcode varchar(32))
BEGIN
    declare user_does_not_exist tinyint default false;
    declare continue handler for 1452 set user_does_not_exist = true;
    
    delete from properties where username=_username and _address=address and _city=city and _state=state and _zipcode=zipcode;
    
    if user_does_not_exist = true then
		select 'The current user does not exist in the database.' as response_msg,
			1 as response_code;
	else
		select 'Property removed from your portfolio.' as response_msg,
			0 as response_code;	-- on success
	end if;
END
$$
delimiter ;

-- TESTS
select * from users;
select * from properties;
delete from properties where username = "dantaki";
delete from users where username = "dantaki";
call addUser('dantaki', '1234');	-- should work
call addProperty('dantaki', '1','2','MA','3'); -- should work
call addProperty('dantaki', '1','2','MA','4'); -- should work
call removeProperty('dantaki', '1','2','MA','3'); -- should work
--  -------------------------------------------------------------------------------------------------------------------------------
-- Returns all properties for a given user
drop procedure if exists getAllProperties;
delimiter $$
CREATE procedure getAllProperties(in _username varchar(256))
BEGIN
	select address, city, state, zipcode from properties where username = _username;
END
$$
delimiter ;

-- TESTS
select * from users;
select * from properties;
delete from properties where username = "dantaki";
delete from users where username = "dantaki";
call addUser('dantaki', '1234');	-- should work
call addUser('bob', '1234');	-- should work
call addProperty('dantaki', '1','2','MA','3'); -- should work
call addProperty('dantaki', '1','2','MA','4'); -- should work
call addProperty('bob', '1','2','MA','5'); -- should work
call getAllProperties('bob');
call getAllProperties('dantaki');
call getAllProperties('tim'); -- should just return empty
--  -------------------------------------------------------------------------------------------------------------------------------
-- Bulk test tuples
call addUser('dantaki', '1234');
call addProperty('dantaki', '1','2','MA','3');

--  -------------------------------------------------------------------------------------------------------------------------------

create table if not exists utilityProvider (
    name varchar(32) not null PRIMARY KEY
);

create table if not exists utilityBill (
    month varchar(16) not null,
    year int not null,
    address varchar(256) not null,
    city varchar(256) not null,
    state varchar(2) not null,
    zipcode varchar(32) not null,
    energyConsumptionKWh int not null, 
    energyCost decimal(5,2) not null,
    primary key (month, year, address, city, state, zipcode),
    FOREIGN KEY (address, city, state, zipcode)
        REFERENCES properties (address, city, state, zipcode)
        ON UPDATE RESTRICT ON DELETE RESTRICT
);

-- For adding a new utility bill to the database
-- Returns response message, 0 for success or 1 otherwise
drop procedure if exists addBill;
delimiter $$
CREATE procedure addBill(in _month varchar(16), in _year int, in _address varchar(256), in _city varchar(256), in _state varchar(2), in _zipcode varchar(32), in _energyConsumptionKWh int, in _energyCost decimal(5,2))
BEGIN
	declare duplicate_entry_for_key tinyint default false;
    declare user_does_not_exist tinyint default false;
    declare continue handler for 1062 set duplicate_entry_for_key = true;
    declare continue handler for 1452 set user_does_not_exist = true;
    
    
	INSERT INTO utilityBill (month, year, address, city, state, zipcode, energyConsumptionKWh, energyCost) VALUES(_month, _year, _address, _city, _state, _zipcode, _energyConsumptionKWh, _energyCost);
    
    if user_does_not_exist = true then
		select 'The current user does not exist in the database.' as response_msg,
			1 as response_code;
    elseif duplicate_entry_for_key = true then
		select 'That bill already exists.' as response_msg,
			1 as response_code;
	else
		select 'Bill added to your portfolio.' as response_msg,
			0 as response_code;	-- on success
	end if;
END
$$
delimiter ;

-- For removing a property from the database
-- Returns response message, 0 for success or 1 otherwise
drop procedure if exists removeBill;
delimiter $$
CREATE procedure removeBill(in _month varchar(16), in _year int, in _address varchar(256), in _city varchar(256), in _state varchar(2), in _zipcode varchar(32), in _energyConsumptionKWh int, in _energyCost decimal(5,2))
BEGIN
    declare user_does_not_exist tinyint default false;
    declare continue handler for 1452 set user_does_not_exist = true;
    
    delete from utilityBill where month=_month and year=_year and address=_address and city=_city and state=_state and zipcode=_zipcode ;
    
    if user_does_not_exist = true then
		select 'The current user does not exist in the database.' as response_msg,
			1 as response_code;
	else
		select 'Bill removed from your portfolio.' as response_msg,
			0 as response_code;	-- on success
	end if;
END
$$
delimiter ;

-- Returns all bills for a given property
drop procedure if exists getAllBills;
delimiter $$
CREATE procedure getAllBills(in _address varchar(256), in _city varchar(256), in _state varchar(2), zipcode varchar(32))
BEGIN
	select month, year, energyConsumptionKWh, energyCost from utilityBill where address = _address & city = _city & state = _state & zipcode = _zipcode;
END
$$
delimiter ;

-- For adding a new utility provider to the database
-- Returns response message, 0 for success or 1 otherwise
drop procedure if exists addProvider;
delimiter $$
CREATE procedure addProvider(_name varchar (32))
BEGIN
	declare duplicate_entry_for_key tinyint default false;
    declare user_does_not_exist tinyint default false;
    declare continue handler for 1062 set duplicate_entry_for_key = true;
    declare continue handler for 1452 set user_does_not_exist = true;
    
    
	INSERT INTO utilityProvider (name) VALUES(_name);
    
    if user_does_not_exist = true then
		select 'The current user does not exist in the database.' as response_msg,
			1 as response_code;
    elseif duplicate_entry_for_key = true then
		select 'That provider already exists.' as response_msg,
			1 as response_code;
	else
		select 'Utility Provider added to your portfolio.' as response_msg,
			0 as response_code;	-- on success
	end if;
END
$$
delimiter ;


-- Returns all utility providers available
drop procedure if exists getAllProviders;
delimiter $$
CREATE procedure getAllProviders()
BEGIN
	select name from utilityProvider;
END
$$
delimiter ;

-- -- Returns all utility providers for a specific property
drop procedure if exists getPropertyProviders;
delimiter $$
CREATE procedure getPropertyProviders(in _address varchar(256), in _city varchar(256), in _state varchar(2), _zipcode varchar(32))
BEGIN
	select distinct name from utilityBill where address=_address and city=_city and state=_state and zipcode=_zipcode;
END
$$
delimiter ;

-- Test
call addProvider('National Electric');
call addBill ('5', '2020', '1','2','MA','3', '456', '768', 'National Electric');
call getPropertyProviders('1','2','MA','3');
call getAllProviders();

