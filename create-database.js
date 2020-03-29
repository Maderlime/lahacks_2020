const dotenv = require('dotenv');
const { Pool, Client } = require('pg');

dotenv.config();

const pool = new Pool({
  connectionString: process.env.CONNECTION
});

const dropPotholeString = "drop table pothole"
const dropPotholeDetailsString = "drop table pothole_details";

const potholeString = "\
    create table pothole (\
        id          SERIAL      primary key,\
        latitude    float(8)    not null,\
        longitude   float(8)    not null\
    )\
";

const potholeDetailsString = "\
    create table pothole_details (\
        id          INT      primary key,\
        picture     BYTEA,\
        rating      float(8),\
        description TEXT\
    )\
";
//pool.query(dropPotholeString, console.log);
//pool.query(dropPotholeDetailsString, console.log);
pool.query(potholeString, console.log);
pool.query(potholeDetailsString, console.log);