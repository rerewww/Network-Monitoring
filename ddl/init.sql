create user 'test'@'localhost' identified by 'test';
create database localhost character set=utf8;

grant all privileges on localhost.* to 'test'@'localhost';

create table localhost.revision (
	local_address varchar(100),
	remote_address varchar(100),
	protocol varchar(100),
	info varchar(100)
) engine=InnoDB character set = utf8;