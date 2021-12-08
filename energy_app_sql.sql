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
-- TABLES

drop table if exists utilitybill;
drop table if exists utilityprovider;
drop table if exists properties;
drop table if exists users;

create table if not exists users(
    username varchar(256) not null unique primary key,
    passwordHash binary(32) not null
);

create table if not exists properties (
    address varchar(256) not null,
    city varchar(128) not null,
    state varchar(2) not null,
    zipcode varchar(16) not null,
    primary key (address, city, state, zipcode),
    username varchar(256) not null,
    FOREIGN KEY (username)
        REFERENCES users (username)
        ON UPDATE RESTRICT ON DELETE RESTRICT
);

drop table if exists utilityProvider;
create table if not exists utilityProvider (
    providerName varchar(256) not null PRIMARY KEY
);

drop table if exists utilityBill;
create table if not exists utilityBill (
    month int not null,
    year int not null,
    address varchar(256) not null,
    city varchar(128) not null,
    state varchar(2) not null,
    zipcode varchar(16) not null,
    energyConsumptionKWh int not null, 
    energyCost decimal(5,2) not null,
    providerName varchar(256) not null,
    primary key (month, year, address, city, state, zipcode, providerName),
    FOREIGN KEY (address, city, state, zipcode)
        REFERENCES properties (address, city, state, zipcode)
        ON UPDATE RESTRICT ON DELETE RESTRICT,
	FOREIGN KEY (providerName)
        REFERENCES utilityProvider (providerName)
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
CREATE procedure addProperty(in _username varchar(256), in _address varchar(256), in _city varchar(128), in _state varchar(2), in _zipcode varchar(16))
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
CREATE procedure removeProperty(in _username varchar(256), in _address varchar(256), in _city varchar(128), in _state varchar(2), in _zipcode varchar(16))
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

-- For adding a new utility bill to the database
-- Returns response message, 0 for success or 1 otherwise
drop procedure if exists addBill;
delimiter $$
CREATE procedure addBill(in _month int, in _year int, in _address varchar(256), in _city varchar(128), in _state varchar(2),
	in _zipcode varchar(16), in _energyConsumptionKWh int, in _energyCost decimal(5,2), in _providerName varchar(256))
BEGIN
	declare duplicate_entry_for_key tinyint default false;
    declare user_does_not_exist tinyint default false;
    declare continue handler for 1062 set duplicate_entry_for_key = true;
    declare continue handler for 1452 set user_does_not_exist = true;
    
    
	INSERT INTO utilityBill (month, year, address, city, state, zipcode, energyConsumptionKWh, energyCost, providerName)
    VALUES(_month, _year, _address, _city, _state, _zipcode, _energyConsumptionKWh, _energyCost, _providerName);
    
    -- if user_does_not_exist = true then
-- 		select 'The current user does not exist in the database.' as response_msg,
-- 			1 as response_code;
    if duplicate_entry_for_key = true then
		select 'That bill already exists.' as response_msg,
			1 as response_code;
	else
		select 'Bill added to your portfolio.' as response_msg,
			0 as response_code;	-- on success
	end if;
END
$$
delimiter ;
--  -------------------------------------------------------------------------------------------------------------------------------
-- For removing a property from the database
-- Returns response message, 0 for success or 1 otherwise
drop procedure if exists removeBill;
delimiter $$
CREATE procedure removeBill(in _month int, in _year int, in _address varchar(256), in _city varchar(128),
in _state varchar(2), in _zipcode varchar(16), in _providerName varchar(256))
BEGIN
    declare user_does_not_exist tinyint default false;
    declare continue handler for 1452 set user_does_not_exist = true;
    
    if exists (select 1 from utilitybill where month=_month and year=_year and address=_address
		and city=_city and state=_state and zipcode=_zipcode and providerName = _providerName) then
		delete from utilitybill where month=_month and year=_year and address=_address
			and city=_city and state=_state and zipcode=_zipcode and providerName = _providerName;
		select 'Bill removed from your portfolio.' as response_msg,
			0 as response_code;	-- on success
	else
		select 'That bill does not exist.' as response_msg,
			1 as response_code;
	end if;
END
$$
delimiter ;

-- TESTS
select * from utilitybill;
call addBill('1', '2021', '1', '2', 'MA', '3', 50,50,'Eversource');
call removeBill('1', '2021', '1', '2', 'MA', '3', 'Eversource');
call removeBill('70', '2021', '1', '2', 'MA', '3', 'Eversource');
delete from utilitybill where month='1' and year='2021' and address='1'
		and city='2' and state='MA' and zipcode='3' and providerName = 'Eversource';

--  -------------------------------------------------------------------------------------------------------------------------------
-- Returns all bills for a given property
drop procedure if exists getAllBills;
delimiter $$
CREATE procedure getAllBills(in _address varchar(256), in _city varchar(128), in _state varchar(2), _zipcode varchar(16))
BEGIN
	select month, year, energyConsumptionKWh, energyCost, providerName from utilityBill where address = _address and city = _city and state = _state and zipcode = _zipcode;
END
$$
delimiter ;

-- TESTS
select * from utilitybill;
call getAllBills('1','2','MA','3');

--  -------------------------------------------------------------------------------------------------------------------------------
-- For adding a new utility provider to the database
-- Returns response message, 0 for success or 1 otherwise
drop procedure if exists addProvider;
delimiter $$
CREATE procedure addProvider(_name varchar (256))
BEGIN
	declare duplicate_entry_for_key tinyint default false;
    declare user_does_not_exist tinyint default false;
    declare continue handler for 1062 set duplicate_entry_for_key = true;
        
	INSERT INTO utilityProvider (providerName) VALUES(_name);

    if duplicate_entry_for_key = true then
		select 'That provider already exists.' as response_msg,
			1 as response_code;
	else
		select 'Utility Provider added.' as response_msg,
			0 as response_code;	-- on success
	end if;
END
$$
delimiter ;

--  -------------------------------------------------------------------------------------------------------------------------------
-- Returns all utility providers available
drop procedure if exists getAllProviders;
delimiter $$
CREATE procedure getAllProviders()
BEGIN
	select providerName from utilityProvider;
END
$$
delimiter ;

-- TESTS
call getAllProviders();
--  -------------------------------------------------------------------------------------------------------------------------------
-- -- Returns all utility providers for a specific property
drop procedure if exists getPropertyProviders;
delimiter $$
CREATE procedure getPropertyProviders(in _address varchar(256), in _city varchar(128), in _state varchar(2), _zipcode varchar(16))
BEGIN
	select distinct providerName from utilityBill where address=_address and city=_city and state=_state and zipcode=_zipcode;
END
$$
delimiter ;

-- Test
call addProvider('National Electric');
call addBill ('5', '2020', '1','2','MA','3', '456', '768', 'National Electric');
call getPropertyProviders('1','2','MA','3');
call getAllProviders();

--  -------------------------------------------------------------------------------------------------------------------------------
-- Bulk test tuples
select * from properties;
select * from users;
select * from utilitybill;
select * from utilityprovider;
call addUser('dantaki', '1234');
call addProperty('dantaki', '1','2','MA','3');
call addProperty('dantaki', '1','2','MA','4');
call addProperty('dantaki', '1','2','MA','5');
call addProvider('National Electric');
call addProvider('Eversource');
call addProvider('Solar');
call addBill(1, 2021,'1','2','MA','3', 500,50,'Eversource');
call addBill(2, 2021,'1','2','MA','3', 500,51,'Eversource');
call addBill(2, 2021,'1','2','MA','3', 500,51,'Solar');
