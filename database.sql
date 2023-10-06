create database taskmanager;
use taskmanager;
create table task(
    id int auto_increment primary key,
    task varchar(255) not null,
    isfinished boolean not null
)
