--liquibase formatted sql
--changeset endy:1
create table customer (
    id varchar(36),
    customer_name varchar(200) not null,
    email varchar(100) not null,
    mobile_phone varchar(50) not null,
    primary key (id)
);

create table merchant (
    id varchar(36),
    merchant_name varchar(20) not null,
    primary key (id)
);