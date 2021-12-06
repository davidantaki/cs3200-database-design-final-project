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
drop table if exists users;
create table if not exists users(
	userID int not null unique auto_increment primary key,
    username varchar(255) not null unique,
    passwordHash binary(32) not null
);

select * from users;
-- replace into users (username, passwordHash) VALUES("test", md5("1234"));

-- create table if not exists utilityBills(
-- 	
-- );



--  -------------------------------------------------------------------------------------------------------------------------------
-- For adding a new user to the database.
-- Returns reponse message, 0 for success or 1 otherwise
drop procedure if exists addUser;   
delimiter $$
CREATE procedure addUser(in _username VARCHAR(255), in _pass VARCHAR(255)) 
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
delete from users where username = "dantaki1";
call addUser('dantaki', '1234');
--  -------------------------------------------------------------------------------------------------------------------------------

-- Checks whether the given username and password are correct.
-- Returns 0 if both username and password are correct.
-- Returns 1 if either username or password are incorrect
drop function if exists checkUserPass;
delimiter $$
create function checkUserPass(sp1 varchar(255), sp2 varchar(255))
	returns int deterministic contains sql
    begin
		declare sp1Size int;
        declare sp2Size int;
        select size into sp1Size from lotr_species where species_name = sp1;
        select size into sp2Size from lotr_species where species_name = sp2;
        if sp1Size = sp2Size then
			return 0;
		elseif sp1Size > sp2Size then
			return 1;
		else
			return -1;
		end if;
    end $$
delimiter ;

select * from lotr_species;

-- TESTS
select checkUserPass('balrog', 'dwarf');	-- should return 1
select checkUserPass('human', 'orc');	-- should return 0
select checkUserPass('dwarf', 'elf');	-- should return -1

--  -------------------------------------------------------------------------------------------------------------------------------