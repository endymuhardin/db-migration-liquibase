--liquibase formatted sql
--changeset endy:2

alter table customer 
    rename column mobile_phone to phone_number;
