# Liquibase dengan Docker #

Cara menjalankan migrasi database dengan liquibase yang dijalankan dengan Docker.

* Karena kita menggunakan driver database MySQL yang tidak boleh didistribusikan, maka kita harus membuat custom image.
* Jalankan perintah berikut untuk membuat docker image

    ```
    docker build . -t liquibase-mysql
    ```

* Sebagai database percobaan, kita menjalankan MySQL versi 8 di Docker Compose, mengekspos port 33061

    ```
    docker compose up -d
    ```

* Cari tau nama container MySQL yang baru kita jalankan

    ```
    docker ps
    ```

    Outputnya sebagai berikut:

    ```
    CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS                                NAMES
    e40e7531eeeb   mysql:8   "docker-entrypoint.s…"   16 minutes ago   Up 16 minutes   33060/tcp, 0.0.0.0:33061->3306/tcp   db-migration-liquibase-db-belajar-1
    ```

    Berarti nama containernya adalah `db-migration-liquibase-db-belajar-1`

* Login ke dalam container MySQL dengan perintah berikut

    ```
    docker exec -it db-migration-liquibase-db-belajar-1 mysql -u belajar belajardb -p    
    ```

    Masukkan password `belajar123`. Kita akan berhasil login. Tampilannya sebagai berikut

    ```
    Welcome to the MySQL monitor.  Commands end with ; or \g.
    Your MySQL connection id is 8
    Server version: 8.4.3 MySQL Community Server - GPL

    Copyright (c) 2000, 2024, Oracle and/or its affiliates.

    Oracle is a registered trademark of Oracle Corporation and/or its
    affiliates. Other names may be trademarks of their respective
    owners.

    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

    mysql> 
    ```

* Setelah login, cek tabel-tabel dalam database. Seharusnya belum ada tabel apa-apa karena ini database baru.

    ```
    mysql> show tables;
    Empty set (0.01 sec)
    ```


* Buka terminal baru dan jalankan perintah berikut untuk menjalankan custom image kita yang akan menjalankan migrasi database dengan Liquibase

    ```
    docker run --rm -v ${PWD}/changelog:/liquibase/changelog -v ${PWD}/jdbc-driver:/liquibase/classpath liquibase-mysql --defaults-file=/liquibase/changelog/liquibase.properties update
    ```

* Bila Anda menggunakan Windows, variabel `${PWD}` tidak akan jalan dengan command prompt ori. Gunakan powershell atau git bash.

* Setelah dijalankan, output sukses tampilannya sebagai berikut

    ```
    ####################################################
    ##   _     _             _ _                      ##
    ##  | |   (_)           (_) |                     ##
    ##  | |    _  __ _ _   _ _| |__   __ _ ___  ___   ##
    ##  | |   | |/ _` | | | | | '_ \ / _` / __|/ _ \  ##
    ##  | |___| | (_| | |_| | | |_) | (_| \__ \  __/  ##
    ##  \_____/_|\__, |\__,_|_|_.__/ \__,_|___/\___|  ##
    ##              | |                               ##
    ##              |_|                               ##
    ##                                                ## 
    ##  Get documentation at docs.liquibase.com       ##
    ##  Get certified courses at learn.liquibase.com  ## 
    ##                                                ##
    ####################################################
    Starting Liquibase at 12:41:34 using Java 17.0.12 (version 4.29.2 #3683 built at 2024-08-29 16:45+0000)
    Liquibase Version: 4.29.2
    Liquibase Open Source 4.29.2 by Liquibase
    Running Changeset: migrations/changelog-2024101701.sql::1::endy
    Running Changeset: migrations/changelog-2024101702.sql::1::endy

    UPDATE SUMMARY
    Run:                          2
    Previously run:               0
    Filtered out:                 0
    -------------------------------
    Total change sets:            2

    Liquibase: Update has been successful. Rows affected: 2
    Liquibase command 'update' was executed successfully.
    ```

* Kembali ke terminal yang menjalankan MySQL, dan cek lagi tabel-tabelnya.

    ```
    mysql> show tables;
    +-----------------------+
    | Tables_in_belajardb   |
    +-----------------------+
    | customer              |
    | databasechangelog     |
    | databasechangeloglock |
    | merchant              |
    +-----------------------+
    4 rows in set (0.02 sec)
    ```


# Referensi 

* [Driver MySQL tidak diinclude dalam image docker Liquibase](https://docs.liquibase.com/workflows/liquibase-community/using-liquibase-and-docker.html)